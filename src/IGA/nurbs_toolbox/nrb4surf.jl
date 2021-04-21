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
    nrb4surf(p11::Vector{F},p12::Vector{F},p21::Vector{F},p22::Vector{F}
            )::NURBS2D where {F<:AbstractFloat}

Constructs a bilinear surface defined by four coordinates.

The position of the corner points

    ^ V direction
    |
    ----------------
    |p21        p22|
    |              |
    |    SRF       |
    |              |
    |p11        p12|
    -------------------> U direction

# Arguments:
- `p11`: Cartesian coordinate of the lhs bottom corner point.
- `p12`: Cartesian coordinate of the rhs bottom corner point.
- `p21`: Cartesian coordinate of the lhs top corner point.
- `p22`: Cartesian coordinate of the rhs top corner point.

# Output:
- `srf`: NURBS bilinear surface, see [`nrbmak`](@ref).

# Examples:
```julia
julia> srf = nrb4surf(p11,p12,p21,p22)
```
"""
function nrb4surf(p11::Vector{F},p12::Vector{F},p21::Vector{F},p22::Vector{F}
                 )::NURBS2D where {F<:AbstractFloat}
coefs = zeros(F,(4,2,2));
coefs[4,:,:] .= 1.0;
coefs[1:length(p11),1,1] = p11;
coefs[1:length(p12),1,2] = p12;
coefs[1:length(p21),2,1] = p21;
coefs[1:length(p22),2,2] = p22;
knots = [[0.0;0.0;1.0;1.0],[0.0;0.0;1.0;1.0]];
return nrbmak(coefs, knots);
end # nrb4surf
