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
    nrbdeval(nurbs::NURBS{I,F},
             dnurbs::Union{NURBS1D{I,F}, Vector{NURBS2D{I,f}}},
             tt::Union{Vector{F}, Vector{Vector{F}}, Matrix{F}}
            ) where {I<:Integer,F<:AbstractFloat}

Evaluation of the derivative NURBS curve or surface.

# Arguments:
- `nurbs`: NURBS structure
- `dnurbs`: NURBS derivative representation of `nurbs`
- `tt`: parametric evaluation points either as `Vector{F}` or
  `Vector{Vector{F}}`

# Output:
- `pnt::Union{Matrix{F},Array{F,3}}`: Evaluated points.
- `jac::Union{Matrix{F}, Vector{Array{F,3}}}`: Evaluated first derivatives
  (Jacobian).

# Examples:
```julia
julia> pnt, jac = nrbdeval(nurbs, dnurbs, tt)
julia> pnt, jac = nrbdeval(nurbs, dnurbs, [tu,tv])
```

Determine the first derivatives a NURBS curve at 9 points for 0.0 to 1.0.
```julia
julia> tt = collect(range(0.0, 1.0, length=9));
julia> dcrv = nrbderiv(crv);
julia> pnts, jac = nrbdeval(crv, dcrv, tt)
```

# Reference
- see also: [`nrbeval`](@ref), [`nrbderiv`](@ref)
"""
function nrbdeval(nurbs::NURBS{I,F},
                  dnurbs::Union{NURBS1D{I,F}, Vector{NURBS2D{I,F}}},
                  tt::Union{Vector{F}, Vector{Vector{F}}, Matrix{F}}
                 ) where {I<:Integer,F<:AbstractFloat}

cp, cw = nrbeval(nurbs,tt,:homogeneous);
pnt = cp ./ cw;

if typeof(nurbs)<:NURBS2D
  if !(typeof(dnurbs)<:Vector{NURBS2D{I,F}}) || length(dnurbs) != 2
    throw(ArgumentError("dnurbs has to be a vector of length 2 containing " *
                        "NURBS2D data structures!"));
  end # if
  # NURBS structure represents a surface

  jac = Vector{Array{F,3}}(undef,2);

  cup, cuw = nrbeval(dnurbs[1], tt, :homogeneous);
  jac[1] = (cup .- cuw .* pnt) ./ cw;

  cvp, cvw = nrbeval(dnurbs[2], tt, :homogeneous);
  jac[2] = (cvp .- cvw .* pnt) ./ cw;

  return pnt,jac;
else
  if !(typeof(dnurbs)<:NURBS1D{I,F})
    throw(ArgumentError("dnurbs for 1D NURBS is always a NURBS1D!"));
  end # if
  # NURBS structure represents a curve

  cup, cuw = nrbeval(dnurbs, tt, :homogeneous);
  jac = (cup .- cuw .* pnt) ./ cw;

  return pnt,jac;
end # if
end # nrbdeval
