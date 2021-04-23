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
    nrbkntins(nurbs::NURBS{I,F}, iknots::Union{Vector{F}, Vector{Vector{F}}}
             )::NURBS{I,F} where {I<:Integer,F<:AbstractFloat}

Insert a single or multiple knots into a NURBS curve or surface.

Inserts knots into the NURBS data structure, these can be knots at new
positions or at the location of existing knots to increase the multiplicity.
Note that the knot multiplicity cannot be increased beyond the order of the
spline. Knots along the V direction can only inserted into NURBS surfaces,
not curves that are always defined along the U direction. This function uses
the B-Spline function [`bspkntins`](@ref).

# Arguments:
- `nurbs`: NURBS structure (curve or surface see [`nrbmak`](@ref))
- `iknots`: vektor of knots or pair of vector of knots to insert into
  respective U,V directions of the structure

# Output:
- `enurbs`: new NURBS structure with degrees elevated

# Examples:
```julia
julia> icrv = nrbkntins(crv,iknots);
julia> isrf = nrbkntins(srf,[iuknots,ivknots]);
```

!!! info "Note:"
    No knot multiplicity will be increased beyond the order of the spline.

Insert two knots into a curve, one at 0.3 and another twice at 0.4.
```julia
julia> icrv = nrbkntins(crv, vec([0.3 0.4 0.4]))
```

Insert into a surface two knots as (1) into the U knot sequence and one knot
into the V knot sequence at 0.5.
```julia
julia> isrf = nrbkntins(srf, [vec([0.3 0.4 0.4]),[0.5]])
```

# Reference
- see also: [`bspkntins`](@ref)
"""
function nrbkntins(nurbs::NURBS{I,F},iknots::Union{Vector{F},Vector{Vector{F}}}
                  )::NURBS{I,F} where {I<:Integer,F<:AbstractFloat}
# TODO: this ported version does not do all the tests of the matlab version,
#       instead the type features of julia are used -> check if the matlab
#       errors get caught

degree = nurbs.order .- 1;

if typeof(nurbs)<:NURBS2D
  if typeof(iknots)<:Vector{F} || length(iknots) != 2
    throw(ArgumentError("iknots must be a vector of two Vector{F}!"));
  end # if
  # NURBS represents a surface
  num1 = nurbs.number[1];
  num2 = nurbs.number[2];
  knots = Vector{Vector{F}}(undef,2);

  # Degree elevate along the v direction
  if isempty(iknots[2])
    # TODO: i think julia might not even allow empty vectors
    coefs = nurbs.coefs;
    knots[2] = nurbs.knots[2];
  else
    coefs = reshape(nurbs.coefs,(4*num1,num2));
    coefs, knots[2] = bspkntins(degree[2],coefs,nurbs.knots[2],iknots[2]);
    num2 = size(coefs,2);
    coefs = reshape(coefs,(4, num1, num2));
  end # if

  # Degree elevate along the u direction
  if isempty(iknots[1])
    # TODO: i think julia might not even allow empty vectors
    knots[1] = nurbs.knots[1];
  else
    coefs = permutedims(coefs,[1,3,2]);
    coefs = reshape(coefs,(4*num2,num1));
    coefs, knots[1] = bspkntins(degree[1],coefs,nurbs.knots[1],iknots[1]);
    coefs = reshape(coefs,(4,num2,size(coefs,2)));
    coefs = permutedims(coefs,[1,3,2]);
  end # if

  # build the new nurbs surface
  return nrbmak(coefs,knots);
else
  if !(typeof(iknots)<:Vector{F})
    throw(ArgumentError("Valid input of iknots for curves is Vector{F}!"));
  end # if

  # NURBS represents a curve
  if isempty(iknots)
    # TODO: i think julia might not even allow empty vectors
    coefs = nurbs.coefs;
    knots = nurbs.knots;
  else
    coefs, knots = bspkntins(degree,nurbs.coefs,nurbs.knots,iknots);
  end # if

  # build the new nurbs curve
  return nrbmak(coefs,knots);
end # if
end # nrbkntins
