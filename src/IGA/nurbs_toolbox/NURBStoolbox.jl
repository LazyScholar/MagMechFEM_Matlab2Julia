# Copyright (c) 2021 J.A. Duffek
# Copyright (c) 2000 D.M. Spink
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.

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
$(EXPORTS)
"""
module NURBStoolbox

# functions/methods
export NURBS, NURBS1D, NURBS2D, nrbmak;
include("nrbmak.jl");

# demo functions/methods

end # module
