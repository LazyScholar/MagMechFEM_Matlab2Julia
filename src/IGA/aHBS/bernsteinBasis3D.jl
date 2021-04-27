using LinearAlgebra;

"""
    bernsteinBasis3D(p::I, q::I, r::I,
                     ξ::Vector{F}, η::Vector{F}, ψ::Vector{F},
                     nd::I=0
                    ) where {I<:Integer,F<:AbstractFloat}

This function calculates the trivariate bernstein base functions on the area
ξ,η,ψ in [-1,+1]. It uses the operator `kron` to save calculation time.
Therefore the univariate base components of that base will be computed first.
This method of computation requires that the ξ,η and ψ values are univariate
(have no duplicates) as the mesh will be formed automatically by
`kron(*,kron(*,*))`.

# Arguments:
- `p`: polynomial degree of bernstein polynomials in ξ
- `q`: polynomial degree of bernstein polynomials in η
- `r`: polynomial degree of bernstein polynomials in ψ
- `ξ`: evaluation positions (from -1 to 1) of first direction
- `η`: evaluation positions (from -1 to 1) of second direction
- `ψ`: evaluation positions (from -1 to 1) of third direction
- `nd`: return derivatives up to d^nb/dX^nb (defaults to 0) (only implemented
  up to `nd=2`)

# Output:
- `B`: the p+1 bernstein polynomials evaluated at the mesh of ξ,η and ψ, each
  column stores one polynomial in a linearised way
- `dB`: the first derivatives of the bernstein polynomials, each row stores
  one derivative and each column one polynomial (the polynomials extend into
  the third array dimension in a linearised way) (returned only if nb >= 1)
- `ddB`: the second derivatives of the bernstein polynomials evaluated at ξ,
  each row stores one derivative and each column one polynomial (the
  polynomials extend into the third array dimension in a linearised way)
  (returned only if nb >= 2)

# Examples:
```julia-repl
julia> B, dB, ddB = bernsteinBasis3D( 3, 2 , 4, ξ, η, ψ, 2)
julia> B, dB = bernsteinBasis3D( 3, 2, 4, ξ, η, ψ, 1)
julia> B = bernsteinBasis3D( 3, 2, 1, ξ, η, ψ)
```
"""
function bernsteinBasis3D(p::I, q::I, r::I,
                          ξ::Vector{F}, η::Vector{F}, ψ::Vector{F},
                          nd::I=0
                         ) where {I<:Integer,F<:AbstractFloat}
# TODO: allow arbitrary numbers of derivatives
# TODO: change the storage of the derivative polynomials as it might be faster
#       for cache miss reasons (for a rewrite)

# calculate the bernstein polynomials
if nd == 0
  # no derivatives requested
  B1 = bernstein_base1D(p,ξ);
  B2 = bernstein_base1D(q,η);
  B3 = bernstein_base1D(r,ψ);
elseif nd == 1
  # up to first order derivative requested
  B1, dB1 = bernstein_base1D(p,ξ,1);
  B2, dB2 = bernstein_base1D(q,η,1);
  B3, dB3 = bernstein_base1D(r,ψ,1);
elseif nd == 2
  # up to second order derivative requested
  B1, dB1, ddB1 = bernstein_base1D(p,ξ,2);
  B2, dB2, ddB2 = bernstein_base1D(q,η,2);
  B3, dB3, ddB3 = bernstein_base1D(r,ψ,2);
else
  throw(ArgumentError("Only up to 2 derivatives implemented!"));
end # if
# calculate the trivariate base functions
B = kron(B3,kron(B2,B1));
# exit function if no derivatives had been requested
if nd == 0; return B; end # if
# calculate the first order derivatives
# dBdxi=[B,1 B,2 B,3]'
dB = zeros(F,size(B,1),size(B,2),3);
dB[:,:,1] = kron(B3,kron(B2,dB1));
dB[:,:,2] = kron(B3,kron(dB2,B1));
dB[:,:,3] = kron(dB3,kron(B2,B1));
dB = permutedims(dB,[3,2,1]); # this might be bad
# exit function if only up to first order derivative requested had been
# requested
if nd == 1; return B, dB; end # if
# calculate the second order derivatives
# ddBddxi=[B,11 B,22 B,33 B,12 B,13 B,23]'
ddB = zeros(F,size(B,1),size(B,2),6);
ddB[:,:,1] = kron(B3,kron(B2,ddB1));
ddB[:,:,2] = kron(B3,kron(ddB2,B1));
ddB[:,:,3] = kron(ddB3,kron(B2,B1));
ddB[:,:,4] = kron(B3,kron(dB2,dB1));
ddB[:,:,5] = kron(dB3,kron(B2,dB1));
ddB[:,:,6] = kron(dB3,kron(dB2,B1));
ddB = permutedims(ddB,[3,2,1]); # this might be bad
return B, dB, ddB;
end # bernsteinBasis3D
