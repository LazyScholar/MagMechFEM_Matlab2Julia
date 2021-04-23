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
    demoruled()

Demonstration of ruled surface construction.

# Examples:
```julia
julia> demoruled()
```
"""
function demoruled()
crv1 = nrbtestcrv();
crv2 = nrbtform(nrbcirc(4.0,[4.5;0.0],1.0*pi,0.0),vectrans([0.0;4.0;-4.0]));
srf = nrbruled(crv1,crv2);
nrbplot(srf,[40;20],
        title = "Ruled surface construction from two NURBS curves.",
        legend = false);
end # demoruled
