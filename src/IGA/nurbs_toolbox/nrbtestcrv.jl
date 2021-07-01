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

"""
    nrbtestcrv()::NURBS1D

Construct a simple test curve.

# Output:
- `crv` NURBS data structure of a curve

# Examples:
```julia-repl
julia> crv = nrbtestcrv()
```
"""
function nrbtestcrv()::NURBS1D
pnts = [0.5 1.5 4.5 3.0 7.5 6.0 8.5;
        3.0 5.5 5.5 1.5 1.5 4.0 4.5;
        0.0 0.0 0.0 0.0 0.0 0.0 0.0];
return nrbmak(pnts,vec([0 0 0 1/4 1/2 3/4 3/4 1 1 1]));
end # nrbtestcrv
