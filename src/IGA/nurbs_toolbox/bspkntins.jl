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
    bspkntins(d::I,c::Matrix{F},k::Vector{F},u::Vector{F}
             ) where {I<:Integer,F<:AbstractFloat}

Insert knots into a univariate B-Spline.

# Arguments:
- `d`: Degree of the B-Spline.
- `c`: Control points, matrix of size `(dim,nc)`.
- `k`: Knot sequence, vector of size `nk`.
- `u`: Row vector of knots to be inserted, size `nu`.

# Output:
- `ic`: Control points of the new B-Spline, of size `(dim,nc+nu)`.
- `ik`: Knot vector of the new B-Spline, of size `(nk+nu)`.

# Examples:
```julia
julia> ic,ik = bspkntins(d,c,k,u)
```

# Reference:
- Algorithm A5.4 from 'The NURBS BOOK' pg164 ([1997Piegl](@cite))
"""
function bspkntins(d::I,c::Matrix{F},k::Vector{F},u::Vector{F}
                   ) where {I<:Integer,F<:AbstractFloat}
# TODO: the original C function passed c, k, ic, ik and u as reference
# TODO: this function has optimization potential

mc, nc = size(c);
nu = length(u);
nk = length(k);

ic = zeros(F,(mc,nc+nu));
ik = zeros(F,nk+nu);

n = nc - 1;
r = nu - 1;

m = n + d + 1;
a = findspan(n, d, u[1], k);
b = findspan(n, d, u[r+1], k);
b += 1;

for q in 0:mc-1
  for j in 0:a-d; ic[q+1,j+1] = c[q+1,j+1]; end # for j
  for j in b-1:n; ic[q+1,j+r+2] = c[q+1,j+1]; end # for j
end # for q

for j in 0:a; ik[j+1] = k[j+1]; end # for j
for j in b+d:m; ik[j+r+2] = k[j+1]; end # for j

i = b + d - 1;
s = b + d + r;

for j in r:-1:0
  while u[j+1] <= k[i+1] && i > a
    for q in 0:mc-1
      ic[q+1,s-d] = c[q+1,i-d];
    end # for q
    ik[s+1] = k[i+1];
    s -= 1;
    i -= 1;
  end # for q

  for q in 0:mc-1
    ic[q+1,s-d] = ic[q+1,s-d+1];
  end # for q

  for l in 1:d
    ind = s - d + l;
    alfa = ik[s+l+1] - u[j+1];
    if abs(alfa) == 0
      for q in 0:mc-1
        ic[q+1,ind] = ic[q+1,ind+1];
      end
    else
      alfa /= (ik[s+l+1] - k[i-d+l+1]);
      for q=0:mc-1
        ic[q+1,ind] = alfa*ic[q+1,ind] + (1-alfa)*ic[q+1,ind+1];
      end # for q
    end # if
  end # for l

  ik[s+1] = u[j+1];
  s -= 1;
end # for j
return ic, ik;
end # bspkntins
