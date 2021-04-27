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
    nrbruled(crv1::NURBS1D{I,F},crv2::NURBS1D{I,F}
            )::NURBS2D{I,F} where {I<:Integer,F<:AbstractFloat}

Constructs a ruled surface between two NURBS curves. The ruled surface is ruled
along the V direction.

# Arguments:
- `crv1`: First NURBS curve, see [`nrbmak`](@ref).
- `crv2`: Second NURBS curve, see [`nrbmak`](@ref).

# Output:
- `srf`: Ruled NURBS surface.

# Examples:
```julia-repl
julia> srf = nrbruled(crv1,crv2)
```

Construct a ruled surface between a semicircle and a straight line.
```julia-repl
julia> cir = nrbcirc(1.0,[0.0;0.0;0],0.0,1.0*pi);
julia> line = nrbline(vec([-1 0.5 1]),vec([1 0.5 1]));
julia> srf = nrbruled(cir,line);
julia> nrbplot(srf,[20;20]);
```

"""
function nrbruled(crv1::NURBS1D{I,F},crv2::NURBS1D{I,F}
                 )::NURBS2D{I,F} where {I<:Integer,F<:AbstractFloat}

# ensure both curves have a common degree
d = max(crv1.order,crv2.order);
crv1 = nrbdegelev(crv1, d - crv1.order);
crv2 = nrbdegelev(crv2, d - crv2.order);

# merge the knot vectors, to obtain a common knot vector
k1 = crv1.knots;
k2 = crv2.knots;
ku = unique([k1;k2]);
n = length(ku);
# TODO this is bad, increasing the size without allocating
ka = Vector{F}();
kb = Vector{F}();
for i in 1:n
  i1 = sum(x-> x == ku[i],k1);
  i2 = sum(x-> x == ku[i],k2);
  m = max(i1, i2);
  if m-i1>0; append!(ka, fill(ku[i],m-i1)); end #if
  if m-i2>0; append!(kb, fill(ku[i],m-i2)); end #if
end # for i
if !(isempty(ka)); crv1 = nrbkntins(crv1, ka); end # if
if !(isempty(kb)); crv2 = nrbkntins(crv2, kb); end # if

coefs = cat(crv1.coefs,crv2.coefs,dims=3);

return nrbmak(coefs, [crv1.knots,vec([0.0 0.0 1.0 1.0])]);
end # nrbruled
