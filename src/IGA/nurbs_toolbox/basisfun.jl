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
    basisfun(i::I,u::F,p::I,U::Vector{F}
            )::Vector{F} where {I<:Integer,F<:AbstractFloat}

Calculates the B-Spline basis function at `u`.

# Arguments:
- `i`: knot span from [`findspan`](@ref)
- `u`: parametric point
- `p`: spline degree
- `U`: knot sequence

# Output:
- `N`: basis function vector of lenght `p+1`

# Examples:
```julia
julia> N = basisfun(i,u,p,U)
```

# Reference:
- Algorithm A2.2 from 'The NURBS BOOK' pg70 ([1997Piegl](@cite))
"""
function basisfun(i::I,u::F,p::I,U::Vector{F}
                 )::Vector{F} where {I<:Integer,F<:AbstractFloat}
# TODO: the original C function got U and N passed as reference
# TODO: this function has optimization potential

i = i + 1;

# allocate result and work space
N     = zeros(F,p+1);
left  = zeros(F,p+1);
right = zeros(F,p+1);

N[1] = 1;
for j in 1:p
  left[j+1]  = u - U[i+1-j];
  right[j+1] = U[i+j] - u;
  saved = 0;

  for r in 0:j-1
    temp = N[r+1] / (right[r+2] + left[j-r+1]);
    N[r+1] = saved + right[r+2] * temp;
    saved = left[j-r+1] * temp;
  end # for r

  N[j+1] = saved;
end # for j
return N;
end # basisfun
