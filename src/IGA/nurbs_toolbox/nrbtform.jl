#    Copyright (c) 2021 J.A. Duffek
#    Copyright (c) 2000 D.M. Spink
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, see <http://www.gnu.org/licenses/>.

"""
    nrbtform(nurbs::NURBS{I,F},tmat::Matrix{F}
            )::NURBS{I,F} where {I<:Integer,F<:AbstractFloat}

Apply transformation matrix to the NURBS.

The NURBS is transform as defined a transformation matrix of size (4,4), such
as a rotation, translation or change in scale. The transformation matrix can
define a single transformation or multiple series of transformations. The
matrix can be simple constructed by the functions [`vecscale`](@ref),
[`vectrans`](@ref), [`vecrotx`](@ref), [`vecroty`](@ref) and [`vecrotz`](@ref).

# Arguments:
- `nurbs`: NURBS data structure (see nrbmak for details).
- `tmatrix`: Transformation matrix, a matrix of size (4,4) defining a single
  or multiple transformations.

# Output:
- `tnurbs`: The transformed NURBS data structure.

# Examples:
```julia-repl
julia> tnurbs = nrbtform(nurbs,tmatrix)
```

Rotate a square by 45 degrees about the z axis.

```julia-repl
julia> rsqr = nrbtform(nrbrect(), vecrotz(deg2rad(45)));
julia> nrbplot(rsqr,[10;10])
```

# Reference
- see also: [`vecscale`](@ref), [`vectrans`](@ref), [`vecrotx`](@ref),
  [`vecroty`](@ref) and [`vecrotz`](@ref)
"""
function nrbtform(nurbs::NURBS{I,F},tmat::Matrix{F}
                 )::NURBS{I,F} where {I<:Integer,F<:AbstractFloat}
if size(tmat) != (4,4)
  throw(ArgumentError("Transformation matrix must be of size 4x4 !"));
end # if
if typeof(nurbs)<:NURBS2D
  # NURBS is a surface
  dim, nu, nv = size(nurbs.coefs);
  return nrbmak(reshape(tmat*reshape(nurbs.coefs,(dim,nu*nv)),(dim,nu,nv)),
                nurbs.knots);
else
  # NURBS is a curve
  return nrbmak(tmat*nurbs.coefs,nurbs.knots);
end # if
end # nrbtform
