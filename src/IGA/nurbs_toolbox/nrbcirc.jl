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
    nrbcirc(radius::F=1.0,center::Vector{Any}=[],
            sang::F=0.0,eang::F=2.0*π)::NURBS1D where {F<:AbstractFloat}

Construct a circular arc.

Constructs NURBS data structure for a circular arc in the x-y plane. If no
arguments are supplied a unit circle with center (0.0,0.0) is constructed.

Angles are defined as positive in the anti-clockwise direction.

# Arguments:
- `radius`: Radius of the circle, default `1.0`
- `center`: Center of the circle, default `[0.0;0.0;0.0]`
- `sang`: Start angle, default `0` degrees
- `eang`: End angle `360` degrees

# Output:
- `crv`: NURBS curve for a circular arc.

# Examples:
```julia
julia> crv = nrbcirc()
julia> crv = nrbcirc(radius)
julia> crv = nrbcirc(radius,center)
julia> crv = nrbcirc(radius,center,sang,eang)
```
"""
function nrbcirc(radius::F=1.0,center::Vector{Any}=[],
                 sang::F=0.0,eang::F=2.0*π)::NURBS1D where {F<:AbstractFloat}
# TODO: maybe revisit this function and split it up
# TODO: optional arguments should be at the end the center=[] solution is
#       therefore a bad hack

# sweep angle of arc
sweep = eang - sang;
if sweep < 0
  sweep = 2 * π + sweep;
end # if

if abs(sweep) <= π/2
  narcs = 1;
  knots = vec([0.0 0.0 0.0 1.0 1.0 1.0]);
elseif abs(sweep) <= π
  narcs = 2;
  knots = vec([0.0 0.0 0.0 1/2 1/2 1.0 1.0 1.0]);
elseif abs(sweep) <= π*3/2
  narcs = 3;
  knots = vec([0.0 0.0 0.0 1/3 1/3 2/3 2/3 1.0 1.0 1.0]);
else
  narcs = 4;
  knots = vec([0.0 0.0 0.0 1/4 1/4 1/2 1/2 3/4 3/4 1.0 1.0 1.0]);
end # if

# arc segment sweep angle/2
dsweep = sweep / (2 * narcs);

# determine middle control point and weight
wm = cos(dsweep);
x  = radius * wm;
y  = radius * sin(dsweep);
xm = x + y * tan(dsweep);

# arc segment control points
ctrlpt = [ x wm*xm x;  # w*x - coordinate
          -y 0     y;  # w*y - coordinate
           0 0     0;  # w*z - coordinate
           1 wm    1]; # w   - coordinate

# build up complete arc from rotated segments
coefs = zeros(F,(4,2*narcs+1)); # nurbs control points of arc
xx = vecrotz(sang + dsweep);
coefs[:,1:3] = xx * ctrlpt;     # rotate to start angle
xx = vecrotz(2 * dsweep);
for n in 2:narcs
  m = (0:1) .+ (2*n);
  coefs[:,m] = xx * coefs[:,m .- 2];
end # if

# vectrans arc if necessary
if !(isempty(center))
  if typeof(center)<:Vector{F}
    xx = vectrans(center);
    coefs = xx * coefs;
  else
    throw(ArgumentError("Center Vector musst be of Float values!"));
  end
end

return nrbmak(coefs,knots);
end # nrbcirc
