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
    demo4surf()

Demonstration of a bilinear surface.

# Examples:
```julia-repl
julia> demo4surf()
```
"""
function demo4surf()
# make and draw nurbs test surface
srf = nrb4surf([0.0;0.0;0.5],[1.0;0.0;-0.5],[0.0;1.0;-0.5],[1.0;1.0;0.5]);
nrbplot(srf,[10;10],
        title = "Construction of a bilinear surface.",
        c = :winter,
        legend = nothing,
        linewidth = 0.5,
        linecolor = :black,
        camera=[-30,30]);
end # demo4surf
