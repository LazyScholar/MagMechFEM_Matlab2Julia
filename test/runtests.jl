# https://github.com/jheinen/GR.jl/issues/278#issuecomment-587090846
# TODO: this here might circumvent the plot tests
ENV["GKSwstype"] = "nul";

using Test;

include(joinpath("IGA","nurbs_toolbox","runtests.jl"));
include(joinpath("IGA","aHBS","runtests.jl"));
