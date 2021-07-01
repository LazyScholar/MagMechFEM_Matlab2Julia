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
    vectrans(tvec::Vector{F})::Matrix{F} where {F<:AbstractFloat}

Transformation matrix for a translation.

Returns a (4x4) Transformation matrix for translation.

The matrix is:

    [ 1   0   0  tx ]
    [ 0   1   0  ty ]
    [ 0   0   1  tz ]
    [ 0   0   0   1 ]

# Arguments:
- `tvec`: A vectors defining the translation along the x,y and z axes.
  i.e. `[tx; ty; ty]`

# Output:
- `st`: Translation Transformation Matrix

# Examples:
```julia-repl
julia> st = vectrans(tvec)
```

Translate the NURBS line `[0.0;0.0;0.0]` - `[1.0;1.0;1.0]` by 3 along the
x-axis, 2 along the y-axis and 4 along the z-axis.

```julia-repl
julia> line = nrbline(vec([0.0 0.0 0.0]),vec([1.0 1.0 1.0]));
julia> trans = vectrans(vec([3.0 2.0 4.0]));
julia> tline = nrbtform(line, trans);
```

# Reference
- see also: [`nrbtform`](@ref)
"""
function vectrans(tvec::Vector{F})::Matrix{F} where {F<:AbstractFloat}
if length(tvec) < 1 || length(tvec) > 3
  throw(ArgumentError("Translation vector required"));
end
v = [tvec;0;0];
st = [1.0   0   0 v[1];
        0 1.0   0 v[2];
        0   0 1.0 v[3];
        0   0   0 1.0];
return st;
end # vectrans
