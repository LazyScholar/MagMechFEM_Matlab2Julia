# assure that the operations are run from /docs/ directory
cd(dirname(@__FILE__))
# pull in the source path
push!(LOAD_PATH,joinpath(@__DIR__,"..","src/IGA/nurbs_toolbox"));

#using SRC_PACKAGE
using Test;
using Documenter;
using DocumenterCitations;
using Weave;

using NURBStoolbox;

# directory filtering function
filterdir(ext,path) = filter(x->(contains(x,ext) && isfile(joinpath(path,x))),
                             readdir(path));

# convert the notebooks to weave in order to have them in source control
for f in replace.(filterdir(".ipynb","./notebooks/"),".ipynb"=>"")
  file = joinpath(@__DIR__,"notebooks",f);
  if !(isfile("$file.jl"))
    @info "converting $f to weave file"
    convert_doc("$file.ipynb","$file.jl");
    touch("$file.jl");
    touch("$file.ipynb");
  end
end

# convert weave files to notebooks and markdown in order to allow the use of
# them in the documentation an to modify the easily
for f in replace.(filterdir(".jl","./notebooks/"),".jl"=>"")
  file = joinpath(@__DIR__,"notebooks",f);
  if isfile("$file.ipynb") &&
    if stat("$file.jl").mtime < stat("$file.ipynb").mtime
      @info "updating $f.jl from notebook file"
      convert_doc("$file.ipynb","$file.jl");
      continue
    elseif stat("$file.jl").mtime == stat("$file.ipynb").mtime
      @info "$f.jl and $f.ipynb up to date"
      continue
    end
  end
  @info "updating $f.ipynb from weave file"
  convert_doc("$file.jl","$file.ipynb");
  # have a look
  run(`jupyter nbconvert --to notebook --inplace --execute $file.ipynb`,
      wait = true);
  touch("$file.jl");
  touch("$file.ipynb");
end
run(`jupyter nbconvert
     --output-dir='./src/notebooks'
     --to markdown './notebooks/*.ipynb'`);

bib = CitationBibliography(joinpath(@__DIR__, "bibliography.bib"))

htmlwriter = Documenter.HTML(
              collapselevel = 2,
              prettyurls = get(ENV, "CI", nothing) == "true",
              assets = [asset("assets/logo.ico",class=:ico,islocal=true)]);

pages = ["Home"           => "index.md",
         "NURBS Toolbox"  => "NURBStoolbox.md",
         "API"      => [ "NURBS Toolbox" => "api_NURBStoolbox.md", ],
         "Examples" => [ "NURBS Toolbox" => "notebooks/ex_NURBStoolbox.md", ],
         "References"     => "references.md",
];

# TODO: check why the css themes are not equally applied over the whole site
makedocs(bib,sitename = "MagMechFEM_Matlab2Julia",
         authors = "J. A. Duffek",
         modules=[NURBStoolbox],
         format = htmlwriter,
         doctest = false,
         clean = true,
         pages = pages,
)

println("documentation at: file:///" * joinpath(@__DIR__,"build/index.html"))