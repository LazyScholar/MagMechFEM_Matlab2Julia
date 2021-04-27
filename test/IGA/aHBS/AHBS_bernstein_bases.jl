module AHBS_bernstein_bases

using Test;
using MagMechFEM_Matlab2Julia.AHBS;

tFloat = typeof(1.0);
tInteger = typeof(1);

function bspBasis(p::tInteger,ξ::Vector{tFloat})
  return (ξ .+ 1).^(transpose(0:p)).*(1 .- ξ).^(p .- transpose(0:p)) .*
         transpose(binomial.(p,0:p) ./ 2^p);
end # bspBasis

function testBspBs(n::tInteger)
  ξ = collect(range(-1,1,length=n));
  Bp1 = bspBasis(1,ξ);
  Bp2 = bspBasis(2,ξ);
  Bp3 = bspBasis(3,ξ);
  Bp4 = bspBasis(4,ξ);
  dBp2 = ([zeros(tFloat,n) Bp1] - [Bp1 zeros(tFloat,n)]).*(2/2);
  dBp3 = ([zeros(tFloat,n) Bp2] - [Bp2 zeros(tFloat,n)]).*(3/2);
  dBp4 = ([zeros(tFloat,n) Bp3] - [Bp3 zeros(tFloat,n)]).*(4/2);
  ddBp3 = ([zeros(tFloat,n) dBp2] - [dBp2 zeros(tFloat,n)]).*(3/2);
  ddBp4 = ([zeros(tFloat,n) dBp3] - [dBp3 zeros(tFloat,n)]).*(4/2);
  dddBp4 = ([zeros(tFloat,n) ddBp3] - [ddBp3 zeros(tFloat,n)]).*(4/2);
  return ξ, Bp1, Bp2, Bp3, Bp4, dBp2, dBp3, dBp4, ddBp3, ddBp4, dddBp4;
end # testBspBs

function testBspBs3D(nA::tInteger,nB::tInteger,nC::tInteger,
                     pA::tInteger,pB::tInteger,pC::tInteger,
             BpA::Matrix{tFloat},BpB::Matrix{tFloat},BpC::Matrix{tFloat},
             dBpA::Matrix{tFloat},dBpB::Matrix{tFloat},dBpC::Matrix{tFloat},
             ddBpA::Matrix{tFloat},ddBpB::Matrix{tFloat},ddBpC::Matrix{tFloat})
  Bp = zeros(tFloat,(nA*nB*nC,(pA+1)*(pB+1)*(pC+1)))
  dBp = zeros(tFloat,(3,(pA+1)*(pB+1)*(pC+1),nA*nB*nC))
  ddBp = zeros(tFloat,(6,(pA+1)*(pB+1)*(pC+1),nA*nB*nC))
  for Bk in 1:pC+1
  for Bj in 1:pB+1
  for Bi in 1:pA+1
    B = (Bk-1)*((pA+1)*(pB+1))+(Bj-1)*(pA+1)+Bi;
    for ik in 1:nC
    for ij in 1:nB
    for ii in 1:nA
      i = (ik-1)*(nA*nB)+(ij-1)*nA+ii;

      Bp[i,B] = BpA[ii,Bi] * BpB[ij,Bj] * BpC[ik,Bk];

      dBp[1,B,i] = dBpA[ii,Bi] *  BpB[ij,Bj] *  BpC[ik,Bk];
      dBp[2,B,i] =  BpA[ii,Bi] * dBpB[ij,Bj] *  BpC[ik,Bk];
      dBp[3,B,i] =  BpA[ii,Bi] *  BpB[ij,Bj] * dBpC[ik,Bk];

      ddBp[1,B,i] = ddBpA[ii,Bi] *   BpB[ij,Bj] *   BpC[ik,Bk];
      ddBp[2,B,i] =   BpA[ii,Bi] * ddBpB[ij,Bj] *   BpC[ik,Bk];
      ddBp[3,B,i] =   BpA[ii,Bi] *   BpB[ij,Bj] * ddBpC[ik,Bk];
      ddBp[4,B,i] =  dBpA[ii,Bi] *  dBpB[ij,Bj] *   BpC[ik,Bk];
      ddBp[5,B,i] =  dBpA[ii,Bi] *   BpB[ij,Bj] *  dBpC[ik,Bk];
      ddBp[6,B,i] =   BpA[ii,Bi] *  dBpB[ij,Bj] *  dBpC[ik,Bk];
    end # for ii
    end # for ij
    end # for ik
  end # for Bi
  end # for Bj
  end # for Bj
  return Bp, dBp, ddBp;
end # testBspBs3D

n1 = 21;
n2 = 6;
n3 = 11;
ξ1,B1p1,B1p2,B1p3,B1p4,dB1p2,dB1p3,dB1p4,ddB1p3,ddB1p4,dddB1p4 = testBspBs(n1);
ξ2,B2p1,B2p2,B2p3,B2p4,dB2p2,dB2p3,dB2p4,ddB2p3,ddB2p4,dddB2p4 = testBspBs(n2);
ξ3,B3p1,B3p2,B3p3,B3p4,dB3p2,dB3p3,dB3p4,ddB3p3,ddB3p4,dddB3p4 = testBspBs(n3);

Bp444,dBp444,ddBp444 = testBspBs3D(n1,n2,n3,4,4,4,B1p4,B2p4,B3p4,
                                   dB1p4,dB2p4,dB3p4,ddB1p4,ddB2p4,ddB3p4);
Bp333,dBp333,ddBp333 = testBspBs3D(n1,n2,n3,3,3,3,B1p3,B2p3,B3p3,
                                   dB1p3,dB2p3,dB3p3,ddB1p3,ddB2p3,ddB3p3);
Bp343,dBp343,ddBp343 = testBspBs3D(n1,n2,n3,3,4,3,B1p3,B2p4,B3p3,
                                   dB1p3,dB2p4,dB3p3,ddB1p3,ddB2p4,ddB3p3);

@testset "Function: 1D Bernstein Base" begin

  @test bernstein_base1D(2,ξ1) ≈ B1p2;
  @test bernstein_base1D(2,ξ1,0) ≈ B1p2;
  @test_throws ArgumentError bernstein_base1D(2,ξ1,3);
  rB1p2, rdB1p2 = bernstein_base1D(2,ξ1,1);
  @test rB1p2 ≈ B1p2;
  @test rdB1p2 ≈ dB1p2;

  @test bernstein_base1D(3,ξ1) ≈ B1p3;
  @test bernstein_base1D(3,ξ1,0) ≈ B1p3;
  @test_throws ArgumentError bernstein_base1D(3,ξ1,4);
  rB1p3, rdB1p3, rddB1p3 = bernstein_base1D(3,ξ1,2);
  @test rB1p3 ≈ B1p3;
  @test rdB1p3 ≈ dB1p3;
  @test rddB1p3 ≈ ddB1p3;

  @test bernstein_base1D(4,ξ1) ≈ B1p4;
  @test bernstein_base1D(4,ξ1,0) ≈ B1p4;
  @test_throws ArgumentError bernstein_base1D(4,ξ1,5);
  rB1p4, rdB1p4, rddB1p4, rdddB1p4 = bernstein_base1D(4,ξ1,3);
  @test rB1p4 ≈ B1p4;
  @test rdB1p4 ≈ dB1p4;
  @test rddB1p4 ≈ ddB1p4;
  @test rdddB1p4 ≈ dddB1p4;

end # testset

@testset "Function: 3D Bernstein Base" begin

  @test bernsteinBasis3D(4,4,4,ξ1,ξ2,ξ3) ≈ Bp444;
  @test bernsteinBasis3D(4,4,4,ξ1,ξ2,ξ3,0) ≈ Bp444;
  rBp, rdBp = bernsteinBasis3D(4,4,4,ξ1,ξ2,ξ3,1);
  @test rBp ≈ Bp444;
  @test rdBp ≈ dBp444;
  rBp, rdBp, rddBp = bernsteinBasis3D(4,4,4,ξ1,ξ2,ξ3,2);
  @test rBp ≈ Bp444;
  @test rdBp ≈ dBp444;
  @test rddBp ≈ ddBp444;

  @test bernsteinBasis3D(3,3,3,ξ1,ξ2,ξ3) ≈ Bp333;
  @test bernsteinBasis3D(3,3,3,ξ1,ξ2,ξ3,0) ≈ Bp333;
  rBp, rdBp = bernsteinBasis3D(3,3,3,ξ1,ξ2,ξ3,1);
  @test rBp ≈ Bp333;
  @test rdBp ≈ dBp333;
  rBp, rdBp, rddBp = bernsteinBasis3D(3,3,3,ξ1,ξ2,ξ3,2);
  @test rBp ≈ Bp333;
  @test rdBp ≈ dBp333;
  @test rddBp ≈ ddBp333;

  @test bernsteinBasis3D(3,4,3,ξ1,ξ2,ξ3) ≈ Bp343;
  @test bernsteinBasis3D(3,4,3,ξ1,ξ2,ξ3,0) ≈ Bp343;
  rBp, rdBp = bernsteinBasis3D(3,4,3,ξ1,ξ2,ξ3,1);
  @test rBp ≈ Bp343;
  @test rdBp ≈ dBp343;
  rBp, rdBp, rddBp = bernsteinBasis3D(3,4,3,ξ1,ξ2,ξ3,2);
  @test rBp ≈ Bp343;
  @test rdBp ≈ dBp343;
  @test rddBp ≈ ddBp343;

end # testset

end # module
