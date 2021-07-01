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
    bspderiv(d::I,c::Matrix{F},k::Vector{F}
            ) where {I<:Integer,F<:AbstractFloat}

Evaluate the control points and knot sequence of the derivative of a univariate
B-Spline.

# Arguments:
- `d`: Degree of the B-Spline.
- `c`: Control points, matrix of size `(dim,nc)`.
- `k`: Knot sequence, vector of size `nk`.

# Output:
- `dc`: Control points of the derivative.
- `dk`: Knot sequence of the derivative.

# Examples:
```julia-repl
julia> dc,dk = bspderiv(d,c,k)
```

# Reference:
- derived from Algorithm A3.3 from 'The NURBS BOOK' pg98 ([1997Piegl](@cite))
"""
function bspderiv(d::I,c::Matrix{F},k::Vector{F}
                   ) where {I<:Integer,F<:AbstractFloat}
# TODO: the original C function passed c, k, dc, and dk as reference
# TODO: this function has optimization potential

mc,nc = size(c);
nk = length(k);

# control points of the derivative
dc = zeros(F,(mc,nc-1));
for i in 0:nc-2
  tmp = d / (k[i+d+2] - k[i+2]);
  for j in 0:mc-1
    # TODO yeah 1-1 is zero have a look if that is indented to have weights set
    #      to zero
    dc[j+1,i+1] = tmp * (c[j+1,i+2] - c[j+1,i+1]);
  end # for j
end # for i

# knots of the derivative
dk = zeros(F,nk-2);
for i in 1:nk-2
  dk[i] = k[i+1];
end # for i

return dc,dk;
end # bspderiv
