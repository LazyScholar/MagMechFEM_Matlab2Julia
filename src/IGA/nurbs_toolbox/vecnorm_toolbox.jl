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
    vecnorm_toolbox(vec::Matrix{F})::Matrix{F} where {F<:AbstractFloat}

or

    vecnorm_toolbox(vec::Vector{F})::Vector{F} where {F<:AbstractFloat}

Normalises the array of vectors, returning the unit vectors.

# Arguments:
- `vec`: An array of column vectors represented by a matrix of size `(dim,nv)`,
  where `dim` is the dimension of the vector and `nv` the number of vectors.

# Output:
- `nvec`: Normalised vectors, matrix the smae size as vec.

# Examples:
```julia
julia> nvec = vecnorm_toolbox(vec)
```

Normalise the two vectors (0.0,2.0,1.3) and (1.5,3.4,2.3).
```julia
julia> nvec = vecnorm_toolbox([0.0 1.5; 2.0 3.4; 1.3 2.3])
```
"""
function vecnorm_toolbox(vec::Matrix{F})::Matrix{F} where {F<:AbstractFloat}
return vec ./ sqrt.(sum(vec.^2,dims=1));
end # vecnorm_toolbox

# TODO: look if this is even necessary for this toolbox (using LinearAlgebra)
# overloaded function for vector input to get a float instead of a vector
function vecnorm_toolbox(vec::Vector{F})::Vector{F} where {F<:AbstractFloat}
return vec ./ sqrt(vec' * vec);
end # vecnorm_toolbox
