# Copyright (c) 2021. J.A. Duffek
# Copyright (c) 2000. D.M. Spink

# TODO: try to find license at fork time or set a appropriate license with
#       regard to Octave packages (the original license was GPL and the octave
#       packages are GPLv2 and GPLv3+)

using DocStringExtensions;

"""
    NURBStoolbox

NURBS Toolbox module ported from the Matlab NURBS toolbox of [TODO cite Spink]
(can currently be found at [TODO cite Mathworks]). The Matlab package dates
approximately back to the year 2000. Newer versions are written for Octave and
are from [TODO cite Octave] (those might be compatible with Matlab).

This package is licensed under GPLv2 [TODO]

# Exports
$(EXPORTS)
"""
module NURBStoolbox

# functions/methods
export NURBS, NURBS1D, NURBS2D, nrbmak;
include("nrbmak.jl");

# demo functions/methods

end # module
