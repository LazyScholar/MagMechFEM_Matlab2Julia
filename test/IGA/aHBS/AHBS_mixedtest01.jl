module AHBS_mixedtest01

using Test;
using MagMechFEM_Matlab2Julia.AHBS;

p = 2;
knots1 = vec([0.0 0 0 1 2 2 3 4 4 4]);
BEOij1 = [1 1;
          2 3;
          4 5;
          5 7];
knots2 = vec([0 0 0 1 2 3 4 4 5 6 7 8 8 8]/2);
BEOij2 = [1  1;
          2  3;
          3  5;
          4  7;
          6  9;
          7 11;
          8 13;
          9 15];
knots3 = vec([0 0 0 1 2 3 4 5 6 7 8 8 9 10 11 12 13 14 15 16 16 16]/4);
BEOij3 = [ 1  1;  2  3;
           3  5;  4  7;
           5  9;  6 11;
           7 13;  8 15;
          10 17; 11 19;
          12 21; 13 23;
          14 25; 15 27;
          16 29; 17 31];

# TODO: some more tests preferably analytical ones
@testset "Function: Bézier ij Indizes" begin

  @test get_bezier_extraction_ij(p,knots1) ≈ BEOij1;
  @test get_bezier_extraction_ij(p,knots2) ≈ BEOij2;
  @test get_bezier_extraction_ij(p,knots3) ≈ BEOij3;

end # testset

end # module
