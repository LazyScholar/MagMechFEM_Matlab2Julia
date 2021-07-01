module AHBS_NURBS1D

using Test;
using MagMechFEM_Matlab2Julia.AHBS;

# unit circle 9 control points
p1 = 2;
a = 1/sqrt(2);
knots1 = vec([0 0 0 1/4 1/4 1/2 1/2 3/4 3/4 1 1 1]);
points1 = [1 0 0;1 1 0;0 1 0;-1 1 0;-1 0 0;-1 -1 0;0 -1 0;1 -1 0;1 0 0.0];
weights1 = vec([1 a 1 a 1 a 1 a 1]);

# unit circle 7 control points
p2 = 2;
a = cos(30/180*pi);
knots2 = vec([0 0 0 1/3 1/3 2/3 2/3 1 1 1]);
points2 = [a 1/2 0; 0 2 0; -a 1/2 0; -2*a -1 0; 0 -1 0; 2*a -1 0; a 1/2 0];
weights2 = vec([1 1/2 1 1/2 1 1/2 1]);

# TODO: some more tests preferably analytical ones
@testset "Function: univariate NURBS" begin

  # unit circle 9 control points
  C = univariate_NURBS(collect(range(knots1[1],knots1[end],length=11)),
                       p1,knots1,points1,weights1);
  @test sqrt.(C[:,1].^2 .+ C[:,2].^2) ≈ ones(11);

  # unit circle 7 control points
  C = univariate_NURBS(collect(range(knots2[1],knots2[end],length=11)),
                       p2,knots2,points2,weights2);
  @test sqrt.(C[:,1].^2 .+ C[:,2].^2) ≈ ones(11);

  # just a 2D line
  C = univariate_NURBS(collect(range(knots2[1],knots2[end],length=3)),
                       1,vec([0.0 0 1 1]),[0.0 0.0; 1.0 1.0],vec([1.0 1.0]));
  @test C ≈ [0.0 0.0; 0.5 0.5; 1.0 1.0];

end # testset

end # module
