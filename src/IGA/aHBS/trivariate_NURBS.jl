"""
    trivariate_NURBS(coords::Matrix{F},
                     p::Vector{I},
                     knots::Vector{Vector{F}},
                     points::Matrix{F},
                     weights::Vector{F},
                     n::Vector{I}
                    ) where {I<:Integer,F<:AbstractFloat}

Calculates the points of a trivariate NURBS geometry. The function is based on
the B-Spline algorithm of de Boor [1972Boor](@cite).

# Arguments:
- `coords`: matrix containing the parametric evaluation pairs so each i-th row
  contains the evaluation point [xi[i] eta[i] psi[i]]
- `p`: vector of the directional polynomial degrees
- `knots`: vector of directional knot tuples
- `points`: linearised point matrix of all unweighted control points each
  column belongs to one coordinate
- `weights`: weight vector for the points
- `n`: number of points for each direction

# Output:
- `C`: calculated point coordinates belonging to each coordinate row

# Examples:
```julia-repl
julia> C = trivariate_NURBS( coords, p, knots, points, weights, n)
```

# Reference:
- Algorithm based on 'On Calculating with B-Splines' from [1972Boor](@cite)
- Further references: [1997Piegl](@cite) and [2000Spink](@cite)
"""
function trivariate_NURBS(coords::Matrix{F},
                          p::Vector{I},
                          knots::Vector{Vector{F}},
                          points::Matrix{F},
                          weights::Vector{F},
                          n::Vector{I}
                         ) where {I<:Integer,F<:AbstractFloat}
# TODO: make this a multivariate function instead only trivariate
# TODO: make the function accept coords as virtual grid/ranges as that is less
#       memory needy (needs to do the meshgrid on its own)

# calculate the knot spans for each coords part
knot_span = Vector{Vector{I}}(undef,3);
for j in 3:-1:1
  knot_span[j] = calculate_knot_span(p[j],knots[j],coords[:,j]);
end # for j
# prepare some help variables
n12 = prod(n[1:2]); pp1 = p[1]+1; pp12 = prod(p[1:2] .+1);
# set up the base for the  triangular calculation algorithm
i = repeat(0:p[1],outer=prod(p[2:3] .+1));
j = repeat(repeat(0:p[2],inner=p[1]+1),outer=p[3]+1);
k = repeat(0:p[3],inner=prod(p[1:2] .+1));
# TODO: refactor this
idx = (knot_span[1] .-  i') .+
      (knot_span[2] .- (j' .+ 1)) .* n[1] .+
      (knot_span[3] .- (k' .+ 1)) .* n12;
C = permutedims(reshape([points[idx[:],:].*weights[idx[:]] weights[idx[:]]],
                        (size(coords,1),prod(p .+1),size(points,2)+1))
                ,[1,3,2]);
# set up further help variable
temp_mod = [1; pp1; pp12];
for i in 3:-1:1
  # collapse the calculation of the NURBS in i direction
  for k in 1:p[i]
    for j in 1:p[i]-k+1
      idx = knot_span[i] .+ (1-j);
      pos = (1:temp_mod[i])' .- temp_mod[i] .+ j * temp_mod[i];
      alpha = (coords[:,i] .- knots[i][idx]) ./
              (knots[i][idx .+ (p[i]-k+1)] .- knots[i][idx]);
      C[:,:,pos] .= C[:,:,pos .+ temp_mod[i]] .* (1 .- alpha) .+
                    C[:,:,pos] .* alpha;
    end # for j
  end # for k
end # for i
# return after normalizing
return C[:,1:end-1,1] ./ C[:,end,1];
end # trivariate_NURBS
