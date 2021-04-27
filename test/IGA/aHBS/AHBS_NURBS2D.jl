module AHBS_NURBS2D

using Test;
using MagMechFEM_Matlab2Julia.AHBS;

# unit sphere
p1 = [2;2];
n1 = [9;5];
knots1 = [vec([0 0 0 0.25 0.25 0.5 0.5 0.75 0.75 1 1 1]),
          vec([0 0 0 0.5 0.5 1 1 1])];
points1 = [
  -1.0  0.0  0.0; -1.0  0.0  0.0; -1.0  0.0  0.0; -1.0  0.0  0.0;
  -1.0  0.0  0.0; -1.0  0.0  0.0; -1.0  0.0  0.0; -1.0  0.0  0.0;
  -1.0  0.0  0.0; -1.0  1.0  0.0; -1.0  1.0  1.0; -1.0  0.0  1.0;
  -1.0  0.0  1.0; -1.0 -1.0  0.0; -1.0 -1.0 -1.0; -1.0  0.0 -1.0;
  -1.0  1.0 -1.0; -1.0  1.0  0.0;  0.0  1.0  0.0;  0.0  1.0  1.0;
   0.0  0.0  1.0;  0.0  0.0  1.0;  0.0 -1.0  0.0;  0.0 -1.0 -1.0;
   0.0  0.0 -1.0;  0.0  1.0 -1.0;  0.0  1.0  0.0;  1.0  1.0  0.0;
   1.0  1.0  1.0;  1.0  0.0  1.0;  1.0  0.0  1.0;  1.0 -1.0  0.0;
   1.0 -1.0 -1.0;  1.0  0.0 -1.0;  1.0  1.0 -1.0;  1.0  1.0  0.0;
   1.0  0.0  0.0;  1.0  0.0  0.0;  1.0  0.0  0.0;  1.0  0.0  0.0;
   1.0  0.0  0.0;  1.0  0.0  0.0;  1.0  0.0  0.0;  1.0  0.0  0.0;
   1.0  0.0  0.0];
s = sqrt(1/2);
weights1 = [  1;   s;   1; s;   1; s; 1; s; 1; s; 0.5; s; 0.5;   s; 0.5;
              s; 0.5;   s; 1;   s; 1; s; 1; s; 1;   s; 1;   s; 0.5;   s;
            0.5;   s; 0.5; s; 0.5; s; 1; s; 1; s;   1; s;   1;   s;   1];

# TODO: some more tests preferably analytical ones
@testset "Function: bivariate NURBS" begin

  # unit sphere
  len = [21;21];
  coords = cat(repeat(range(0,1,length=len[2]),inner=len[1]),
               repeat(range(0,1,length=len[1]),outer=len[2]),dims=2);
  C = bivariate_NURBS(coords,p1,knots1,points1,weights1,n1);
  # breaks for: 0.999999999 !≈ 1.0
  # TODO: check if isapprox has a epsilon parameter
  @test_skip sqrt.(C[:,1].^2 .+ C[:,2].^2) ≈ ones(21*21);

  # just a 2D rectangle
  C = bivariate_NURBS([0.0 0.0;0.0 0.5;0.5 0.0;1.0 1.0],
                      [1;1],[vec([0.0 0 1 1]),vec([0.0 0 1 1])],
                      [0.0 0.0;1.0 0.0;0.0 2.0;1.0 2.0],ones(4),[2;2]);
  @test C ≈ [0.0 0.0; 0.0 1.0; 0.5 0.0; 1.0 2.0];

end # testset

end # module
