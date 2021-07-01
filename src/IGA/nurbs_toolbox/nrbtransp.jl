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
    nrbtransp(srf::NURBS2D{I,F}
             )::NURBS2D{I,F} where {I<:Integer,F<:AbstractFloat}

Transpose a NURBS surface, by swapping U and V directions.

Utility function that transposes a NURBS surface, by swapping U and V
directions. NURBS curves cannot be transposed.

# Arguments:
- `srf`: NURBS surface, see [`nrbmak`](@ref).

# Output:
- `tsrf`: NURBS surface with U and V diretions transposed.

# Examples:
```julia-repl
julia> tsrf = nrbtransp(srf)
```
"""
function nrbtransp(srf::NURBS2D{I,F}
                 )::NURBS2D{I,F} where {I<:Integer,F<:AbstractFloat}
return nrbmak(permutedims(srf.coefs,[1,3,2]),reverse(srf.knots));
end # nrbtransp
