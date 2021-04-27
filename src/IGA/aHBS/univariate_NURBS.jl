"""
    univariate_NURBS(coords::Vector{F},
                     p::I,
                     knots::Vector{F},
                     points::Matrix{F},
                     weights::Vector{F}
                    ) where {I<:Integer,F<:AbstractFloat}

Calculates the points of a univariate NURBS geometry. The function is based on
the B-Spline algorithm of de Boor [1972Boor](@cite).

# Arguments:
- `coords`: vector containing the parametric evaluation points
- `p`: polynomial degree
- `knots`: knot tuple
- `points`: point matrix of all unweighted control points each column belongs
  to one coordinate
- `weights`: weight vector for the points
- `n`: number of points

# Output:
- `C`: calculated point coordinates belonging to each coordinate

# Examples:
```julia-repl
julia> C = univariate_NURBS( coords, p, knots, points, weights)
```

# Reference:
- Algorithm based on 'On Calculating with B-Splines' from [1972Boor](@cite)
- Further references: [1997Piegl](@cite) and [2000Spink](@cite)
"""
function univariate_NURBS(coords::Vector{F},
                          p::I,
                          knots::Vector{F},
                          points::Matrix{F},
                          weights::Vector{F}
                         ) where {I<:Integer,F<:AbstractFloat}
# TODO: make this a multivariate function instead only univariate
# TODO: make the function accept coords as virtual grid/ranges as that is less
#       memory needy

# calculate the knot span
knot_span = calculate_knot_span(p,knots,coords);
# set up the base for the  triangular calculation algorithm
idx = knot_span .- (0:p)';
C = permutedims(reshape([points[idx[:],:].*weights[idx[:]] weights[idx[:]]],
                        (length(coords),p+1,size(points,2)+1))
                ,[1,3,2]);
# collapse the calculation of the NURBS in i direction
for k in 1:p
  for j in 1:p-k+1
    idx = knot_span .+ (1-j);
    alpha = (coords .- knots[idx]) ./ (knots[idx .+ (p-k+1)] .- knots[idx]);
    C[:,:,j] .= C[:,:,j+1] .* (1 .- alpha) .+ C[:,:,j] .* alpha;
  end # for j
end # for k
# return after normalizing
return C[:,1:end-1,1] ./ C[:,end,1];
end # univariate_NURBS
