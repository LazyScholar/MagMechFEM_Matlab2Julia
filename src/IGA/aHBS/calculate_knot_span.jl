"""
    calculate_knot_span(p::I,knots::Vector{F},coords::Vector{F}
                       ) where {I<:Integer,F<:AbstractFloat}

Computes the knot span for a vector of evaluation points on a knot tuple.

# Arguments:
- `p`: polynomial degree for the knot vector
- `knots`: knot vector
- `coords`: evaluation parameter vector

# Output:
- `knot_span`: knot span of each parametric evaluation point of `coords`

# Examples:
```julia-repl
julia> knot_span = calculate_knot_span( p, knots, coord)
```

# Reference:
- see also: [`univariate_NURBS`](@ref), [`bivariate_NURBS`](@ref) and
  [`trivariate_NURBS`](@ref)
"""
function calculate_knot_span(p::I,knots::Vector{F},coords::Vector{F}
                            ) where {I<:Integer,F<:AbstractFloat}
# TODO: for very long (sorted) coordinate vectors it might be smarter to to use
#       a iterative method... which is useless for unsorted vectors otherwise
#       a binary search approach might be useful as the knots are sorted

# build logical matrix marking the knot span where coord is
knot_span = (knots[1:end-1]' .<= coords) .& (coords .< knots[2:end]');
# check if there is one coord to wich no span was found
temp = vec(.~any(knot_span, dims=2));
# if so enter the if case
if any(temp)
  # TODO: come back later and implement a fast and robust way to get the knot
  #       span for arbitrary vectors

  # set the knot span for those cases
  # (most likely the coord at knots(end))
  #knot_span[temp,:] .= (ξ[temp] .== Ξ[2:end]') .& (ξ[temp] .> Ξ[1:end-1]');

  # it is difficult to test for equality if the knots or coords have
  # rounding errors, therefore assume that it is a open knot span
  knot_span[temp,length(knots)-p-1] .= true;
end # if
return findfirst.(eachrow(knot_span));
end # calculate_knot_span
