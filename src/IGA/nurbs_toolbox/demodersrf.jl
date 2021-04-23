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

using Plots;

"""
    demodersrf()

Demonstrates the construction of a general surface derivatives.

# Examples:
```julia
julia> demodersrf()
```
"""
function demodersrf()
# make and draw nurbs test surface
srf = nrbtestsrf();
nrbplot(srf,[20;20],
        title = "First derivatives over a test surface.",
        c = :winter,
        legend = nothing,
        linewidth = 0.5,
        linecolor = :black,
        camera=[-30,30]);

npts = 5;
tt = collect(range(0.0,1.0,length=npts));

dsrf = nrbderiv(srf);
p1, dp = nrbdeval(srf,dsrf,[tt,tt]);

up2 = vecnorm_toolbox(dp[1]);
vp2 = vecnorm_toolbox(dp[2]);

plot!(vec(p1[1,:,:]),vec(p1[2,:,:]),vec(p1[3,:,:]),
      m = (3, :transparent, stroke(1, :red)),
      st = :scatter,
      legend = false);
plot!(vec(p1[1,:,:]),vec(p1[2,:,:]),vec(p1[3,:,:]),
      st=:quiver,
      quiver=(vec(up2[1,:,:]),vec(up2[2,:,:]),vec(up2[3,:,:])),
      c=:red);
plot!(vec(p1[1,:,:]),vec(p1[2,:,:]),vec(p1[3,:,:]),
      st=:quiver,
      quiver=(vec(vp2[1,:,:]),vec(vp2[2,:,:]),vec(vp2[3,:,:])),
      c=:red);
end # demodersrf
