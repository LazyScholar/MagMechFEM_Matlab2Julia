using SparseArrays;

"""
    oslo1_global(p::I,knots_old::Vector{F},knots_new::Vector{F}
                ) where {I<:Integer,F<:AbstractFloat}

Compute the global subdivision matrix for the B-spline bases belonging to the
knot vectors knots_old and knots_new.

# Arguments:
- `p`: polynomial degree of both spline bases
- `knots_old`: old/coarse knot vector
- `knots_new`: knots to insert (values include the old knot vector)

# Output:
- `M`: sparse subdivision matrix

# Examples:
```julia-repl
julia> M = oslo1_global( p, knots_old, knots_new)
```

# Algorithm based on:
- Discrete B-splines and subdivision techniques in computer-aided geometric
  design and computer graphics, from [1980Cohen](@cite)
- A short proof of the Oslo algorithm, from [1984Prautzsch](@cite)
- Making the OSLO Algorithm More Efficient, from [1986Lyche](@cite)
- Multi-level Bézier extraction for hierarchical local refinement of
  Isogeometric Analysis, from [2018DAngella](@cite)
"""
function oslo1_global(p::I,knots_old::Vector{F},knots_new::Vector{F}
                     ) where {I<:Integer,F<:AbstractFloat}
# calculate the sizes of the subdivision matrix respectively the number of
# b-spline functions of coarse and fine base
M_I = length(knots_old)-p-1;
M_J = length(knots_new)-p-1;
# precalculate all i-starting points of the algorithm for each column
# loop over all fine functions respectively columns
# this part is parallelize able
M_i = zeros(typeof(1),(1,M_J));
i = 1;
for j in 1:M_J
  while i <= M_I && ~((knots_old[i] <= knots_new[j]) &
                      (knots_new[j] < knots_old[i+1]))
      i = i + 1;
  end # while
  M_i[j] = i;
end # for j
# preallocate memory
M = zeros(typeof(1.0),(M_J,p+1));
M[:,p+1] .= 1;
# run the oslo1-algorithm in its vectorized form on all columns
# this part is parallelize able
for k in 1:p
  x = knots_new[(1:M_J) .+ k];
  t1 = knots_old[M_i .+ (1-k:0)]';
  t2 = knots_old[M_i .+ (1:k)]';
  w = (x .- t1) ./ (t2 .- t1);
  M[:,p+1-k:p+1] = [ (1 .- w) .* M[:,p+2-k:p+1]   zeros(M_J) ] .+
                   [ zeros(M_J)          w .* M[:,p+2-k:p+1] ];
end # for k
# build sparse matrix
M_j = repeat((1:M_J)',p+1);
M_i = M_i .+ (-p:0);
M = M';
# TODO: maybe drop near zero zeroes?
return dropzeros!(sparse(M_i[:],M_j[:],M[:],M_I,M_J));
end # oslo1_global
