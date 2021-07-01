"""
    knots_subd_bez(p::I,knots_old::Vector{F}
                  ) where {I<:Integer,F<:AbstractFloat}

Helper function to subdivide one knot vector. It will return the subdivided
knot vector, the corresponding bezier knots and the associated bezier
start point matrix.

# Arguments:
- `p`: spline degree of spline base
- `knots_old`: knot vector to subdivide

# Output:
- `knots_subdiv`: subdivided knot vector
- `knots_bezier`: bezier knot vector of the subdivided knot vector
- `bezier_ij`: bezier extraction start point matrix associated with the created
  knot vector

# Examples:
```julia-repl
julia> knots_subdiv, knots_bezier, bezier_ij = knots_subd_bez( p, knots_old)
```

# Reference:
- Algorithm based on [2007Casciola](@cite)
"""
function knots_subd_bez(p::I,knots_old::Vector{F}
                       ) where {I<:Integer,F<:AbstractFloat}
# TODO: make this compatible with other types of knot bases e.g. closed ones

# prealocate solution vectors
knots_unique = zeros(F,length(knots_old)*2);
multiplicity = zeros(typeof(1),length(knots_old)*2);
# initialize counters
count_subdiv = 0;
temp_mult = 1;
# loop over all remaining elements
for i in 2:length(knots_old)
    # if the following knots are not equal
    if knots_old[i] > knots_old[i-1]
        # increase counter
        count_subdiv += 1;
        # copy entry
        knots_unique[count_subdiv] = knots_old[i-1];
        # insert multiplicity
        multiplicity[count_subdiv] = temp_mult;
        # increase counter
        count_subdiv += 1;
        # insert middle value
        knots_unique[count_subdiv] = (knots_old[i-1] + knots_old[i]) / 2;
        # insert multiplicity
        multiplicity[count_subdiv] = 1;
        # reset multiplicity counter
        temp_mult = 1;
    else
        # increase multiplicity counter
        temp_mult += 1;
    end # if
end # for i
# test the last knots for equality
if knots_old[end-1] == knots_old[end]
    # increase counter
    count_subdiv += 1;
    # copy entry
    knots_unique[count_subdiv] = knots_old[end];
    # save multiplicity
    multiplicity[count_subdiv] = temp_mult;
end # if
# truncate vectors
knots_unique = knots_unique[1:count_subdiv];
multiplicity = multiplicity[1:count_subdiv];
# create bezier-ij matrix
bezier_ij = [1 1; zeros(typeof(1),count_subdiv-2,2)];
for kj in 2:count_subdiv-1
  bezier_ij[kj,1] = bezier_ij[kj-1,1] + multiplicity[kj];
  bezier_ij[kj,2] = bezier_ij[kj-1,2] + p;
end # for kj
# prepare subdivided knot vector
knots_subdiv = repeat(knots_unique,inner=multiplicity);
# manipulate vector
multiplicity[ multiplicity < p ] .= p;
knots_bezier = repeat(knots_unique,inner=multiplicity);
return knots_subdiv, knots_bezier, bezier_ij;
end # knots_subd_bez
