@testset "Function: nrbline" begin
  line = nrbline();
  @test line.coefs == [0.0 1.0; 0.0 0.0; 0.0 0.0; 1.0 1.0];
  @test line.knots == vec([0.0 0.0 1.0 1.0]);
  @test line.number == 2;
  @test line.order == 2;
  @test typeof(line)<:NURBS1D;

  line = nrbline([-1.0;-1.0;-3.0],[3.0;1.0;1.0]);
  @test line.coefs == [-1.0 3.0;-1.0 1.0;-3.0 1.0; 1.0 1.0];
  @test line.knots == vec([0.0 0.0 1.0 1.0]);
  @test line.number == 2;
  @test line.order == 2;
  @test typeof(line)<:NURBS1D;

  @test_throws ArgumentError nrbline([-1.0;-1.0;-3.0],[3.0;1.0;1.0;2.0]);
  @test_throws ArgumentError nrbline([-1.0;-1.0;-3.0],[3.0;1.0]);
end # testset
