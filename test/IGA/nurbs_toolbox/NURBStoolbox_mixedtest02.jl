module NURBStoolbox_mixedtest02

using Test;
using MagMechFEM_Matlab2Julia.NURBStoolbox;

@testset "Mixed Tests: 02" begin

  crv = nrbtestcrv();
  evalpoints = vec([0.0 0.25 0.5 0.75 1.0]);
  evalresult = [0.5 3.0 3.75 7.5 8.5;
                3.0 5.5 3.5  1.5 4.5;
                0.0 0.0 0.0  0.0 0.0];

  @test nrbeval(crv,evalpoints) ≈ evalresult;
  @test nrbeval(nrbkntins(crv,[0.5;0.75]),evalpoints) ≈ evalresult;
  @test nrbeval(nrbdegelev(crv,2),evalpoints) ≈ evalresult;
  @test nrbeval(nrbtform(crv,vectrans([2.0;-3.0;5.0])),
                evalpoints) ≈ evalresult .+ [2.0;-3.0;5.0];

end # testset

end # module
