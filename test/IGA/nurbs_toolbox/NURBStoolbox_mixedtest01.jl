module NURBStoolbox_mixedtest01

using Test;
using MagMechFEM_Matlab2Julia.NURBStoolbox;

@testset "Mixed Tests: 01" begin

  coefs = cat([0.0 0.0; 0.0 1.0],[1.0 1.0; 0.0 1.0],dims=3);

  # TODO: this here should fail as the second knot vector is not valid!
  #       should throw argument error
  @test_skip nrbmak(coefs,[vec([0.0 0.0 1.0 1.]),vec([0.0 0.5 1.0 1.0])]);
  # TODO: this here should fail as the second knot vector is not valid!
  #       should throw argument error
  @test_skip nrbmak(coefs,[vec([0.0 0.0 1.0 1.]),vec([0.0 1.0 1.0])]);
  # TODO: this here should fail as the second knot vector is not valid!
  #       should throw argument error
  @test_skip nrbmak(coefs,[vec([0.0 0.0 1.0 1.]),vec([0.0])]);

  # TODO: this here should fail as the knot vector is not valid!
  #       should throw argument error
  @test_skip nrbmak([0.0 1.5; 0.0 3.0],vec([0.0]));

end # testset

end # module
