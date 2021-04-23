This is a file providing advice on the `Literate.jl` files.

The literate files can easily converted to Jupyter notebooks or `Documenter.jl` markdown files.
First test with `Weave.jl` and `Documenter.jl` where not very satisfying as the workflow on Github Actions is more fit for `Literate.jl`.

- use `[^nameorindex]` for citation and define the citation somewhere as `[^nameorindex]: text` on its own line
- if you want to use the `Documenter.jl` BibTex features add your source to the bibliography.bib and cite it like `[bibtexkey](@cite)` it will be replaced with `Authors (year)`
- to reference functions of the API use ``[`functionname`](@ref)`` and `Documenter.jl` will set a link
- try to use `background_color=:transparent, foreground_color=:grey` for plots and use colours which work in bright and dark mode equally well (until i figured out to hook a css scheme to svg's)


Those are the old advices for Jupyter notebooks with the `Weave.jl` workflow.

In order to create the notebooks or the weave files run the documentation script in the `/docs` directory (e.g. `julia --color=yes /docs/make.jl`).
This will take care of the conversion and updating between those formats.
Keep in mind that the `.ipynb` files will not be uploaded into the source control.

- leave a empty line after and before latex `$$ ... $$` blocks
- do not use the bracket `\{` as it will mess with the conversion to html
- for latex cases use `\begin{cases} & \\ \end{cases}` instead of `\left\{ \matrix{ \cr } \right.`
- use `\operatorname{name}` instead of `\DeclareMathOperator{}{}` for LaTeX function names
