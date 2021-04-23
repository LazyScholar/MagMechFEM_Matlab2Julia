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
    democirc()

Demonstration of a circle arcs in the x-y plane.

# Examples:
```julia
julia> democirc()
```
"""
function democirc()
plot(title = "NURBS construction of a 2D circle and arc.",
     framestyle=:box,
     legend = false);
for r in 1.0:9.0
  crv = nrbcirc(r,[0.0;0.0;0.0],deg2rad(45),deg2rad(315));
  nrbplot!(crv,50);
end # for r
current();
end # democirc
