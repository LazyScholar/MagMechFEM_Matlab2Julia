#    Copyright (c) 2021 J.A. Duffek
#    Copyright (c) 2000 D.M. Spink
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, see <http://www.gnu.org/licenses/>.

"""
    nrbeval(nurbs::NURBS{I,F},
            tt::Union{Vector{F}, Vector{Vector{F}}, Matrix{F}} [,
            flag::Symbol=:cartesian]
           ) where {I<:Integer, F<:AbstractFloat}

Evaluate a NURBS structure at parametric points.

Evaluation of NURBS curves or surfaces at parametric points along the U and V
directions. Either homogeneous coordinates are returned if the flag is set
accordingly otherwise cartesian coordinates. This function utilises the
function [`bspeval`](@ref).

# Arguments:
- `nurbs`: NURBS structure
- `tt`: parametric evaluation points either as `Vector{F}` or
  `Vector{Vector{F}}`
- `flag`: flag indicating that cartesian coordinates or homogeneous coordinates
  should be returned (valid values: `:cartesian` (default) or `:homogeneous`)

# Output:
- `p::Union{Matrix{F},Array{F,3}}`: Evaluated points on the NURBS curve or
   surface as cartesian coordinates (x,y,z). If `flag=:homogeneous` is set the
   points are returned as homogeneous coordinates (wx,wy,wz).
- `w::Union{Vector{F},Matrix{F}}`: Weights of the homogeneous coordinates of
  the evaluated points. Note: Only returned it the corresponding flag is set
  (see above).

# Examples:
```julia
julia> p = nrbeval(nurbs,tt)
julia> p,w = nrbeval(nurbs,tt,:homogeneous)
julia> p = nrbeval(srf,[ut,vt])
```

Evaluate the NURBS circle at twenty points from 0.0 to 1.0.
```julia
julia> nrb = nrbcirc;
julia> ut = range(0.0,stop=1.0,length=20)
julia> p = nrbeval(nrb,ut)
```

!!! note "Note:"
    Contrary to the Matlab version does this ported version evaluates not the
    `varargout` count to switch between different return values. A symbol
    `flag` is used instead.

# Reference
- see also: [`bspeval`](@ref)
"""
function nrbeval(nurbs::NURBS{I,F},
                 tt::Union{Vector{F}, Vector{Vector{F}}, Matrix{F}},
                 flag::Symbol=:cartesian
                ) where {I<:Integer,F<:AbstractFloat}
# TODO: this ported version does not do all the tests of the matlab version,
#       instead the type features of julia are used -> check if the matlab
#       errors get caught

# check if flag is a valid symbol
if !(flag in [:cartesian;:homogeneous])
  throw(ArgumentError("Valid flags are :cartesian or :homogeneous !"));
end # if

if typeof(nurbs)<:NURBS2D
  if typeof(tt)<:Vector{F}
    throw(ArgumentError("Parametric evaluation points for surfaces are " *
                        "either Vector{Vector{F}} or a two row Matrix{F} !"));
  end # if
  # NURBS structure represents a surface

  num1 = nurbs.number[1];
  num2 = nurbs.number[2];
  degree = nurbs.order .- 1;

  if typeof(tt)<:Vector{Vector{F}}
    # Evaluate over a [u,v] grid
    # tt[1] represents the u direction
    # tt[2] represents the v direction

    nt1 = length(tt[1]);
    nt2 = length(tt[2]);

    # Evaluate along the v direction
    val = reshape(nurbs.coefs,(4*num1,num2));
    val = bspeval(degree[2],val,nurbs.knots[2],tt[2]);
    val = reshape(val,(4, num1, nt2));

    # Evaluate alon the u direction
    val = permutedims(val,[1,3,2]);
    val = reshape(val,(4*nt2,num1));
    val = bspeval(degree[1],val,nurbs.knots[1],tt[1]);
    val = reshape(val,(4,nt2,nt1));
    val = permutedims(val,[1,3,2]);

    if flag == :cartesian
      w = @view val[4:4,:,:];
      return val[1:3,:,:] ./ repeat(w,outer=[3,1,1]);
    else
      w = val[4:4,:,:];
      p = val[1:3,:,:] ./ repeat(w,outer=[3,1,1]);
      return p,w;
    end # if
  else
    if typeof(tt)<:Matrix{F} && size(tt,1)!=2
      throw(ArgumentError("Scattered parametric evaluation points for " *
                          "surfaces must be of the type two row Matrix{F} !"));
    end # if
    # Evaluate at scattered points
    # tt[1,:] represents the u direction
    # tt[2,:] represents the v direction

    nt = size(tt,2);

    # Evaluate along the v direction
    val = reshape(nurbs.coefs,(4*num1,num2));
    val = bspeval(degree[2],val,nurbs.knots[2],tt[2,:]);
    val = reshape(val,(4, num1,nt));

    # Evaluate along the u direction
    pnts = zeros(F,(4,nt));
    for v in 1:nt
      pnts[:,v] = bspeval(degree[1],val[:,:,v],nurbs.knots[1],vec([tt[1,v]]));
    end # for v

    if flag == :cartesian
      w = @view pnts[4:4,:];
      return pnts[1:3,:] ./ w;
    else
      w = pnts[4,:];
      p = val[1:3,:] ./ w';
      return p,w;
    end # if
  end # if
else
  if !(typeof(tt)<:Vector{F})
    throw(ArgumentError("Valid parametric evaluation points for curve must " *
                        "be provided as Vector{F} !"));
  end # if
  # NURBS structure represents a curve
  # tt represent a vector of parametric points in the u direction

  val = bspeval(nurbs.order-1,nurbs.coefs,nurbs.knots,tt);

  if flag == :cartesian
    w = @view val[4:4,:];
    return val[1:3,:] ./ w;
  else
    w = val[4,:];
    p = val[1:3,:] ./ w';
    return p,w;
  end # if

end # if

end # nrbeval
