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
    demogeom()

Demonstration of how to construct a 2D geometric shape from a piece-wise set of
NURBSs.

# Examples:
```julia
julia> demogeom()
```
"""
function demogeom()
coefs = [0.0 7.5 15.0 25.0 35.0 30.0 27.5 30.0;
         0.0 2.5  0.0 -5.0  5.0 15.0 22.5 30.0];
knots = vec([0.0 0.0 0.0 1/6 1/3 1/2 2/3 5/6 1.0 1.0 1.0]);

# Geometric boundary curve
geom = [
  nrbmak(coefs,knots);
  nrbline([30.0;30.0],[20.0;30.0]);
  nrbline([20.0;30.0],[20.0;20.0]);
  nrbcirc(10.0,[10.0;20.0],1.5*pi,0.0);
  nrbline([10.0;10.0],[0.0;10.0]);
  nrbline([0.0;10.0],[0.0;0.0]);
  nrbcirc(5.0,[22.5;7.5])
];

plot(title = "2D Geometry formed by a series of NURBS curves.",
     framestyle=:box,
     legend = false);
for i in geom
  nrbplot!(i,50);
end # for i
current();
end # demogeom
