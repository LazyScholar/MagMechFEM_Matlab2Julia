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
    nrbderiv(nurbs::NURBS{I,F}) where {I<:Integer,F<:AbstractFloat}

Construct the first derivative representation of a NURBS curve or surface.

The derivatives of a B-Spline are themselves a B-Spline of lower degree, giving
an efficient means of evaluating multiple derivatives. However, although the
same approach can be applied to NURBS, the situation for NURBS is more complex.
I have at present restricted the derivatives to just the first. I don't claim
that this implentation is the best approach, but it will have to do for now.
The function returns a data struture that for a NURBS curve contains the first
derivatives of the B-Spline representation. Remember that a NURBS curve is
represented by a univariate B-Spline using the homogeneous coordinates. The
derivative data structure can be evaluated later with the function
[`nrbdeval`](@ref).

# Arguments:
- `nurbs`: NURBS data structure, see [`nrbmak`](@ref).

# Output:
- `dnurbs`: A data structure that represents the first derivatives of a NURBS
  curve or surface.

# Examples:
```julia
julia> dnurbs = nrbderiv(nurbs);
```

See the function [`nrbdeval`](@ref) for an example.

# Reference
- see also: [`bspderiv`](@ref), [`nrbdeval`](@ref)
"""
function nrbderiv(nurbs::NURBS{I,F}) where {I<:Integer,F<:AbstractFloat}
degree = nurbs.order .- 1;

if typeof(nurbs)<:NURBS2D
  # NURBS represents a surface
  num1 = nurbs.number[1];
  num2 = nurbs.number[2];
  dnurbs = Vector{NURBS2D{I,F}}(undef,2)

  dknots = Vector{Vector{F}}(undef,2);
  # taking derivatives along the u direction
  dknots[2] = nurbs.knots[2];
  dcoefs = permutedims(nurbs.coefs,[1,3,2]);
  dcoefs = reshape(dcoefs,(4*num2,num1));
  dcoefs, dknots[1] = bspderiv(degree[1],dcoefs,nurbs.knots[1]);
  dcoefs = permutedims(reshape(dcoefs,(4,num2,size(dcoefs,2))),[1,3,2]);
  dnurbs[1] = nrbmak(dcoefs, dknots);

  dknots = Vector{Vector{F}}(undef,2);
  # taking derivatives along the v direction
  dknots[1] = nurbs.knots[1];
  dcoefs = reshape(nurbs.coefs,(4*num1,num2));
  dcoefs, dknots[2] = bspderiv(degree[2],dcoefs,nurbs.knots[2]);
  dcoefs = reshape(dcoefs,(4,num1,size(dcoefs,2)));
  dnurbs[2] = nrbmak(dcoefs, dknots);

  return dnurbs;
else
  # NURBS represents a curve

  dcoefs, dknots = bspderiv(degree,nurbs.coefs,nurbs.knots);
  dnurbs = nrbmak(dcoefs, dknots);

  return dnurbs;
end # if
end # nrbderiv
