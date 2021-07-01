using LinearAlgebra;

"""
    degree_elev_1D(p::I,
                   t::I,
                   knots::Vector{F},
                  ) where {I<:Integer,F<:AbstractFloat}

The function is based on on the algorithm A5.9 in [1997Piegl](@cite). The
function computes the the degree elevation matrix to elevate one open B-Spline
t times. The function computes also the new knot vector. The function is not
optimized for speed nor memory consumption.

# Arguments:
- `p`: polynomial degree
- `t`: elevate the polynomial degree t times
- `knots`: unchanged knot tuple

# Output:
- `M_elev`: degree elevation matrix
- `knots_elev`: new knot vector

# Examples:
```julia-repl
julia> M_elev, knots_elev = degree_elev_1D(p, t, knots)
```

# Reference:
- Algorithm based on 'The NURBS Book' from [1997Piegl](@cite)
- Further references: [2000Spink](@cite)
"""
function degree_elev_1D(p::I,
                        t::I,
                        knots::Vector{F},
                       ) where {I<:Integer,F<:AbstractFloat}
# TODO: optimize for speed and memory
# TODO: this function works only for open B-Splines
# TODO: create the transformation matrix as sparse matrix

# new polynomial degree
p_elev = p+t;
# number of control points derived from knot vector
n_points = length(knots)-p-1;
# allocate the knot insertion alphas
knot_alphas = zeros(F,p);
# allocate new knot vector
knots_elev = zeros(F,n_points+(n_points-p-1)*t+p+1);
# allocate the bézier degree elevation matrix
bezier_alphas = zeros(F,(p+1,p+t+1));
# allocate the bézier computation matrix
M_bez = Matrix{F}(LinearAlgebra.I, n_points, p+1);
# allocate the temporary bézier point computation matrix
temp_bpts_matr = zeros(F,(n_points,p-1));
# allocate degree elevation matrix
M_elev = zeros(F,(n_points,n_points+(n_points-p)*t));
# calculate the bézier degree elevation matrix
temp_mid = p_elev ÷ 2;
bezier_alphas[1,1] = 1; bezier_alphas[p+1,p_elev+1] = 1;
for i in 1:temp_mid
  min_pi = min(p,i); max_it = max(0,i-t);
  temp_range = max_it:min_pi;
  bezier_alphas[temp_range.+1,i+1] .= binomial.(p,temp_range) .*
                                      binomial.(t,i.-temp_range) ./
                                      binomial(p_elev,i);
end # for i
for i in temp_mid+1:p_elev-1
  min_pi = min(p,i); max_it = max(0,i-t);
  temp_range = max_it:min_pi;
  bezier_alphas[temp_range.+1,i+1] .= bezier_alphas[1+p.-temp_range,p_elev-i+1];
end # for i

# initialize the knot vector iteration counter
b = p+1;
# initialize the new knot vector iteration counter
knot_ind = p_elev+1;
# initialize the new point iteration counter
point_ind = 1;
# calculate the knot vector lenght -1
m = n_points+p;
# initialize the new knot vector length -1 counter
m_elev = p_elev;
# load the corresponding knot of b
ua = knots[b];
# assign the first value to the degree elevation matrix
M_elev[1,1] = 1;
# assign the first knots to the changed knot vector
knots_elev[1:p_elev+1] .= ua;
# initialize further counters
a = p; r = -1;
# while loop through the knot vector
while b<m
  # get the multiplicity of the current knot value
  save_b = b;
  while b<m && knots[b+1]==knots[b+2]; b = b+1; end # while
  mul = b-save_b+1; m_elev = m_elev+mul+t;
  # get the knot value of the next knot of different value
  ub = knots[b+1];
  # get the number of repetitions to insert one knot
  save_r = r; r = p-mul;
  if save_r>0; lbz = (save_r+2) ÷ 2; else; lbz = 1; end # if
  if r>0; rbz = p_elev-(r+1) ÷ 2; else; rbz = p_elev; end # if
  # process the knot insertion if repetitions > 0
  if r>0
    knot_diff = ub-ua;
    knot_alphas[p-mul:-1:1] .= knot_diff ./ (knots[a.+(p:-1:mul+1).+1]-ua);
    for j in 1:r
      save = r-j; s = mul+j;
      M_bez[:,(p:-1:s).+1] .= knot_alphas[(p-s+1):-1:1]' .*
                              M_bez[:,(p:-1:s).+1] .+
                              (1-knot_alphas[(p-s+1):-1:1]') .*
                              M_bez[:,p:-1:s];
      temp_bpts_matr[:,save+1] .= M_bez[:,p+1];
    end # for j
  end # if r>0
  # process the knot removal if saved repetitions > 1
  M_rem = Matrix{F}(LinearAlgebra.I, p_elev+1, p_elev+1);
  if save_r > 1
    first = knot_ind-2; last = knot_ind;
    knot_diff = ub - ua;
    for tr in 1:save_r-1
      i = first; j = last; kj = j-knot_ind+1;
      temp_M_knots_rem = Matrix{F}(LinearAlgebra.I, p_elev+1, p_elev+1);
      while j-i > tr
        if i<point_ind
          alf = (ub-knots_elev[i+1])/(ua-knots_elev[i+1]);
          M_elev[:,i+1] .= alf .* M_elev[:,i+1]+(1-alf) .* M_elev[:,i];
        end # if
        if j>=lbz
          if j-tr<=knot_ind-p_elev+save_r
            gam = (ub-knots_elev[j-tr+1])/knot_diff;
            temp_M_knots_rem[kj+1,kj+1] = gam;
            temp_M_knots_rem[kj+2,kj+1] = 1-gam;
          else
            bet = floor((ub-knots_elev(knot_ind))/knot_diff);
            temp_M_knots_rem[kj+1,kj+1] = bet;
            temp_M_knots_rem[kj+2,kj+1] = 1-bet;
          end # if
        end # if
        M_rem = M_rem * temp_M_knots_rem;
        i = i+1; j = j-1; kj = kj-1;
      end # while j-i>tr
      first = first-1; last = last+1;
    end # for tr
  end # if save_r>1
  # assign the corresponding knots to the new knot vector
  if a != p
    knots_elev[knot_ind.+(1:p_elev-save_r)] .= ua;
    knot_ind = knot_ind+p_elev-save_r;
  end # if
  # assign the corresponding points to the new point matrix
  temp_M_elev = M_bez*bezier_alphas*M_rem;
  M_elev[:,1+point_ind.+(0:(rbz-lbz))] .= temp_M_elev[:,(lbz:rbz).+1];
  point_ind = point_ind+1+(rbz-lbz);
  # prepare the next loop step
  if b < m
    M_bez[:,1:r] .= temp_bpts_matr[:,1:r];
    M_bez[:,(r:p).+1] .= 0;
    M_bez[(1+b-p.+(r:p)).+(r:p).*n_points] .= 1;
    a = b; b = b+1; ua = ub;
  else
    knots_elev[1+knot_ind.+(0:p_elev)] .= ub;
  end # if
end # while b<m
#delete the zero M_elev values
M_elev = M_elev[:,1:point_ind];

return M_elev, knots_elev;
end # degree_elev_1D
