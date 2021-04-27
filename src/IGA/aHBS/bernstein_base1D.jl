"""
    bernstein_base1D(p::I,ξ::Vector{F},nd::I=0
                    ) where {I<:Integer,F<:AbstractFloat}

Algorithm to compute the p+1 bernstein poylnomials and Derivatives.
The function is based based on [1997Piegl](@cite).

# Arguments:
- `p`: polynomial degree of bernstein polynomials
- `ξ`: evaluation positions (from -1 to 1)
- `nd`: return derivatives up to d^nb/dξ^nb (defaults to 0)

# Output:
- `B`: the p+1 bernstein polynomials evaluated at ξ, each column stores one
  polynomial
- `dB`: the first derivative of the bernstein polynomials evaluated at ξ, each
  row stores one polynomial (returned only if nb >= 1)
- `ddB`: the second derivative of the bernstein polynomials evaluated at ξ,
  each row stores one polynomial (returned only if nb>=2)
- `...`: and so on ... (up to `p` derivatives can be requested (nd<=p))

# Examples:
```julia-repl
julia> B, dB, ddB, dddB = bernstein_base1D( 3, ξ, 3)
julia> B, dB = bernstein_base1D( 3, ξ, 1)
julia> B = bernstein_base1D( 5, ξ)
```

# Reference:
- Algorithm based on 'The NURBS BOOK' pg20 ([1997Piegl](@cite))
"""
function bernstein_base1D(p::I,ξ::Vector{F},nd::I=0
                         ) where {I<:Integer,F<:AbstractFloat}

if nd > p; throw(ArgumentError("Only up to p derivatives possible!")); end # if

# initialize the bernstein polynomial algorithm
B = zeros(F,(length(ξ),p+1));
B[:,1] .= 1;
if nd != 0; LdB = Vector{Matrix{F}}(undef,nd); end # if
# calculate the xi complementary parts and allocate space for temporary arrays
ξ1 = (ξ .+ 1) ./2;
ξ2 = (1 .- ξ) ./2;
temp_0 =  zeros(F,length(ξ));
temp_1 =  zeros(F,length(ξ));
temp_d0 = zeros(F,length(ξ));
temp_d1 = zeros(F,length(ξ));
# loop over the bernstein polynomial recursive steps
for j in 2:p+1
  # calculate the derivative 'p-j+2' if it had been requested
  temp_d = p-j+2;
  if nd+1 > temp_d
    # initialize the derivative calculation
    LdB[temp_d] = copy(B);
    temp_m = 1.0;
    # loop over the recursive derivative calculation steps
    for i in j:p+1
      temp_m *= (i-1)/2;
      temp_d0 .= 0;
      for k in 1:i
        temp_d1 .= LdB[temp_d][:,k];
        LdB[temp_d][:,k] .= temp_d0 .- temp_d1;
        temp_d0 .= temp_d1;
      end # for k
    end # for i
    LdB[temp_d] .*= temp_m;
  end # if
  # bernstein polynomial recursive step
  temp_0 .= 0;
  for k in 1:j-1
    temp_1 .= B[:,k];
    B[:,k] .= temp_0 .+ ξ2 .* temp_1;
    temp_0 .= ξ1 .* temp_1;
  end # for k
  B[:,j] .= temp_0;
end # for j
if nd > 0
  return B, LdB...;
else
  return B;
end # if
end # bernstein_base1D
