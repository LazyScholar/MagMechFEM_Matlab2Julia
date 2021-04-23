# https://github.com/jheinen/GR.jl/issues/278#issuecomment-587090846
ENV["GKSwstype"] = "nul"

# get path of docs folders
cdir = dirname(@__FILE__);

# add look up paths
push!(LOAD_PATH, joinpath(cdir, ".."));
#push!(LOAD_PATH,"../src)

using Test, Documenter;

#using SRC_PACKAGE

# check if run by CI
CIflag = get(ENV,"CI","") != "";

htmlwriter = Documenter.HTML(
              collapselevel = 2,
              prettyurls = CIflag,
              assets = [asset("assets/logo.ico",class=:ico,islocal=true)]
             );

pages = ["Home"       => "index.md",
        ];

makedocs(sitename = "MagMechFEM_Matlab2Julia",
         authors = "J. A. Duffek",
         format = htmlwriter,
         doctest = false,
         clean = true,
         pages = pages
        );

if CIflag
  deploydocs(
    # TODO:
      repo = "github.com/LazyScholar/MagMechFEM_Matlab2Julia.git",
      push_preview = true,
      forcepush = true,
      devbranch = "main",
      branch = "gh-pages"
     );
else
  println("documentation at: file:///" * joinpath(cdir,"build/index.html"));
end
