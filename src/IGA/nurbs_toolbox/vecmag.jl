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
    vecmag(vec::Matrix{F})::Matrix{F} where {F<:AbstractFloat}

or

    vecmag(vec::Vector{F})::F where {F<:AbstractFloat}

Determines the magnitude of vectors.

# Arguments:
- `vec`: An array of column vectors represented by a matrix of size `(dim,nv)`,
  where `dim` is the dimension of the vector and `nv` the number of vectors.

# Output:
- `mvec`: Magnitude of the vectors, vector of size `(1,nv)`.

# Examples:
```julia-repl
julia> mvec = vecmag(vec)
```

Find the magnitude of the two vectors `[0.0;2.0;1.3]` and `[1.5;3.4;2.3]`.
```julia-repl
julia> mvec = vecmag([0.0 1.5; 2.0 3.4; 1.3 2.3])
```
"""
function vecmag(vec::Matrix{F})::Matrix{F} where {F<:AbstractFloat}
return sqrt.(sum(vec.^2,dims=1));
end # vecmag

# TODO: look if this is even necessary for this toolbox (using LinearAlgebra)
# overloaded function for vector input to get a float instead of a vector
function vecmag(vec::Vector{F})::F where {F<:AbstractFloat}
return sqrt(vec' * vec);
end # vecmag
