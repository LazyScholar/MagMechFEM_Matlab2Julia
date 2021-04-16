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
    nrbcylind(height::F=1.0,radius::F=1.0,center::Vector{Any}=[],
              sang::F=0.0,eang::F=2.0*π)::NURBS2D where {F<:AbstractFloat}

Construct a cylinder or cylindrical patch by extruding a circular arc (see
[`nrbcirc`](@ref)).

# Arguments:
- `height`: Height of the cylinder along the axis, default `1.0`.
- `radius`: Radius of the circle, default `1.0`.
- `center`: Center of the circle, default `[0.0;0.0;0.0]`
- `sang`: Start angle relative to the origin, default `0.0`.
- `eang`: End angle relative to the origin, default `2.0*π`.

# Output:
- `srf`: NURBS surface of a extruded circular arc.

# Examples:
```julia
julia> crv = nrbcylind()
julia> crv = nrbcylind(height,radius)
julia> crv = nrbcylind(height,radius)
julia> crv = nrbcylind(height,radius,center)
julia> crv = nrbcylind(height,radius,center,sang,eang)
```

# References:
- see also [`nrbcirc`](@ref)
"""
function nrbcylind(height::F=1.0,radius::F=1.0,center::Vector{Any}=[],
                   sang::F=0.0,eang::F=2.0*π)::NURBS2D where {F<:AbstractFloat}
# TODO: maybe revisit this function and split it up
# TODO: optional arguments should be at the end the center=[] solution is
#       therefore a bad hack
return nrbextrude(nrbcirc(radius,center,sang,eang),vec([0.0 0.0 height]));
end # nrbcylind
