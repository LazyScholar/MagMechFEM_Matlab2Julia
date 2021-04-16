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
    vecdot(vec1::Matrix{F},vec2::Matrix{F})::Matrix{F} where {F<:AbstractFloat}

or

    vecdot(vec1::Vector{F},vec2::Vector{F})::F where {F<:AbstractFloat}

Determines scalar dot product of two vectors.

# Arguments:
- `vec1`, `vec2`: An array of column vectors represented by a matrix of size
  `(dim,nv)`, where `dim` is the dimension of the vector and `nv` the number
  of vectors.

# Output:
- `dot`: Row vector of scalars, each element corresponding to the dot product
  of the respective components in vec1 and vec2.

# Examples:
```julia
julia> dot = vecdot(vec2,vec2)
```
Determine the dot product of

    [2.3;3.4;5.6] and [1.2;4.5;1.2]
    [5.1;0.0;2.3] and [2.5;3.2;4.0]

```julia
julia> dot = vecdot([2.3 5.1; 3.4 0.0; 5.6 2.3],[1.2 2.5; 4.5 3.2; 1.2 4.0])
```
"""
function vecdot(vec1::Matrix{F},vec2::Matrix{F}
               )::Matrix{F} where {F<:AbstractFloat}
return sum(vec1 .* vec2,dims=1);
end # vecdot

# TODO: look if this is even necessary for this toolbox (using LinearAlgebra)
# overloaded function for vector input to get a float instead of a vector
function vecdot(vec1::Vector{F},vec2::Vector{F})::F where {F<:AbstractFloat}
return vec1' * vec2;
end # vecdot
