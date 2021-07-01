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
    vecroty(angle::F)::Matrix{F} where {F<:AbstractFloat}

Transformation matrix for a rotation around the y axis.

Return the (4x4) Transformation matrix for a rotation about the y axis by the
defined angle.

The matrix is:

    [  cos(angle)       0        sin(angle)       0]
    [      0            1            0            0]
    [ -sin(angle)       0        cos(angle)       0]
    [      0            0            0            1]

# Arguments:
- `angle`: rotation angle defined in radians

# Output:
- `ry`: (4x4) Transformation matrix.

# Examples:
```julia-repl
julia> ry = vecroty(angle)
```

Rotate the NURBS line `[0.0;0.0;0.0]` - `[3.0;3.0;3.0]` by 45 degrees around
the y-axis

```julia-repl
julia> line = nrbline(vec([0.0 0.0 0.0]),vec([3.0 3.0 3.0]));
julia> rotate = vecroty(pi/4);
julia> rline = nrbtform(line, rotate)
```

# Reference
- see also: [`nrbtform`](@ref)
"""
function vecroty(angle::F)::Matrix{F} where {F<:AbstractFloat}
sn = sin(angle);
cn = cos(angle);
ry = [ cn   0  sn   0;
        0   1   0   0;
      -sn   0  cn   0;
        0   0   0   1];
return ry;
end # vecroty
