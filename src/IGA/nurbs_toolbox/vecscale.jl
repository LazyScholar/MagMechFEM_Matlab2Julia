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
    vecscale(svec::Vector{F})::Matrix{F} where {F<:AbstractFloat}

Transformation matrix for a scaling.

Returns a (4x4) Transformation matrix for scaling.

The matrix is:

    [ sx  0   0   0]
    [ 0   sy  0   0]
    [ 0   0   sz  0]
    [ 0   0   0   1]

# Arguments:
- `svec`: A vectors defining the scaling along the x,y and z axes.
  i.e. `[sx; sy; sy]`

# Output:
- `st`: Scaling Transformation Matrix

# Examples:
```julia
julia> ss = vecscale(svec)
```

Scale up the NURBS line `[0.0;0.0;0.0]` - `[1.0;1.0;1.0]` by 3 along the
x-axis, 2 along the y-axis and 4 along the z-axis.

```julia
julia> line = nrbline(vec([0.0 0.0 0.0]),vec([1.0 1.0 1.0]));
julia> scale = vecscale(vec([3.0 2.0 4.0]));
julia> sline = nrbtform(line, scale)
```

# Reference
- see also: [`nrbtform`](@ref)
"""
function vecscale(svec::Vector{F})::Matrix{F} where {F<:AbstractFloat}
if length(svec) < 1 || length(svec) > 3
  throw(ArgumentError("Translation vector required"));
end
s = [svec;1;1];
ss = [s[1]    0    0   0;
      0    s[2]    0   0;
      0       0 s[3]   0;
      0       0    0   1];
return ss;
end # vecscale
