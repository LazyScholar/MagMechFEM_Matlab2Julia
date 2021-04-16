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

# TODO: i could use StaticArrays.jl for a more fixed type definition
using DocStringExtensions;

"""
    nrbmak(coefs::Union{Matrix{F}, Array{F,3}},
           knots::Union{Vector{F}, Vector{Vector{F}}}
          )::NURBS where {F<:AbstractFloat}

Construct the NURBS structure given the control points and the knots.

This function is used as a convenient means of constructing the NURBS data
structure. Many of the other functions in the toolbox rely on the NURBS
structure been correctly defined. This function not only constructs the proper
structure, but also checks for consistency. The user is still free to build his
own structure, in fact a few functions in the toolbox do this for convenience.

# Arguments:
- `coefs`: Control points, these can be either Cartesian or homogeneous
  coordinates.
  For a curve the control points are represented by a matrix of size `(dim,nu)`
  and for a surface by a multidimensional array of size `(dim,nu,nv)`. Where
  `nu` is number of points along the parametric U direction, and `nv` the
  number of points along the V direction. `dim` is the dimension valid options
  are:
    2 : (x,y)        2D Cartesian coordinates
    3 : (x,y,z)      3D Cartesian coordinates
    4 : (wx,wy,wz,w) 4D homogeneous coordinates
- `knots`: Non-decreasing knot sequence spanning the interval [0.0,1.0]. It is
  assumed that the curves and surfaces are clamped to the start and end control
  points by knot multiplicities equal to the spline order. For a curve knots
  form a vector and for a surface the knots are stored by two vectors for U and
  V in a vector of vectors [uknots; vknots]

# Output:
- `nurbs`: NURBS data structure see [`NURBS1D`](@ref) and [`NURBS2D`](@ref).

!!! info "Note:"
    The control points are always converted and stored within the NURBS
    structure as 4D homogeneous coordinates. For a surface the spline degree is
    a vector `[du;dv]` containing the order along the U and V directions
    respectively.

# Examples:
Construct a 2D line from (0.0,0.0) to (1.5,3.0). For a straight line a spline
of order 2 is required. Note that the knot sequence has a multiplicity of 2 at
the start (0.0,0.0) and end (1.0 1.0) in order to clamp the ends.

```julia
julia> line = nrbmak([0.0 1.5; 0.0 3.0],vec([0.0 0.0 1.0 1.0]))
```

Construct a surface in the x-y plane i.e

    ^  (0.0,1.0) ------------ (1.0,1.0)
    |      |                      |
    | V    |                      |
    |      |      Surface         |
    |      |                      |
    |      |                      |
    |  (0.0,0.0) ------------ (1.0,0.0)
    |
    |------------------------------------>
                                      U

```julia
julia> coefs = cat([0.0 0.0; 0.0 1.0],[1.0 1.0; 0.0 1.0],dims=3);
julia> knots = [vec([0.0 0.0 1.0 1.]),vec([0.0 0.0 1.0 1.0])];
julia> plane = nrbmak(coefs,knots)
```

# Reference:
- related data types: [`NURBS1D`](@ref) and [`NURBS2D`](@ref)
"""
function nrbmak(coefs::Union{Matrix{F}, Array{F,3}},
                knots::Union{Vector{F}, Vector{Vector{F}}}
               )::NURBS where {F<:AbstractFloat}
# TODO: the matlab version does not check for open NURBS
# TODO: the matlab version does no further knot checking it only sorts and
#       normalizes
# TODO: have a look if [vec1,vec2] gives always vec([vec1,vec2])
# TODO: nrbmak does not check the m=p+1 start and end knot requirement which
#       could lead to a infinite loop at findspan
# TODO: nrbmak does not check for the m<=p requirement for central knots

nform = "B-NURBS";
ndim = 4;
np = size(coefs);
dim = np[1];
if typeof(knots)<:Vector{Vector{F}}
  if !(typeof(coefs)<:Array{F,3})
    throw(ArgumentError("coefs for surface has to be a Array{F,3}!"));
  end # if
  # constructing a surface
  number = [np[2];np[3]];
  if dim < 4
    ncoefs = zeros(F,(4,np[2],np[3]));
    ncoefs[4,:,:] .= 1.0;
    ncoefs[1:dim,:,:] = coefs;
  else
    ncoefs = coefs;
  end # if
  uorder = length(knots[1]) - np[2];
  vorder = length(knots[2]) - np[3];
  uknots = sort(knots[1]);
  vknots = sort(knots[2]);
  uknots .= (uknots .- uknots[1]) ./ (uknots[end] - uknots[1]);
  vknots .= (vknots .- vknots[1]) ./ (vknots[end] - vknots[1]);
  nknots = [uknots,vknots];
  norder = [uorder;vorder];
  return NURBS2D{typeof(ndim),F}(nform,ndim,number,norder,nknots,ncoefs);
else
  if !(typeof(coefs)<:Matrix{F})
    throw(ArgumentError("coefs for curve has to be a Matrix{F}!"));
  end # if
  # constructing a cruve
  number = np[2];
  if dim < 4
    ncoefs = zeros(F,(4,np[2]));
    ncoefs[4,:] .= 1.0;
    ncoefs[1:dim,:] = coefs;
  else
    ncoefs = coefs;
  end # if
  norder = length(knots) - np[2];
  nknots = sort(knots);
  nknots = (nknots .- knots[1]) ./ (knots[end] - knots[1]);
  return NURBS1D{typeof(ndim),F}(nform,ndim,number,norder,nknots,ncoefs);
end # if
end# nrbmak

"""
    NURBS{I<:Integer,F<:AbstractFloat}

Abstract supertype for NURBS data tayps see [`NURBS1D`](@ref) and
[`NURBS2D`](@ref).

Both curves and surfaces where represented by a structure that where compatible
with the Spline Toolbox from Mathworks.
"""
abstract type NURBS{I<:Integer,F<:AbstractFloat} end

"""
    NURBS1D{I<:Integer,F<:AbstractFloat} <: NURBS{I,F}

NURBS datatype representing a NURBS curve. Constructed with [`nrbmak`](@ref).

!!! info "Note:"
    The control points are always converted and stored within the NURBS
    structure as 4D homogeneous coordinates.

# Field
$(DocStringExtensions.FIELDS)
"""
struct NURBS1D{I<:Integer,F<:AbstractFloat} <: NURBS{I,F}
"Type name 'B-NURBS'"
form::String
"Dimension of the control points"
dim::I
"Number of Control points"
number::I
"Order of the spline"
order::I
"Knot sequence"
knots::Vector{F}
"Control Points"
coefs::Matrix{F}
end # NURBS1D

"""
    NURBS2D{I<:Integer,F<:AbstractFloat} <: NURBS{I,F}

NURBS datatype representing a NURBS surface. Constructed with [`nrbmak`](@ref).

!!! info "Note:"
    The control points are always converted and stored within the NURBS
    structure as 4D homogeneous coordinates. For a surface the spline degree is
    a vector `[du;dv]` containing the order along the U and V directions
    respectively.

# Field
$(DocStringExtensions.FIELDS)
"""
struct NURBS2D{I<:Integer,F<:AbstractFloat} <: NURBS{I,F}
"Type name 'B-NURBS'"
form::String
"Dimension of the control points"
dim::I
"Number of Control points"
number::Vector{I}
"Order of the spline"
order::Vector{I}
"Knot sequence"
knots::Vector{Vector{F}}
"Control Points"
coefs::Array{F,3}
end # NURBS2D

# pretty printing NURBS1D
Base.show(io::IO, ::MIME"text/plain", z::NURBS1D{I,F}) where{I,F} =
  print(io, "NURBS1D{$I, $F} curve nurbs structre:\n   ", z);
Base.show(io::IO, z::NURBS1D) = print(io,"order: ",z.order ,", ",
                                      "#points: ", z.number);

# pretty printing NURBS2D
Base.show(io::IO, ::MIME"text/plain", z::NURBS2D{I,F}) where{I,F} =
  print(io, "NURBS2D{$I, $F} surface nurbs structre:\n   ", z);
Base.show(io::IO, z::NURBS2D) = print(io,"order: ",z.order ,", ",
                                      "#points: ", z.number);
