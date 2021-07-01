"""
    AHBS

Adaptive Hierarchical B-Spline module. Contains some functions and programs
implemented for sparse adaptive hierarchical NURBS support and further
manipulation.

!!! info "Note:"
    The Matlab version had import functions for NURBS from Rhino3D and some
    related UI processing tools. I did not port those as the UI capabilities
    of Julia are still not stable enough (imo) and the Rhino3D integration is
    not of importance for this port.

# Exports
$(DocStringExtensions.EXPORTS)

# Imports
$(DocStringExtensions.IMPORTS)
"""
module AHBS

# the ui_preprocess_rhino_ methods have not been ported as they where mainly
# used for Rhino3D exported data which is not the main using point of this port
# , furthermore the Julia UI capabilities are still growing/unstable

using DocStringExtensions;

# base functions/methods
export bernstein_base1D;
include("bernstein_base1D.jl");
export bernsteinBasis3D;
include("bernsteinBasis3D.jl");
export univariate_NURBS;
include("univariate_NURBS.jl");
export bivariate_NURBS;
include("bivariate_NURBS.jl");
export trivariate_NURBS;
include("trivariate_NURBS.jl");
export oslo1_global;
include("oslo1_global.jl");

# utility functions/methods
export knot_mult_var;
include("knot_mult_var.jl");
export knots_subd_bez;
include("knots_subd_bez.jl");
export get_bezier_extraction_ij;
include("get_bezier_extraction_ij.jl");
export calculate_knot_span;
include("calculate_knot_span.jl");
export degree_elev_1D;
include("degree_elev_1D.jl");

end # AHBS
