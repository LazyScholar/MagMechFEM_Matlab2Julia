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
    demorevolve()

Demonstration of surface construction by revolving a profile curve.

# Examples:
```julia-repl
julia> demorevolve()
```
"""
function demorevolve()
# Construct a test profile in the x-z plane
pnts = [3.0 5.5 5.5 1.5 1.5 4.0 4.5;
        0.0 0.0 0.0 0.0 0.0 0.0 0.0;
        0.5 1.5 4.5 3.0 7.5 6.0 8.5];
crv = nrbmak(pnts,vec([0 0 0 1/4 1/2 3/4 3/4 1 1 1]));

# rotate and vectrans by some arbitrary amounts.
xx = vecrotz(deg2rad(25)) * vecroty(deg2rad(15)) * vecrotx(deg2rad(20));
nrb = nrbtform(crv,vectrans([5.0;5.0])*xx);

# define axes of rotation
pnt = [5.0;5.0;0.0];
ver = xx * [0.0;0.0;1.0;1.0];
srf = nrbrevolve(nrb,ver[1:3],pnt);

# make and draw nurbs curve
p = nrbeval(srf,collect.([range(0.0,1.0,length=20),range(0.0,1.0,length=20)]));
Plots.pyplot();
plot(p[1,:,:], p[2,:,:], p[3,:,:],
     st = :surface,
     cbar = false,
     legend = false,
     camera = (-30, 30),
     title = "Construct of a 3D surface by revolution of a curve.",
     linewidth = 0.5,
     linecolor = :black,
     c=:copper);
# TODO: come back later as pyplot backend does not has light/shading yet
#       furthermore grid lines should be off and interpolated shading should be
#       on
end # demorevolve
