module AHBS_oslo1

using Test;
using MagMechFEM_Matlab2Julia.AHBS;

tFloat = typeof(1.0);
tInteger = typeof(1);

p = 2;
knots1 = vec([0.0 0 0 1 2 2 3 4 4 4]);
knots2 = vec([0 0 0 1 2 3 4 4 5 6 7 8 8 8]/2);
knots3 = vec([0 0 0 1 2 3 4 5 6 7 8 8 9 10 11 12 13 14 15 16 16 16]/4);
M_12 = [4 2 0 0 0 0 0 0 0 0 0;
        0 2 3 1 0 0 0 0 0 0 0;
        0 0 1 3 2 0 0 0 0 0 0;
        0 0 0 0 2 4 2 0 0 0 0;
        0 0 0 0 0 0 2 3 1 0 0;
        0 0 0 0 0 0 0 1 3 2 0;
        0 0 0 0 0 0 0 0 0 2 4]/4;
M_23 = [4 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
        0 2 3 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
        0 0 1 3 3 1 0 0 0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 1 3 3 1 0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 1 3 2 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 2 4 2 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 2 3 1 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0 1 3 3 1 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0 0 0 1 3 3 1 0 0;
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 3 2 0;
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 4]/4;

# TODO: some more tests preferably analytical ones
# TODO: add test with B-Spline evaluation before and after refinement
@testset "Function: oslo1" begin

  @test oslo1_global(p,knots1,knots2) ≈ M_12;
  @test oslo1_global(p,knots2,knots3) ≈ M_23;

end # testset

end # module
