module MagMechFEM_Matlab2Julia

include(joinpath("IGA","nurbs_toolbox","NURBStoolbox.jl"));
include(joinpath("IGA","aHBS","AHBS.jl"));

greet() = print("Hello World!")

end # module
