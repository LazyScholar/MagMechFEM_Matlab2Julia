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
    demoline()

Demonstration of a 3D straight line

# Examples:
```julia-repl
julia> demoline()
```
"""
function demoline()
crv = nrbline(vec([0.0 0.0 0.0]),vec([5.0 4.0 2.0]));
nrbplot(crv,1,
        title = "3D straight line.",
        legend = false);
end # demoline
