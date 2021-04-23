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
    demoellip()

Demonstration of a unit circle transformed to a inclined ellipse by first
scaling, then rotating and finally translating.

# Examples:
```julia
julia> demoellip()
```
"""
function demoellip()
xx = vectrans([2.0;1.0]) * vecroty(π/8) * vecrotx(π/4) * vecscale([1.0;2.0]);
crv = nrbtform(nrbcirc(),xx);
nrbplot(crv,50,
        title = "Construction of an ellipse by transforming a unit circle.",
        framestyle=:box,
        legend = false);
end # demoellip
