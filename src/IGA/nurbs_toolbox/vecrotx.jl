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
    vecrotx(angle::F)::Matrix{F} where {F<:AbstractFloat}

Transformation matrix for a rotation around the x axis.

Return the (4x4) Transformation matrix for a rotation about the x axis by the
defined angle.

The matrix is:

    [ 1         0            0          0]
    [ 0     cos(angle)  -sin(angle)     0]
    [ 0     sin(angle)   cos(angle)     0]
    [ 0         0            0          1]

# Arguments:
- `angle`: rotation angle defined in radians

# Output:
- `rx`: (4x4) Transformation matrix.

# Examples:
```julia
julia> rz = vecrotx(angle)
```

Rotate the NURBS line (0.0 0.0 0.0) - (3.0 3.0 3.0) by 45 degrees
around the x-axis

```julia
julia> line = nrbline(vec([0.0 0.0 0.0]),vec([3.0 3.0 3.0]));
julia> rotate = vecrotx(pi/4);
julia> rline = nrbtform(line, rotate)
```

# Reference
- see also: [`nrbtform`](@ref)
"""
function vecrotx(angle::F)::Matrix{F} where {F<:AbstractFloat}
sn = sin(angle);
cn = cos(angle);
rx = [  1   0   0   0;
        0  cn -sn   0;
        0  sn  cn   0;
        0   0   0   1];
return rx;
end # vecrotx
