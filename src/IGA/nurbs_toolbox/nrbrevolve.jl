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
    nrbrevolve(crv::NURBS1D{I,F},vec::Vector{F},
               pnt::Vector{F}=[0.0;0.0;0.0],theta::F=2.0*π
              )::NURBS2D{I,F} where {I<:Integer,F<:AbstractFloat}

Construct a NURBS surface by revolving the profile NURBS curve around an axis
defined by a point and vector.

# Arguments:
- `crv`: NURBS curve to revolve, see [`nrbmak`](@ref).
- `vec`: Vector defining the direction of the rotation axis.
- `pnt`: Coordinate of the point used to define the axis of rotation.
- `theta`: Angle to revolve the curve, default `2*π`.

# Output:
- `srf`: Constructed surface.

# Examples:
```julia
julia> srf = nrbrevolve(crv,vec)
julia> srf = nrbrevolve(crv,vec,pnt)
julia> srf = nrbrevolve(crv,vec,pnt,ang)
```

Construct a sphere by rotating a semicircle around a x-axis.
```julia
julia> crv = nrbcirc(1.0,[0.0;0.0;0.0],0.0,pi);
julia> srf = nrbrevolve(crv,[1.0;0.0;0.0],[0.0;0.0;0.0]);
julia> nrbplot(srf,[20;20]);
```

# The algorithm:

1. vectrans the point to the origin `[0.0;0.0;0.0]`
2. rotate the vector into alignment with the z-axis
3. for each control point along the curve
   1. determine the radius and angle of control point to the z-axis
   2. construct a circular arc in the x-y plane with this radius and start
      angle and sweep angle theta
   3. combine the arc and profile, coefs and weights.
   4. next control point
4. rotate and vectrans the surface back into position by reversing 1 and 2.
"""
function nrbrevolve(crv::NURBS1D{I,F},vec::Vector{F},
                    pnt::Vector{F}=[0.0;0.0;0.0],theta::F=2.0*π
                   )::NURBS2D{I,F} where {I<:Integer,F<:AbstractFloat}
# TODO: optional arguments in julia are always at the end i switched vec and
#       pnt argument > examine if that did change the behaviour in this toolbox

if length(vec) != 3 || length(pnt) !=3
  throw(ArgumentError("All point and vector coordinates must be 3D!"));
end # if

# Translate and rotate the curve into alignment with the z-axis
T  = vectrans(-pnt);
angx = vecangle(vec[1],vec[3]);
RY = vecroty(-angx);
vectmp = RY * [vecnorm_toolbox(vec);1.0];
angy = vecangle(vectmp[2],vectmp[3]);
RX = vecrotx(angy);
curve = nrbtform(crv,RX*RY*T);

# Construct an arc
arc = nrbcirc(1.0,[0.0;0.0;0.0],0.0,theta);

# Construct the surface
coefs = zeros(F,(4,arc.number,curve.number));
angle = vecangle(curve.coefs[2:2,:],curve.coefs[1:1,:]);
radius = vecmag(curve.coefs[1:2,:]);
for i in 1:curve.number
  coefs[:,:,i] = vecrotz(angle[i]) *
                 vectrans([0.0;0.0;curve.coefs[3,i]]) *
                 vecscale([radius[i];radius[i]]) * arc.coefs;
  coefs[4,:,i] = coefs[4,:,i] * curve.coefs[4,i];
end # for i
surf = nrbmak(coefs,[arc.knots,curve.knots]);

# Rotate and vectrans the surface back into position
T = vectrans(pnt);
RX = vecrotx(-angy);
RY = vecroty(angx);
return nrbtform(surf,T*RY*RX);
end # nrbrevolve
