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

using DocStringExtensions;

"""
    NURBStoolbox

NURBS Toolbox module ported from the Matlab NURBS toolbox of [2000Spink](@cite)
(can currently be found on Mathworks FileExchange[^1]). The Matlab package dates
approximately back to the year 2000. Newer versions are written for Octave and
are hosted as Octave Community package[^2] (those might be compatible with Matlab).

This package is licensed under GNU General Puplic License version 2.

[^1]: Penguian (2010). NURBS Toolbox by D.M. Spink [https://www.mathworks.com/matlabcentral/fileexchange/26390-nurbs-toolbox-by-d-m-spink](https://www.mathworks.com/matlabcentral/fileexchange/26390-nurbs-toolbox-by-d-m-spink), MATLAB Central File Exchange. Retrieved April 14, 2021.
[^2]: M. Spink, D. Claxton, C. de Falco, R. Vazquez (2021-03-09) Nurbs. Octave Forge Community packages. [https://octave.sourceforge.io/nurbs/index.html](https://octave.sourceforge.io/nurbs/index.html)

# Exports
$(DocStringExtensions.EXPORTS)

# Imports
$(DocStringExtensions.IMPORTS)
"""
module NURBStoolbox

# Evaluation functions/methods
export basisfun;
include("basisfun.jl");
export bspeval;
include("bspeval.jl");
export NURBS, NURBS1D, NURBS2D, nrbmak;
include("nrbmak.jl");
export nrbeval;
include("nrbeval.jl");
export nrbplot, nrbplot!;
include("nrbplot.jl");

# Utility and modification functions/methods
export findspan;
include("findspan.jl")
export vecscale;
include("vecscale.jl")
export vectrans;
include("vectrans.jl")
export vecrotx;
include("vecrotx.jl")
export vecroty;
include("vecroty.jl")
export vecrotz;
include("vecrotz.jl")
export nrbtform;
include("nrbtform.jl");
export nrbextrude;
include("nrbextrude.jl");
export nrbrevolve;
include("nrbrevolve.jl");
export vecdot;
include("vecdot.jl");
export veccross;
include("veccross.jl");
export vecmag;
include("vecmag.jl");
export vecmag2;
include("vecmag2.jl");
export vecnorm_toolbox
include("vecnorm_toolbox.jl");
export vecangle;
include("vecangle.jl");
export nrbtransp;
include("nrbtransp.jl");
export bspdegelev;
include("bspdegelev.jl")
export nrbdegelev;
include("nrbdegelev.jl");
export bspkntins;
include("bspkntins.jl");
export nrbkntins;
include("nrbkntins.jl");
export bspderiv;
include("bspderiv.jl");
export nrbderiv;
include("nrbderiv.jl");
export nrbdeval;
include("nrbdeval.jl");
# deg2rad is a julia build in function therefore omitted
# rad2deg is a julia build in function therefore omitted

# "recipes" of NURBS structures
export nrbline;
include("nrbline.jl");
export nrbrect;
include("nrbrect.jl");
export nrbcirc;
include("nrbcirc.jl");
export nrbcylind;
include("nrbcylind.jl");

# demo/test functions/methods
export nrbtestcrv;
include("nrbtestcrv.jl");
export nrbtestsrf;
include("nrbtestsrf.jl");
export demoline;
include("demoline.jl");
export demorect;
include("demorect.jl");
export democirc;
include("democirc.jl");
export demoellip;
include("demoellip.jl");
export democurve;
include("democurve.jl");
export demohelix;
include("demohelix.jl");
export democylind;
include("democylind.jl");
export demotorus;
include("demotorus.jl");
export demorevolve;
include("demorevolve.jl");
export demodegelev;
include("demodegelev.jl")
export demokntins;
include("demokntins.jl")
export demodercrv;
include("demodercrv.jl");
export demodersrf;
include("demodersrf.jl");

end # NURBStoolbox
