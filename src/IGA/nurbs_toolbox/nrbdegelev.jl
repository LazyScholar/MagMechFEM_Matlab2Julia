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
    nrbdegelev(nurbs::NURBS{I,F},ntimes::Union{I, Vector{I}}
              )::NURBS{I,F} where {I<:Integer,F<:AbstractFloat}

Degree elevates the NURBS curve or surface. This function uses the B-Spline
function [`bspdegelev`](@ref).

# Arguments:
- `nurbs`: NURBS structure (curve or surface see [`nrbmak`](@ref))
- `ntimes`: number or pair of numbers indicating how many times the structure
  shall be degree elevated along U direction or V direction

# Output:
- `enurbs`: new NURBS structure with degrees elevated

# Examples:
```julia
julia> ecrv = nrbdegelev(crv,utimes);
julia> esrf = nrbdegelev(srf,[utimes;vtimes]);
```

Increase the NURBS surface degree twice along the V direction.
```julia
julia> esrf = nrbdegelev(srf, 0, 2);
```

# Reference
- see also: [`bspdegelev`](@ref)
"""
function nrbdegelev(nurbs::NURBS{I,F},ntimes::Union{I, Vector{I}}
                   )::NURBS{I,F} where {I<:Integer,F<:AbstractFloat}
# TODO: this ported version does not do all the tests of the matlab version,
#       instead the type features of julia are used -> check if the matlab
#       errors get caught

degree = nurbs.order .- 1;

if typeof(nurbs)<:NURBS2D
  if typeof(ntimes)<:I || length(ntimes) != 2
    throw(ArgumentError("ntimes must be a integer vector of lenght 2 !"));
  end # if
  # NURBS represents a surface
  dim, num1, num2 = size(nurbs.coefs);
  knots = Vector{Vector{F}}(undef,2);

  # Degree elevate along the v direction
  if ntimes[2] == 0
    coefs = nurbs.coefs;
    knots[2] = nurbs.knots[2];
  else
    coefs = reshape(nurbs.coefs,(4*num1,num2));
    coefs, knots[2] = bspdegelev(degree[2],coefs,nurbs.knots[2],ntimes[2]);
    num2 = size(coefs,2);
    coefs = reshape(coefs,(4, num1, num2));
  end # if

  # Degree elevate along the u direction
  if ntimes[1] == 0
    knots[1] = nurbs.knots[1];
  else
    coefs = permutedims(coefs,[1,3,2]);
    coefs = reshape(coefs,(4*num2,num1));
    coefs, knots[1] = bspdegelev(degree[1],coefs,nurbs.knots[1],ntimes[1]);
    coefs = reshape(coefs,(4,num2,size(coefs,2)));
    coefs = permutedims(coefs,[1,3,2]);
  end # if

  # build the new nurbs surface
  return nrbmak(coefs,knots);
else
  if !(typeof(ntimes)<:I)
    # TODO; well it should be a unsigned integer
    throw(ArgumentError("Valid input of ntimes for curves is a integer!"));
  end # if

  # NURBS represents a curve
  if ntimes == 0
    coefs = nurbs.coefs;
    knots = nurbs.knots;
  else
    coefs, knots = bspdegelev(degree,nurbs.coefs,nurbs.knots,ntimes);
  end # if

  # build the new nurbs curve
  return nrbmak(coefs,knots);
end # if
end # nrbdegelev
