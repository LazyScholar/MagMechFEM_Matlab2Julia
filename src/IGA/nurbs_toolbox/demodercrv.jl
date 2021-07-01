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
    demodercrv()

Demonstrates the construction of a general curve and determine of the
derivative.

# Examples:
```julia-repl
julia> demodercrv()
```
"""
function demodercrv()
# make and draw nurbs test curve
crv = nrbtestcrv();
nrbplot(crv,48,
        title = "First derivatives along a test curve.",
        lw =1.0,
        c = :green,
        framestyle=:box,
        legend = false);

npts = 9;
tt = collect(range(0.0,1.0,length=npts));

# first derivative
dcrv = nrbderiv(crv);
p1, dp = nrbdeval(crv,dcrv,tt);

p2 = vecnorm_toolbox(dp);

plot!(p1[1,:],p1[2,:],
      m = (3, :transparent, stroke(1, :red)),
      st = :scatter,
      legend = false);
plot!(p1[1,:],p1[2,:],
      st=:quiver,
      quiver=(p2[1,:],p2[2,:]),
      c=:red);
end # demodercrv
