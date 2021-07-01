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
    demohelix()

Demonstration of a 3D helical curve.

# Examples:
```julia-repl
julia> demohelix()
```
"""
function demohelix()
coefs =[ 6.0  0.0  6.0  1;
        -5.5  0.5  5.5  1;
        -5.0  1.0 -5.0  1;
         4.5  1.5 -4.5  1;
         4.0  2.0  4.0  1;
        -3.5  2.5  3.5  1;
        -3.0  3.0 -3.0  1;
         2.5  3.5 -2.5  1;
         2.0  4.0  2.0  1;
        -1.5  4.5  1.5  1;
        -1.0  5.0 -1.0  1;
         0.5  5.5 -0.5  1;
         0.0  6.0  0.0  1];
coefs = permutedims(coefs,[2,1]);
knots = vec([0 0 0 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1 1 1]);

crv = nrbmak(coefs,knots);
nrbplot(crv,100,
        title = "3D helical curve.";
        legend = false);
end # demohelix
