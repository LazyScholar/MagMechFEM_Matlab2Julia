# https://github.com/jheinen/GR.jl/issues/278#issuecomment-587090846
ENV["GKSwstype"] = "nul";

# get path of docs folders
cdir = dirname(@__FILE__);
ldir = joinpath(cdir,"literate");
tdir = joinpath(cdir,"src","literate");

# add look up paths
push!(LOAD_PATH, joinpath(cdir, ".."));

using Test;
using Documenter;
using DocumenterCitations;
using Literate;

using MagMechFEM_Matlab2Julia;

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
    Literate.markdown(joinpath(ldir,f),tdir,repo_root_url="../../..");
  end
end

if CIflag
  path_repo = "https://github.com/LazyScholar/MagMechFEM_Matlab2Julia/";
  path_docu = "https://lazyscholar.github.io/MagMechFEM_Matlab2Julia/";
  edit_link = :commit;
  repo = path_repo * "blob/{commit}{path}#{line}";
  pr_num = match(r"refs\/pull\/(\d+)\/merge", get(ENV,"GITHUB_REF",""));
  if pr_num != nothing
    doc_location = path_docu * "previews/PR" * pr_num[1];
  else
    # TODO: later maybe for different branches and versions?
    doc_location = path_docu * "dev";
  end
else
  edit_link = "main";
  repo = "file:///" * joinpath(cdir,"..") * "{path}";
  doc_location = "file:///" * joinpath(cdir,"build/index.html");
end

bib = CitationBibliography(joinpath(cdir, "bibliography.bib"), sorting=:key);

htmlwriter = Documenter.HTML(
              collapselevel = 1,
              prettyurls = CIflag,
              edit_link = edit_link,
              highlights = ["bash", "matlab"],
              assets = [asset("assets/logo.ico",class=:ico,islocal=true)]
              # TODO: add canonical
             );

pages_notes = [
  "Overview"                   => "notes.md",
  "Bernstein Polynomials"      => "literate/nb_bernstein_polynomials.md",
  "B-Splines"                  => "literate/nb_b_splines.md",
  "NURBS 1D"                   => "literate/nb_nurbs_1d.md",
  "NURBS (circular)"           => "literate/nb_circular_nurbs.md",
  "NUBRS 1D Bézier Extraction" => "literate/nb_nurbs_1d_bezier.md",
              ];

pages = ["Home"          => "index.md",
         "Packages"      => [ "NURBS Toolbox" => "NURBStoolbox.md", ],
         "Documentation" => [ "NURBS Toolbox" => "doc_NURBStoolbox.md",
                              "AHBS"          => "doc_AHBS.md", ],
         "Examples"      => [ "NURBS Toolbox" => "literate/ex_NURBStoolbox.md",
                              "Notes"         => pages_notes, ],
         "Guides"        => "guides.md",
         "References"    => "references.md",
        ];

makedocs(bib,
         sitename = "MagMechFEM_Matlab2Julia",
         authors = "J. A. Duffek",
         modules = [MagMechFEM_Matlab2Julia],
         format = htmlwriter,
         doctest = false,
         clean = true,
         pages = pages,
         repo = repo
        );

if CIflag
  deploydocs(
      repo = "github.com/LazyScholar/MagMechFEM_Matlab2Julia.git",
      push_preview = true,
      forcepush = true,
      devbranch = "main",
      branch = "gh-pages"
# TODO: add versions here (after porting) and add tag-bot for version
#       tracking see : Documenter.jl/stable/lib/public/#Documenter.deploydocs
     );
end

printstyled("documentation at: [ $doc_location ]\n"; color = :green)
