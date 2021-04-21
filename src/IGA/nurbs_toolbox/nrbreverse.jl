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
    nrbreverse(nurbs::NURBS{I,F}
            )::NURBS{I,F} where {I<:Integer,F<:AbstractFloat}

Utility function to reverse the evaluation direction of a NURBS curve or
surface.

# Arguments:
- `nurbs`: NURBS data structure (see nrbmak for details).

# Output:
- `rnurbs`: The transformed NURBS data structure.

# Examples:
```julia
julia> rnurbs = nrbreverse(nurbs)
```
"""
function nrbreverse(nurbs::NURBS{I,F}
                   )::NURBS{I,F} where {I<:Integer,F<:AbstractFloat}
if typeof(nurbs)<:NURBS2D
  # reverse a NURBS surface
  return nrbmak(reverse(nurbs.coefs,dims=(2,3)),
                [(1.0 .-reverse(nurbs.knots[1])),
                 (1.0 .-reverse(nurbs.knots[2]))]);
else
  # reverse a NURBS curve
  return nrbmak(reverse(nurbs.coefs,dims=2),1.0 .- reverse(nurbs.knots));
end # if
end # nrbreverse