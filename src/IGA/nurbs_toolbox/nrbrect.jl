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
    nrbrect()::NURBS1D

or

    nrbrect(size::F)::NURBS1D where {F<:AbstractFloat}

or

    nrbrect(width::F,height::F)::NURBS1D where {F<:AbstractFloat}

Construct NURBS representation of a rectangle.

Construct a rectangle or square in the x-y plane with the bottom corner at
(0,0,0). If there are no arguments provided the function constructs a unit
square.

# Arguments:
- `size`: Size of the square (width = height).
- `width`: Width of the rectangle (along x-axis).
- `height`: Height of the rectangle (along y-axis).

# Output:
- `crv`: NURBS curve for a straight line.

# Examples:
```julia
julia> crv = nrbrect()
julia> crv = nrbrect(size)
julia> crv = nrbrect(width, height)
```
"""
function nrbrect(w::F,h::F)::NURBS1D where {F<:AbstractFloat}
coefs  = [0 w w w w 0 0 0;
          0 0 0 h h h h 0;
          0 0 0 0 0 0 0 0;
          1 1 1 1 1 1 1 1];
knots  = vec([0 0 0.25 0.25 0.5 0.5 0.75 0.75 1 1]);
return nrbmak(coefs, knots);
end # nrbrect

# overloading of function nrbrect with one arguments
function nrbrect(size::F)::NURBS1D where {F<:AbstractFloat}
return nrbrect(size,size);
end # nrbrect

# overloading of function nrbrect with zero arguments
function nrbrect()::NURBS1D
return nrbrect(1.0,1.0);
end # nrbrect
