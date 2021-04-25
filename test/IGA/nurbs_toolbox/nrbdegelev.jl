@testset "Function: nrbdegelev" begin
  line = nrbdegelev(nrbline(),2);
  @test line.coefs ≈ [0.0 1/3 2/3 1.0;
                      0.0 0.0 0.0 0.0;
                      0.0 0.0 0.0 0.0;
                      1.0 1.0 1.0 1.0];
  @test line.knots == vec([0.0 0.0 0.0 0.0 1.0 1.0 1.0 1.0]);
  @test line.number == 4;
  @test line.order == 4;
  @test typeof(line)<:NURBS1D;

  @test_throws ArgumentError nrbdegelev(line,[2;5]);
  @test_throws ArgumentError nrbdegelev(nrbtestsrf(),5);
end # testset
