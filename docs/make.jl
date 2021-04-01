# assure that the operations are run from /docs/
cd(dirname(@__FILE__))

#push!(LOAD_PATH,"../src")

# convert the notebooks to markdown in order to allow the use of them in the documentation
run(`jupyter nbconvert --output-dir='./src/notebooks' --to markdown './notebooks/*.ipynb'`);

#using SRC_PACKAGE
using Test, Documenter

# use this if you will host it localy with a web server

# use this if you want to browse it only with the browser
makedocs(
    sitename = "MagMechFEM_Matlab2Julia",
    doctest = false,
    format = Documenter.HTML(prettyurls=false),
    clean = true,
    pages = [
        "Home"           => "index.md"
        ]
)

println("documentation at: file:///" * joinpath(@__DIR__,"build/index.html"))

# use this if you will use github to host the documentation
#makedocs(
#    sitename="MagMechFEMjulia",
#    format=Documenter.HTML(
#    prettyurls=get(ENV,"CI",nothung)=="true"
#    )
#)
