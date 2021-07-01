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
    bspdegelev(d::I,c::Matrix{F},k::Vector{F},t::I
              ) where {I<:Integer,F<:AbstractFloat}

Degree elevate a univariate B-Spline.

# Arguments:
- `d`: Degree of the B-Spline.
- `c`: Control points, matrix of size `(dim,nc)`.
- `k`: Knot sequence, vector of size `nk`.
- `t`: Raise the B-Spline degree t times.

# Output:
- `ic`: Control points of the new B-Spline.
- `ik`: Knot vector of the new B-Spline.

# Examples:
```julia-repl
julia> ic,ik = bspdegelev(d,c,k,t)
```

# Reference:
- Algorithm A5.9 from 'The NURBS BOOK' pg206 ([1997Piegl](@cite))
"""
function bspdegelev(d::I,c::Matrix{F},k::Vector{F},t::I
                   ) where {I<:Integer,F<:AbstractFloat}
# TODO: the original C function passed c, k, ic, ik and the point number
#       as reference
# TODO: this function has optimization potential

# added this part as contrary to matlab array sizes are not adaptive
# count unique knots to calculate final array sizes
n0 = k[1];
count = 1;
iknc = 1;
for i in 2:length(k)
  if n0 == k[i]
    iknc += 1;
    continue;
  end # if
  iknc += t+1;
  n0 = k[i];
end # for i
if n0 == k[end];
  iknc += t;
end # if

mc,nc = size(c);

# allocate space for resulting arrays
ic = zeros(F,(mc,iknc-(d+t+1)));
ik = zeros(F,iknc);

n = nc - 1;

bezalfs =  zeros(F,(d+1,d+t+1));
bpts = zeros(F,(mc,d+1));
ebpts = zeros(F,(mc,d+t+1));
Nextbpts = zeros(F,(mc,d+1));
alfs = zeros(F,d);

m = n + d + 1;
ph = d + t;
ph2 = ph ÷ 2;

# compute bezier degree elevation coefficeients
bezalfs[1,1] = 1;
bezalfs[d+1,ph+1] = 1;

for i in 1:ph2
  inv = 1 / bincoeff(ph,i);
  mpi = min(d,i);

  for j in max(0,i-t):mpi
    bezalfs[j+1,i+1] = inv * bincoeff(d,j) * bincoeff(t,i-j);
  end # for j
end # for i

for i in ph2+1:ph-1
  mpi = min(d,i);
  for j in max(0,i-t):mpi
    bezalfs[j+1,i+1] = bezalfs[d-j+1,ph-i+1];
  end # for j
end # for i

mh = ph;
kind = ph + 1;
r = -1;
a = d;
b = d + 1;
cind = 1;
ua = k[1];

for ii in 0:mc-1
  ic[ii+1,1] = c[ii+1,1];
end # for ii

for i in 0:ph
  ik[i+1] = ua;
end # for i

# initialise first bezier seg
for i in 0:d
  for ii in 0:mc-1
    bpts[ii+1,i+1] = c[ii+1,i+1];
  end # for ii
end # for i

# big loop thru knot vector
while b < m
  i = b;
  while b < m && k[b+1] == k[b+2]
    b += 1;
  end # while
  mul = b - i + 1;
  mh +=  mul + t;
  ub = k[b+1];
  oldr = r;
  r = d - mul;

  # insert knot u(b) r times
  if oldr > 0
    lbz = (oldr+2) ÷ 2;
  else
    lbz = 1;
  end # if

  if r > 0
    rbz = ph - (r+1) ÷ 2;
  else
    rbz = ph;
  end # if

  # insert knot to get bezier segment
  if r > 0
    numer = ub - ua;
    for q in d:-1:mul+1
      alfs[q-mul] = numer / (k[a+q+1] - ua);
    end # for q

    for j in 1:r
      save = r - j;
      s = mul + j;

      for q in d:-1:s
        for ii in 0:mc-1
          bpts[ii+1,q+1] = alfs[q-s+1] * bpts[ii+1,q+1] +
                           (1 - alfs[q-s+1]) * bpts[ii+1,q];
        end # for ii
      end # for q

      for ii in 0:mc-1
        Nextbpts[ii+1,save+1] = bpts[ii+1,d+1];
      end # for ii
    end # for j
  end # if
  # end of insert knot

  # degree elevate bezier
  for i in lbz:ph
    for ii in 0:mc-1
      ebpts[ii+1,i+1] = 0;
    end # for ii
    mpi = min(d, i);
    for j in max(0,i-t):mpi
      for ii in 0:mc-1
        ebpts[ii+1,i+1] = ebpts[ii+1,i+1] + bezalfs[j+1,i+1]*bpts[ii+1,j+1];
      end # for ii
    end # for j
  end # for i
  # end of degree elevating bezier

  # must remove knot u=k[a] oldr times
  if oldr > 1
    first = kind - 2;
    last = kind;
    den = ub - ua;
    bet = (ub - ik[kind]) ÷ den;

    # knot removal loop
    for tr in 1:oldr-1
      i = first;
      j = last;
      kj = j - kind + 1;
      # loop and compute the new control points
      # for one removal step
      while j-i > tr
        if i < cind
          alf = (ub - ik[i+1]) / (ua - ik[i+1])
          for ii in 0:mc-1
            ic[ii+1,i+1] = alf * ic[ii+1,i+1] + (1 - alf) * ic[ii+1,i];
          end # for ii
        end # if
        if j >= lbz
          if j-tr <= kind-ph+oldr
            gam = (ub - ik[j-tr+1]) / den;
            for ii in 0:mc-1
              ebpts[ii+1,kj+1] = gam * ebpts[ii+1,kj+1] +
                                 (1 - gam) * ebpts[ii+1,kj+2];
            end # for ii
          else
            for ii in 0:mc-1
              ebpts[ii+1,kj+1] = bet * ebpts[ii+1,kj+1] +
                                 (1 - bet) * ebpts[ii+1,kj+2];
            end # for ii
          end # if
        end # if
        i += 1;
        j -= 1;
        kj -= 1;
      end # while

      first -= 1;
      last += 1;
    end # for tr
  end # if
  # end of removing knot n=k[a]

  # load the knot ua
  if a != d
    for i in 0:ph-oldr-1
      ik[kind+1] = ua;
      kind +=  1;
    end # for i
  end # if

  # load ctrl pts into ic
  for j in lbz:rbz
    for ii in 0:mc-1
      ic[ii+1,cind+1] = ebpts[ii+1,j+1];
    end # for ii
    cind += 1;
  end # for j

  if b < m
  # setup for next pass thru loop
    for j in 0:r-1
      for ii in 0:mc-1
        bpts[ii+1,j+1] = Nextbpts[ii+1,j+1];
      end # for ii
    end # for j
    for j in r:d
      for ii in 0:mc-1
        bpts[ii+1,j+1] = c[ii+1,b-d+j+1];
      end # for ii
    end # for j
    a = b;
    b += 1;
    ua = ub;

  else
  # end knot
    for i in 0:ph
      ik[kind+i+1] = ub;
    end # for i
  end # if
end # while b < m
# End big while loop
return ic,ik;
end # bspdegelev

"""
    bincoeff(n::I,k::I) where{I<:Integer}

Computes the binomial coefficient.

    ( n )      n!
    (   ) = --------
    ( k )   k!(n-k)!

# Arguments:
- `n`: `n` of `n` choose `k`
- `k`: `k` of `n` choose `k`

# Output:
- `b`: binomial coefficient of `n` choose `k`

# Example:
```julia-repl
julia> b = bincoeff(n,k)
```

# Reference:
- Algorithm 6.1.6 from 'Numerical Recipes in C', 2nd Edition pg215
  ([1992Press](@cite))
"""
function bincoeff(n::I,k::I) where{I<:Integer}
# TODO: revisit this later to ommit/replace this with something better?
return floor(0.5 + exp( factln(n) - factln(k) - factln(n-k)));
end # bincoeff

"""
    factln(n::I) where{I<:Integer}

Computes `ln(n!)`.

# Example:
```julia-repl
julia> a = factln(n)
```
"""
function factln(n::I) where{I<:Integer}
# TODO: revisit this later to ommit/replace this with something better?
if n <= 1; return 0; end # if
return log(factorial(n));
end # factln
