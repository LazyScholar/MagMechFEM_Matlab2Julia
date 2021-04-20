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
    nrbextrude(curve::NURBS1D{I,F},vector::Vector{F}
              )::NURBS2D{I,F} where {I<:Integer,F<:AbstractFloat}

Construct a NURBS surface by extruding a NURBS curve.

Constructs a NURBS surface by extruding a NURBS curve along a defined vector.
The NURBS curve forms the U direction of the surface edge, and extruded along
the vector in the V direction. Note NURBS surfaces cannot be extruded.

# Arguments:
- `crv`: NURBS curve to extrude, see nrbmak.
- `vec`: Vector along which the curve is extruded.

# Output:
- `srf`: NURBS surface constructed.

# Examples:
```julia
julia> srf = nrbextrude(crv,vec)
```

Form a hollow cylinder by extruding a circle along the z-axis.

```julia
srf = nrbextrude(nrbcirc(),[0.0;0.0;1.0]);
```
"""
function nrbextrude(curve::NURBS1D{I,F},vector::Vector{F}
                   )::NURBS2D{I,F} where {I<:Integer,F<:AbstractFloat}
if length(vector) != 3
  throw(ArgumentError("Extrusion vector has to be a 3D vector!"));
end # if
coefs = cat(curve.coefs,vectrans(vector)*curve.coefs,dims=3);
return nrbmak(coefs,[curve.knots,vec([0.0 0.0 1.0 1.0])]);
end # nrbextrude
