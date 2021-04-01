this is custom "do" or "do not do" list for jupyther notebooks in order to have everything work with Documenter.jl

- leave a empty line after and before latex $$ ... $$ blocks
- do not use the bracket \{ as it will mess with the conversion
- for latex cases use \begin{cases} & \\ \end{cases} instead \left\{ \matrix{ \cr } \right.
- use [^nameorindex] for citation and define the citation somewhere as "[^nameorindex]: text" on its own line (without the "")
- use \operatorname{name} instead \DeclareMathOperator{}{}
- try to use "background_color=:transparent, foreground_color=:grey" for plots and use colors which work in bright and dark mode equally well
