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
    vecangle(num::Matrix{F},den::Matrix{F}
            )::Matrix{F} where {F<:AbstractFloat}

or

    vecangle(num::F,den::F)::Vector{F} where {F<:AbstractFloat}

An alternative to atan, returning an arctangent in the range `0` to `2*π`.

The components of the vector ang are the arctangent of the corresponding enties
of `num./den`. This function is an alternative for atan, returning an angle in
the range `0` to `2*π`.

# Arguments:
- `num`: Numerator, vector of size `(1,nv)`.
- `den`: Denominator, vector of size `(1,nv)`.

# Output:
- `ang`: Arctangents, row vector of angles.

# Examples:
```julia
julia> ang = vecmag2(num,dum)
```

Find the `atan(1.2,2.0)` and `atan(1.5,3.4)` using `vecangle`.
```julia
julia> ang = vecangle([1.2 1.5], [2.0 3.4])
```
"""
function vecangle(num::Matrix{F},den::Matrix{F}
                 )::Matrix{F} where {F<:AbstractFloat}
ang = atan.(num,den);
ang[ang .< 0.0] .+= 2*π;
return ang;
end # vecangle

# overloaded function for float input to get a float instead of a vector
function vecangle(num::F,den::F)::F where {F<:AbstractFloat}
ang = atan(num,den);
if ang < 0.0
  ang += 2*π;
end # if
return ang;
end # vecangle
