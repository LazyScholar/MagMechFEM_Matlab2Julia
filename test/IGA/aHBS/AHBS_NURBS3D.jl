module AHBS_NURBS3D

using Test;
using MagMechFEM_Matlab2Julia.AHBS;

# TODO: some more tests preferably analytical ones
@testset "Function: trivariate NURBS" begin

  # just a cube
  C = trivariate_NURBS([0.0 0.0 0.0; 0.0 0.5 0.0; 0.5 0.0 0.0; 1.0 1.0 0.0;
                        0.0 0.0 0.5; 0.0 1.0 1.0; 1.0 1.0 1.0],
                       [1;1;1],
                       [vec([0.0 0 1 1]),vec([0.0 0 1 1]),vec([0.0 0 1 1])],
                       [0.0 0.0 0.0; 1.0 0.0 0.0; 0.0 2.0 0.0; 1.0 2.0 0.0;
                        0.0 0.0 3.0; 1.0 0.0 3.0; 0.0 2.0 3.0; 1.0 2.0 3.0],
                       ones(8),[2;2;2]);
  @test C ≈ [0.0 0.0 0.0; 0.0 1.0 0.0; 0.5 0.0 0.0; 1.0 2.0 0.0;
             0.0 0.0 1.5; 0.0 2.0 3.0; 1.0 2.0 3.0];

end # testset

end # module
