module NURBStoolbox_demoruns

using Test;
using Plots;
using MagMechFEM_Matlab2Julia.NURBStoolbox;

#ENV[“GKSwstype”] = “nul”; # this omits those tests
Plots.default(show=false);

# TODO: find a good way to test plot output or plotting in general

@testset "Function: Demos" begin

  @test typeof(demo4surf())<:Plots.Plot;
  @test typeof(democirc())<:Plots.Plot;
  @test typeof(democoons())<:Plots.Plot;
  @test typeof(democurve())<:Plots.Plot;
  @test typeof(democylind())<:Plots.Plot;
  @test typeof(demodegelev())<:Plots.Plot;
  @test typeof(demodercrv())<:Plots.Plot;
  @test typeof(demodersrf())<:Plots.Plot;
  @test typeof(demoellip())<:Plots.Plot;
  @test typeof(demogeom())<:Plots.Plot;
  @test typeof(demohelix())<:Plots.Plot;
  @test typeof(demokntins())<:Plots.Plot;
  @test typeof(demoline())<:Plots.Plot;
  @test typeof(demorect())<:Plots.Plot;
  @test typeof(demorevolve())<:Plots.Plot;
  @test typeof(demoruled())<:Plots.Plot;
  @test typeof(demotorus())<:Plots.Plot;

end # testset

end # module
