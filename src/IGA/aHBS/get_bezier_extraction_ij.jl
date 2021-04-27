"""
    get_bezier_extraction_ij(p::I,knots::Vector{F}
                            ) where {I<:Integer,F<:AbstractFloat}

This function calculates the start indices of the bezier extraction patches.
It is a variation of some part of the bs2bs-algorithm. And could be replaced by
it.

# Arguments:
- `p`: spline degree of spline base
- `knots`: knot vector to subdivide

# Output:
- `bezier_ij`: bezier extraction start point indices

# Examples:
```julia-repl
julia> bezier_ij = get_bezier_extraction_ij( p, knots)
```

# Reference:
- Algorithm based on [2007Casciola](@cite)
"""
function get_bezier_extraction_ij(p::I,knots::Vector{F}
                      ) where {I<:Integer,F<:AbstractFloat}
# calculate help variables like multiplicity count of knot entries
mult_old, temp, coun_old = knot_mult_var( p, knots );
# calculate the start points
col = [1; zeros(typeof(1),coun_old-1)];
row = [1; zeros(typeof(1),coun_old-1)];
for kj in 2:coun_old
  row[kj] = row[kj-1]+mult_old[kj];
  col[kj] = col[kj-1]+p;
end # for kj
# return solution matrix
return cat(row, col,dims=2);
end # get_bezier_extraction_ij
