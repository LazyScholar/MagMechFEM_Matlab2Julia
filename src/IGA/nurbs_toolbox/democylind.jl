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

using Plots;

"""
    democylind()

Demonstration of the construction of a cylinder.

# Examples:
```julia
julia> democylind()
```
"""
function democylind()
srf = nrbcylind(3.0,1.0,[],deg2rad(270),deg2rad(180));
nrbplot(srf,[20;20],
        title = "Cylindrical section by extrusion of a circular arc.",
        framestyle=:box,
        legend = false);
end # democylind
