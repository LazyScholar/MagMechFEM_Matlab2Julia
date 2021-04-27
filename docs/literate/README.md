This is a file providing advice on the `Literate.jl` files.

The literate files can easily converted to Jupyter notebooks or `Documenter.jl` markdown files.
First tests with `Weave.jl` and `Documenter.jl` where not very satisfying as the workflow on GitHub Actions is more fit for `Literate.jl`.

- use `[^nameorindex]` for citation and define the citation somewhere as `[^nameorindex]: text` on its own line
- use `\begin{array} & \\ \end{array}` or `\begin{matrix} \end{matrix}` instead of `\matrix{ }`
- leave a empty line after and before latex `$$ ... $$` blocks
- use `\operatorname{name}` instead of `\DeclareMathOperator{}{}` for LaTeX function names
- if you want to use the `Documenter.jl` BibTex features add your source to the `bibliography.bib` and cite it like `[bibtexkey](@cite)` it will be replaced with `Authors (year)`
- to reference functions of the API use ``[`functionname`](@ref)`` and `Documenter.jl` will set a link
- try to use `background_color=:transparent, foreground_color=:grey` for plots and use colours which work in bright and dark mode equally well (until i figured out to hook the css scheme to svg's)
- in order to convert one of the literate scripts to Jupyter notebook use `Literate.jl` e.g. `Literate.notebook("docs/literate/ex_NURBStoolbox.jl",joinpath(pwd(),"docs/notebooks/"))`
- Note: do not upload notebooks into git the file format is not very version control friendly, convert them into the literate format instead (those files can also be added into the documentation)
- Note: in order to convert Jupyter notebooks into the literate format use `Weave.jl` and remove the backticks after the hashes


Those are the old advices for Jupyter notebooks with the `Weave.jl` workflow.

In order to create the notebooks or the weave files run the documentation script in the `/docs` directory (e.g. `julia --color=yes /docs/make.jl`).
This will take care of the conversion and updating between those formats.
Keep in mind that the `.ipynb` files will not be uploaded into the source control.

- do not use the bracket `\{` as it will mess with the conversion to html
- for latex cases use `\begin{cases} & \\ \end{cases}` instead of `\left\{ \matrix{ \cr } \right.`
