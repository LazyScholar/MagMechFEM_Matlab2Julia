# main test file for AHBS.jl

# TODO: add more tests to test all functions

module test_AHBS

using Test;
using MagMechFEM_Matlab2Julia.AHBS;

@testset "SubModule: AHBS" begin

  include("AHBS_bernstein_bases.jl");
  include("AHBS_NURBS1D.jl");
  include("AHBS_NURBS2D.jl");
  include("AHBS_NURBS3D.jl");
  include("AHBS_oslo1.jl");
  include("AHBS_mixedtest01.jl");

end # testset

end # module
