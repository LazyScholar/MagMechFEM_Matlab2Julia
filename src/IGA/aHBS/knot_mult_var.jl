"""
    knot_mult_var(p::I,knots::Vector{F}) where {I<:Integer,F<:AbstractFloat}

Helper function knot_mult for the bs2bs-algorithm. This function computes and
returns the unique knots and the multiplicity of all those knots between the
first and last knot of multiplicity p+1 it returns additionally the count of
those unique knots.

# Arguments:
- `p`: polynomial degree for the knot vector
- `knots`: knot vector

# Output:
- `multiplicity`: vector indicating the occurrence of the knots returned in
  vector unique_knots the first and last entry will be 1, ignoring the p+1
  multiplicity
- `unique_knots`: vector containing the unique knot values
- `knot_count`: integer indicating the count of the knot entries without
  multiplicity

# Examples:
```julia-repl
julia> multiplicity, unique_knots, knot_count = knot_mult_var( p, knots)
```

# Reference:
- Algorithm based on [2007Casciola](@cite)
"""
function knot_mult_var(p::I,knots::Vector{F}
                      ) where {I<:Integer,F<:AbstractFloat}
# TODO: remodel the ignoring of start and end multiplicity, as that might be
#       inconsistent for closed B-Splines

# allocation of result vectors (will be truncated at the end)
n = length(knots);
unique_knots = zeros(F,n);
multiplicity = zeros(typeof(1),n);
# initialize the search algorithm
temp_mult = 1;
knot_count = 0;
# test each entry of the knot vector
for i in p+1:n-1-p
  if knots[i] < knots[i+1]
    # if the entry i is not similar to i+1 save the multiplicity
    # and the value of entry i
    knot_count += 1;
    multiplicity[knot_count] = temp_mult;
    unique_knots[knot_count] = knots[i];
    # reset the multiplicity for next test
    temp_mult = 1;
	else
    # if the entries i and i+1 are same increase the current
    # multiplicity
    temp_mult += 1;
	end # if
end # for i
# return the result by truncating not used entries
multiplicity = [ multiplicity[1:knot_count]; 1            ];
unique_knots = [ unique_knots[1:knot_count]; knots[end-p] ];
return multiplicity, unique_knots, knot_count;
end # knot_mult_var
