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
    bspeval(d::I,c::Matrix{F},k::Vector{F},u::Vector{F}
           ) where {I<:Integer,F<:AbstractFloat}

Evaluate a univariate B-Spline.

# Arguments:
- `d`: degree of the B-Spline
- `c`: control points, matrix of size `(dim,nc)`
- `k`: knot sequence, vector of size `nk`
- `u`: parametric evaluation points, vector of size `nu`

# Output:
- `p::Matrix{F}`: knot span of `u` in `U`

# Examples:
```julia
julia> p = bspeval(d,c,k,u)
```

# Reference:
- Algorithm A3.1 from 'The NURBS BOOK' pg82 ([1997Piegl](@cite))
"""
function bspeval(d::I,c::Matrix{F},k::Vector{F},u::Vector{F}
                ) where {I<:Integer,F<:AbstractFloat}
# TODO: the original C function passed c, k, u and p as reference
# TODO: this function has optimization potential

nu = length(u);
mc, nc = size(c);

# allocate space for evaluated points
p = zeros(F,(mc,nu));

# allocate space for the basis functions
N = zeros(F,d+1);

# for each parametric point
for col in 1:nu
  # find the span of u[col]
  s = findspan(nc-1,d,u[col],k);
  N = basisfun(s,u[col],d,k);

  tmp1 = s - d + 1;
  for row in 1:mc
    tmp2 = 0;
    for i in 0:d
      tmp2 += N[i+1] * c[row,tmp1+i];
    end # for i
    p[row,col] = tmp2;
  end # for row
end # for col
return p;
end # bspeval
