# https://github.com/jheinen/GR.jl/issues/278#issuecomment-587090846
ENV["GKSwstype"] = "nul"

# get path of docs folders
cdir = dirname(@__FILE__);
ldir = joinpath(cdir,"literate");
tdir = joinpath(cdir,"src","literate");

# add look up paths
push!(LOAD_PATH, joinpath(cdir, ".."));
# TODO: delete this later
push!(LOAD_PATH, joinpath(cdir,"..","src/IGA/nurbs_toolbox"));
#push!(LOAD_PATH,"../src)

using Test, Documenter, DocumenterCitations;
using Literate;

# TODO: update this at the end
#using SRC_PACKAGE
using NURBStoolbox;

# check if run by CI
CIflag = get(ENV,"CI","") != "";

# directory filtering function
filterdir(ext,path) = filter(x->(contains(x,ext) && isfile(joinpath(path,x))),
                             readdir(path));

# convert  literate files to markdown
for f in filterdir(".jl",ldir)
  if CIflag
    Literate.markdown(joinpath(ldir,f),tdir);
  else
    Literate.markdown(joinpath(ldir,f),tdir,
                      repo_root_url="../../..");
  end
end

bib = CitationBibliography(joinpath(cdir, "bibliography.bib"))

htmlwriter = Documenter.HTML(
              collapselevel = 2,
              prettyurls = CIflag,
              assets = [asset("assets/logo.ico",class=:ico,islocal=true)]
             );

pages = ["Home"       => "index.md",
         "Packages"   => [ "NURBS Toolbox" => "NURBStoolbox.md", ],
         "API"        => [ "NURBS Toolbox" => "api_NURBStoolbox.md", ],
         "Examples"   => [ "NURBS Toolbox" => "literate/ex_NURBStoolbox.md", ],
         "References" => "references.md",
        ];

makedocs(bib,
         sitename = "MagMechFEM_Matlab2Julia",
         authors = "J. A. Duffek",
         # TODO update this at the end
#         modules = [NURBStoolbox]
         format = htmlwriter,
         doctest = false,
         clean = true,
         pages = pages
        );

if CIflag
  deploydocs(
      repo = "github.com/LazyScholar/MagMechFEM_Matlab2Julia.git",
      push_preview = true,
      forcepush = true,
      devbranch = "main",
      branch = "gh-pages"
     );
else
  println("documentation at: file:///" * joinpath(cdir,"build/index.html"));
end
