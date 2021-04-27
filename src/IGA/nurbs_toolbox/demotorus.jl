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
    demotorus()

A second demonstration of surface construction.

# Examples:
```julia-repl
julia> demotorus()
```
"""
function demotorus()
sphere = nrbrevolve(nrbcirc(1.0),[1.0;0.0;0.0]);
nrbplot(sphere,[20;20],
        title = "Ball and torus - surface construction by revolution.",
        c=:copper,
        linewidth = 0.5,
        linecolor = :black,
        cbar=false);
torus = nrbrevolve(nrbcirc(0.2,[0.9;1.0]),[1.0;0.0;0.0]);
nrbplot!(torus,[20;10],
         c=:copper,
         linewidth = 0.5,
         linecolor = :black,
         cbar=false);
nrbplot!(nrbtform(torus,vectrans([-1.8])),[20;10],
         c=:copper,
         linewidth = 0.5,
         linecolor = :black,
         cbar=false);
# TODO: come back later as pyplot backend does not has light/shading yet
#       furthermore grid lines should be off and interpolated shading should be
#       on
end # demotorus
