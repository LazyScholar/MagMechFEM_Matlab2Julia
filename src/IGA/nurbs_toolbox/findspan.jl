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
    findspan(n::I,p::I,u::F,U::Vector{F})::I where {I<:Integer,F<:AbstractFloat}

Find the span of a B-Spline knot vector at a parametric point

# Arguments:
- `n`: nuber of control points `-1`
- `p`: spline degree
- `n`: parametric point
- `U`: knot sequence

# Output:
- `s`: knot span of `u` in `U`

# Examples:
```julia-repl
julia> s = findspan(n,p,u,U)
```

# Reference:
- Algorithm A2.1 from 'The NURBS BOOK' pg68 ([1997Piegl](@cite))
"""
function findspan(n::I,p::I,u::F,U::Vector{F}
                 )::I where {I<:Integer,F<:AbstractFloat}
# TODO: the original C function passes the knot vector as reference

# special case
if u == U[n+2]; return n; end

# do binary search
low = p;
high = n + 1;
mid = (low + high) ÷ 2;
while (u < U[mid+1] || u >= U[mid+2])
  if u < U[mid+1]
    high = mid;
  else
    low = mid;
  end # if
  mid = (low + high) ÷ 2;
end # while
return mid;
end # findspan
