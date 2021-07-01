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
    demokntins()

Demonstration of the knot insertion algorithm.

# Examples:
```julia-repl
julia> demokntins()
```
"""
function demokntins()
crv = nrbtestcrv();

# plot the control points
plot(crv.coefs[1,:],crv.coefs[2,:],
     title = "Knot insertion along test curve.",
     m = (7, :transparent, stroke(1, :green)),
     lw =1.0,
     c = :green,
     linestyle =:dash,
     framestyle=:box,
     legend = false);

# plot the nurbs curve
nrbplot!(crv,48);

# insert new knots and plot new control points
icrv = nrbkntins(crv,vec([0.125 0.375 0.625 0.875]));
plot!(icrv.coefs[1,:],icrv.coefs[2,:],
     m = (7, :transparent, stroke(1, :red)),
     lw =1.0,
     c = :red,
     linestyle =:dash,
     legend = false);
end # demokntins
