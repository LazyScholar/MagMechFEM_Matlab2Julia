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
    veccross(vec1::Matrix{F},vec2::Matrix{F}
            )::Matrix{F} where {F<:AbstractFloat}

or

    veccross(vec1::Vector{F},vec2::Vector{F}
            )::Vector{F} where {F<:AbstractFloat}

Determines cross product of two vectors.

# Arguments:
- `vec1`, `vec2`: An array of column vectors represented by a matrix of size
  `(dim,nv)`, where `dim` is the dimension of the vector and `nv` the number
  of vectors.

# Output:
- `cross`: Array of column vectors, each element is corresponding to the cross
  product of the respective components in `vec1` and `vec2`.

# Examples:
```julia-repl
julia> cross = veccross(vec2,vec2)
```
Determine the cross product of

    [2.3;3.4;5.6] and [1.2;4.5;1.2]
    [5.1;0.0;2.3] and [2.5;3.2;4.0]

```julia-repl
julia> cross=veccross([2.3 5.1; 3.4 0.0; 5.6 2.3],[1.2 2.5; 4.5 3.2; 1.2 4.0])
```
"""
function veccross(vec1::Matrix{F},vec2::Matrix{F}
                 )::Matrix{F} where {F<:AbstractFloat}
if size(vec1,1) == 2 && size(vec2,1) == 2
  # 2D vector
  cross = zeros(F,(3,size(vec1,2)));
  cross[3,:] .= vec1[1,:] .* vec2[2,:] .- vec1[2,:] .* vec2[1,:];
  return cross;
elseif size(vec1,1) == 3 && size(vec2,1) == 3
  # 3D vector
  return [vec1[2:2,:] .* vec2[3:3,:] .- vec1[3:3,:] .* vec2[2:2,:];
          vec1[3:3,:] .* vec2[1:1,:] .- vec1[1:1,:] .* vec2[3:3,:];
          vec1[1:1,:] .* vec2[2:2,:] .- vec1[2:2,:] .* vec2[1:1,:]];
else
  throw(ArgumentError("Input has to be either 2D or 3D with equal dims!"));
end # if
end # veccross

using LinearAlgebra;

# TODO: look if this is even necessary for this toolbox (using LinearAlgebra)
# overloaded function for vector input to get a float instead of a vector
function veccross(vec1::Vector{F},vec2::Vector{F}
                 )::Vector{F} where {F<:AbstractFloat}
return cross(vec1,vec2);
end # veccross
