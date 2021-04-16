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
    nrbtestsrf()::NURBS2D

Construct a simple test surface.

# Output:
- `srf`: NURBS data structure of a surface

# Examples:
```julia
julia> srf = nrbtestsrf()
```
"""
function nrbtestsrf()::NURBS2D
# allocate multi-dimensional array of control points
pnts = zeros(typeof(1.0),(3,5,5));

# define a grid of control points
# in this case a regular grid of u,v points
# pnts[1:3,u,v]

pnts[:,:,1] = [ 0.0  3.0  5.0  8.0 10.0;  # w*x
                0.0  0.0  0.0  0.0  0.0;  # w*y
                2.0  2.0  7.0  7.0  8.0]; # w*z

pnts[:,:,2] = [ 0.0  3.0  5.0  8.0 10.0;
                3.0  3.0  3.0  3.0  3.0;
                0.0  0.0  5.0  5.0  7.0];

pnts[:,:,3] = [ 0.0  3.0  5.0  8.0 10.0;
                5.0  5.0  5.0  5.0  5.0;
                0.0  0.0  5.0  5.0  7.0];

pnts[:,:,4] = [ 0.0  3.0  5.0  8.0 10.0;
                8.0  8.0  8.0  8.0  8.0;
                5.0  5.0  8.0  8.0 10.0];

pnts[:,:,5] = [ 0.0  3.0  5.0  8.0 10.0;
               10.0 10.0 10.0 10.0 10.0;
                5.0  5.0  8.0  8.0 10.0];

# knots
knots = Vector{Vector{typeof(1.0)}}(undef,2);
knots[1] = vec([0 0 0 1/3 2/3 1 1 1]); # knots along u
knots[2] = vec([0 0 0 1/3 2/3 1 1 1]); # knots along v

# make nurbs surface
return nrbmak(pnts,knots);
end # nrbtestsrf
