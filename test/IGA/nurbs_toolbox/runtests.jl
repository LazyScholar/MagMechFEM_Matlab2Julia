# main test file for NURBStoolbox.jl

# TODO: add more tests to test all functions
# TODO: add some tests for the plotting functionality
# TODO: add further restrictions to the toolbox functions and add those tests
#       here (e.g: nrbmak with broken knot vectors, ...) see: mixedtest01

module test_NURBStoolbox

using Test;
using MagMechFEM_Matlab2Julia.NURBStoolbox;

@testset "SubModule: NURBStoolbox" begin
  include("nrbline.jl");
  include("nrbdegelev.jl");
  include("NURBStoolbox_mixedtest01.jl");
  include("NURBStoolbox_mixedtest02.jl");
  include("NURBStoolbox_demoruns.jl");
end # testset

end # module
