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
    nrbcoons(u1::NURBS1D{I,F},u2::NURBS1D{I,F},
             v1::NURBS1D{I,F},v2::NURBS1D{I,F}
            )::NURBS2D{I,F} where {I<:Integer,F<:AbstractFloat}

Construction of a Coons patch.

Construction of a bilinearly blended Coons surface patch from four NURBS
curves that define the boundary.

The orientation of the four NURBS boundary curves.

       ^ V direction
       |
       |      u2
       ------->--------
       |              |
       |              |
    v1 ^   Surface    ^ v2
       |              |
       |              |
       ------->-----------> U direction
              u1

# Arguments:
- `u1`: NURBS curve defining the bottom U direction boundary of the constructed
  NURBS surface.
- `u2`: NURBS curve defining the top U direction boundary of the constructed
  NURBS surface.
- `v1`: NURBS curve defining the bottom V direction boundary of the constructed
  NURBS surface.
- `v1`: NURBS curve defining the top V direction boundary of the constructed
  NURBS surface.

# Output:
- `srf`: Coons NURBS surface patch.

# Examples:
```julia
julia> srf = nrbcoons(u1, u2, v1, v2)
```

Define four NURBS curves and construct a Coons surface patch.
```julia
julia> pnts = [0.0  3.0  4.5  6.5 8.0 10.0;
               0.0  0.0  0.0  0.0 0.0  0.0;
               2.0  2.0  7.0  4.0 7.0  9.0];
julia> crv1 = nrbmak(pnts, vec([0 0 0 1/3 0.5 2/3 1 1 1]));
julia> pnts= [ 0.0  3.0  5.0  8.0 10.0;
              10.0 10.0 10.0 10.0 10.0;
               3.0  5.0  8.0  6.0 10.0];
julia> crv2 = nrbmak(pnts, vec([0 0 0 1/3 2/3 1 1 1]));
julia> pnts= [0.0 0.0 0.0  0.0;
              0.0 3.0 8.0 10.0;
              2.0 0.0 5.0  3.0];
julia> crv3 = nrbmak(pnts, vec([0 0 0 0.5 1 1 1]));
julia> pnts= [10.0 10.0 10.0 10.0 10.0;
               0.0   3.0  5.0  8.0 10.0;
               9.0   7.0  7.0 10.0 10.0];
julia> crv4 = nrbmak(pnts, vec([0 0 0 0.25 0.75 1 1 1]));
julia> srf = nrbcoons(crv1, crv2, crv3, crv4);
julia> nrbplot(srf,[20;20]);
```

"""
function nrbcoons(u1::NURBS1D{I,F},u2::NURBS1D{I,F},
                  v1::NURBS1D{I,F},v2::NURBS1D{I,F}
                 )::NURBS2D{I,F} where {I<:Integer,F<:AbstractFloat}

r1 = nrbruled(u1, u2);
r2 = nrbtransp(nrbruled(v1, v2));
t  = nrb4surf(u1.coefs[:,1], u1.coefs[:,end], u2.coefs[:,1], u2.coefs[:,end]);

# raise all surfaces to a common degree
du = max(r1.order[1], r2.order[1], t.order[1]);
dv = max(r1.order[2], r2.order[2], t.order[2]);
r1 = nrbdegelev(r1, [du - r1.order[1]; dv - r1.order[2]]);
r2 = nrbdegelev(r2, [du - r2.order[1]; dv - r2.order[2]]);
t  = nrbdegelev(t,  [du -  t.order[1]; dv -  t.order[2]]);


# merge the knot vectors, to obtain a common knot vector

# U knots
k1 = r1.knots[1];
k2 = r2.knots[1];
k3 =  t.knots[1];
k = unique([k1;k2;k3]);
n = length(k);
# TODO this is bad, increasing the size without allocating
kua = Vector{F}();
kub = Vector{F}();
kuc = Vector{F}();
for i in 1:n
  i1 = sum(x-> x == k[i],k1);
  i2 = sum(x-> x == k[i],k2);
  i3 = sum(x-> x == k[i],k3);
  m = max(i1, i2, i3);
  if m-i1>0; append!(kua, fill(k[i],m-i1)); end #if
  if m-i2>0; append!(kub, fill(k[i],m-i2)); end #if
  if m-i3>0; append!(kuc, fill(k[i],m-i3)); end #if
end # for i

# U knots
k1 = r1.knots[2];
k2 = r2.knots[2];
k3 =  t.knots[2];
k = unique([k1;k2;k3]);
n = length(k);
# TODO this is bad, increasing the size without allocating
kva = Vector{F}();
kvb = Vector{F}();
kvc = Vector{F}();
for i in 1:n
  i1 = sum(x-> x == k[i],k1);
  i2 = sum(x-> x == k[i],k2);
  i3 = sum(x-> x == k[i],k3);
  m = max(i1, i2, i3);
  if m-i1>0; append!(kva, fill(k[i],m-i1)); end #if
  if m-i2>0; append!(kvb, fill(k[i],m-i2)); end #if
  if m-i3>0; append!(kvc, fill(k[i],m-i3)); end #if
end # for i

if !(isempty(kua)) || !(isempty(kva)); r1 = nrbkntins(r1, [kua,kva]); end # if
if !(isempty(kub)) || !(isempty(kvb)); r2 = nrbkntins(r2, [kub,kvb]); end # if
if !(isempty(kuc)) || !(isempty(kvc)); t  = nrbkntins(t , [kuc,kvc]); end # if

coefs = r1.coefs + r2.coefs - t.coefs;

return nrbmak(coefs, r1.knots);
end # nrbcoons
