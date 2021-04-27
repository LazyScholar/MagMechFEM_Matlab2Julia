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
    nrbline()::NURBS1D

or

    nrbline(p1::Vector{F},p2::Vector{F})::NURBS1D where {F<:AbstractFloat}

Construct a straight line.

Constructs NURBS data structure for a straight line. If coordinates are
included the function returns a unit straight line along the x-axis.

# Arguments:
- `p1`: 2D or 3D cartesian coordinate of the start point.
- `p2`: 2D or 3D cartesian coordinate of the end point.

# Output:
- `crv`: NURBS curve for a straight line.

# Examples:
```julia-repl
julia> crv = nrbline()
julia> crv = nrbline(p1,p2)
```
"""
function nrbline(p1::Vector{F},p2::Vector{F})::NURBS1D where {F<:AbstractFloat}
if length(p1) > 3 || length(p2) > 3 || length(p1) != length(p2)
  throw(ArgumentError("Only vectors up to 3D with equal length allowed!"));
end # if
coefs = zeros(F,(4,2));
coefs[4,:] .= 1;
coefs[1:length(p1),1] = p1[:];
coefs[1:length(p2),2] = p2[:];
return nrbmak(coefs, vec([0.0 0.0 1.0 1.0]));
end # nrbline

# overloading of function nrbline with zero arguments
function nrbline()
coefs = zeros(typeof(1.0),(4,2));
coefs[4,:] .= 1;
coefs[1,2] = 1;
return nrbmak(coefs, vec([0.0 0.0 1.0 1.0]));
end # nrbline
