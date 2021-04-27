using Revise; #nb
push!(LOAD_PATH, "../../src/IGA/aHBS/"); #nb
using MagMechFEM_Matlab2Julia.AHBS; #md
using AHBS; #nb
using Plots;
default(border = :box,
        background_color=:transparent, #hide #md
        foreground_color=:grey, #hide #md
        html_output_format=:svg, #hide #md
        linewidth = 2,
        legend = :outerright,
        widen = false);

# # 1D NURBS by Bézier extraction
#
# These notes are partially based on the NURBS Book from [1997Piegl](@cite) and
# the article of [2010Borden](@cite).

p = 2;
Ξ = vec([0.0 0 0 1 1 2 3.5 4 4 4]);
P = [-4 -3 -1 0 1 2 4;
      0  1  8 2 7 1 8;
      0  0  0 0 0 0 0]'/8;
weights = vec([1 1 1 1 1 1/4 1]);
ξ = collect(range(Ξ[1],Ξ[end],length=61));

# ## B-Splines by Bézier extraction
#
# A Bézier Spline is a special case of a B-Spline (only start and end knots
# with multiplicity of $p+1$).
# Therefore the $p+1$ Bézier/Bernstein Base functions
#
# $$\operatorname{B}_{i,p}\left(\overline{\xi}\right) =
# \frac{p!}{i!\; \left(p-i\right)!}\; \frac{1}{2^{p}}\;
# \left(\overline{\xi}+1\right)^{i}\; \left(1-\overline{\xi}\right)^{p-i}
# \quad \forall \quad \overline{\xi}\in\left[-1,1\right]_{\mathbb{R}} \; ; \;
# i\in\left[0,p\right]_{\mathbb{Z}}$$
#
# can be used to define the
# [B-Spline base functions](nb_b_splines.md#B-Spline-Base-Functions).

n = 11;
ξ_B = collect(range(-1,1,length=n));
B = bernstein_base1D(p,ξ_B);
plot(ξ_B,B,
     label = ["\$\\operatorname{B}_{$x,$p}" *
              "\\left(\\overline{\\xi}\\right)\$" for x in (0:p)'],
     color = (1:p+1)',
     xlabel = "\$\\overline{\\xi}\$",
     ylabel = "\$\\operatorname{B}_{i,p}\\left(\\overline{\\xi}\\right)\$")

# For other cases with arbitrary knot tuples $\mathbf{\Xi}$ it is also possible
# to use [Bézier Polynomials](nb_bernstein_polynomials.md) as the base of
# calculation.
#
# The basic idea is that by increasing the multiplicity of each knot $\xi_{i}$
# to at least $p$ (by knot insertion) the B-Spline base functions will be
# bézier base functions for each space betewwn unique knots.
#
# > To faciliate the further explanation I will call the initial base
# > $\mathbf{N}^{\mathrm{C}}\left(\xi\right)$ with the arbitrary knot tuple
# > $\mathbf{\Xi}^{\mathrm{C}}$ the coarse B-Spline base with coarse base
# > functions $\operatorname{N}^{\mathrm{C}}_{i,p}\left(\xi\right)$. And the
# > one with the increased multiplicity bézier or bernstein base with the
# > superscript $\mathrm{B}$.
#
# And the basic rule used here is that each coarser base
# $\mathbf{N}^{\mathrm{C}}\left(\xi\right)$ is a linear combination of its
# finer base $\mathbf{N}^{\mathrm{B}}\left(\xi\right)$ is. So one could write
#
# $$\mathbf{N}^{\mathrm{C}}\left(\xi\right) =
# \mathbf{M}^{\mathrm{C},\mathrm{B}} \; \mathbf{N}^{\mathrm{B}}\left(
# \xi\right)$$
#
# where $\mathbf{M}^{\mathrm{C},\mathrm{B}}$ is a subdivision matrix which can
# be computed by several methods (see knot insertion or subdivision of
# B-Splines) like the oslo algorithm ([1980Cohen](@cite)).

Ξ_B = [Ξ[1]; repeat(unique(Ξ),inner=p); Ξ[end]];
println(Ξ  );
println(Ξ_B);
M_B = oslo1_global(p,Ξ,Ξ_B)

# So we can calculate the $p+1$ base functions between two unique knots by
# using a linear combination of bernstein polynomials of the degree $p$.
#
# I will name those spaces beween those unique knots 'elements'. And define a
# helper function $\operatorname{k}\left(e\right) \rightarrow i$ which gives me
# the smallest index of the base functions
# $\operatorname{N}_{i,p}\left(\xi\right)$ which are not zero on this
# space/element $e$.

bezier_ij = get_bezier_extraction_ij(p,Ξ)

# A second helper function $\operatorname{f}^{e}\left(\xi\right) = 2\;\frac{
# \xi-\xi_{\operatorname{k}^{\mathrm{C}}\left(e\right)+p}}{\xi_{
# \operatorname{k}^{\mathrm{C}}\left(e\right)+p+1 }-
# \xi_{\operatorname{k}^{\mathrm{C}}\left(e\right)+p}} - 1$ serves the purpose
# to map the definition area of the element
# $\xi\in\left[\xi_{\operatorname{k}^{\mathrm{C}}\left(e\right)+p }\;,\;
# \xi_{ \operatorname{k}^{\mathrm{C}}\left(e\right)+p+1 }\right]_{\mathbb{R}}
# =\Omega_{e}$ to the definition area of the bernstein polynomials
# $\overline{\xi}\in\left[ -1, 1\right]_{\mathbb{R}}$.
#
# With this we can write the calculation rule for the $p+1$ base functions
# $\operatorname{N}^{\mathrm{C}}_{i,p}\left(\xi\right)$ on each element/section
# $e$ of a B-Spline as
#
# $$\operatorname{N}^{\mathrm{C}}_{\operatorname{k}^{\mathrm{C}}\left(e\right)
# +i,p}\left(\xi\right) = \sum_{j=0}^{p}{ M^{\mathrm{C},\mathrm{B}}_{
# \operatorname{k}^{\mathrm{C}}\left(e\right)+i\;,\;\operatorname{k}^{
# \mathrm{B}}\left(e\right)+j} \; \operatorname{B}_{j,p}\left(
# \operatorname{f}^{\mathrm{C},e}\left(\xi\right) \right) }
# \quad \forall \quad \xi\in\left[\xi_{ \operatorname{k}^{\mathrm{C}}
# \left(e\right)+p }\; ,\; \xi_{ \operatorname{k}^{\mathrm{C}}\left(e\right)
# +p+1 }\right]_{\mathbb{R}}
# \; ; \; i\in\left[0,p\right]_{\mathbb{Z}}$$
#
# where the values $M^{\mathrm{C},\mathrm{B}}_{\operatorname{k}^{\mathrm{C}}
# \left(e\right)+i\;,\;\operatorname{k}^{\mathrm{B}}\left(e\right)+j}$ for
# $i,j\in\left[0,p\right]_{\mathbb{Z}}$ can be summarized into a sub matrix
# $\mathbf{M}^{\mathrm{C},\mathrm{B},e}$ of
# $\mathbf{M}^{\mathrm{C},\mathrm{B}}$. This matrix
# $\mathbf{M}^{\mathrm{C},\mathrm{B},e}$ is also called bézier extraction
# operator.
# By furthermore defining a localized subarray
#
# $$\mathbf{N}^{\mathrm{C},e}\left(\xi\right) = \left[ \begin{array}{ccccc}
# \operatorname{N}^{\mathrm{C}}_{\operatorname{k}^{\mathrm{C}}\left(e\right)+0,
# p}\left(\xi\right) & \cdots &
# \operatorname{N}^{\mathrm{C}}_{\operatorname{k}^{\mathrm{C}}\left(e\right)+i,
# p}\left(\xi\right) & \cdots &
# \operatorname{N}^{\mathrm{C}}_{\operatorname{k}^{\mathrm{C}}\left(e\right)+p,
# p}\left(\xi\right)\end{array} \right]
# \quad \forall \quad \xi\in\Omega_{e}$$
#
# and an array of bernstein polynomials
#
# $$\mathbf{B}\left(\overline{\xi}\right) = \left[ \begin{array}{ccccc}
# \operatorname{B}_{0,p}\left(\overline{\xi}\right) & \cdots &
# \operatorname{B}_{i,p}\left(\overline{\xi}\right) & \cdots &
# \operatorname{B}_{p,p}\left(\overline{\xi}\right) \end{array} \right]
# \quad \forall \quad \overline{\xi}\in\left[-1,1\right]_{\mathbb{R}}$$
#
#
# we can rewrite the bloated definition.
#
# $$\mathbf{N}^{\mathrm{C},e}\left(\xi\right) =
# \mathbf{B}\left(\operatorname{f}^{\mathrm{C},e}\left(\xi\right)\right) \;
# \left(\mathbf{M}^{\mathrm{C},\mathrm{B},e}\right)^\intercal
# \quad \forall \quad \xi\in\Omega_{e}$$
#
# These local base functions can then used to calculate the B-Spline on the
# local parameter space $\Omega_{e}$
#
# $$\mathbf{C}^{e}\left(\xi\right) =
# \mathbf{N}^{\mathrm{C},e}\left(\xi\right) \; \mathbf{P}^{e}
# \quad \forall \quad \xi\in\Omega_{e}$$
#
# where $\mathbf{P}^{e}$ is the subset of points corresponding to the base
# functions (from $P_{\operatorname{k}^{\mathrm{C}}\left(e\right)+0,p}$ till
# $P_{\operatorname{k}^{\mathrm{C}}\left(e\right)+p,p}$).

pltB = plot(xticks = unique(Ξ_B),
            xlabel = "\$\\xi\$",
            ylabel = "\$\\operatorname{N}^{\\mathrm{B},e}_{i,p}" *
                     "\\left(\\xi\\right)\$");
pltN = plot(xticks = unique(Ξ),
            xlabel = "\$\\xi\$",
            ylabel = "\$\\operatorname{N}^{\\mathrm{C},e}_{i,p}" *
                     "\\left(\\xi\\right)\$");
pltC = plot(P[:,1],P[:,2],
            xlabel = "\$x\$",
            ylabel = "\$y\$",
            linewidth = 2,
            label = "\$\\operatorname{P}_{i}\$",
            color = :green,
            line = (:dot, 2),
            marker = (:circle , 5.0, 0.8),
            markerstrokewidth = 0);
for e in 1:size(bezier_ij,1)
    ξ_e = collect(range(Ξ[bezier_ij[e,1]+p],Ξ[bezier_ij[e,1]+p+1],length=n));
    P_e = P[ bezier_ij[e,1].+(0:p) , : ];
    BEO = M_B[ bezier_ij[e,1].+(0:p) , bezier_ij[e,2].+(0:p) ];
    N_e = B * BEO';
    C_e = N_e * P_e;

    plot!(pltB,ξ_e,B,color = e,
          label = ["\$\\mathbf{N}^{\\mathrm{B},$e}" *
                   "\\left(\\xi\\right)\$" "" ""]);
    plot!(pltN,ξ_e,N_e,color = e,
          label = ["\$\\mathbf{N}^{\\mathrm{C},$e}" *
                   "\\left(\\xi\\right)\$" "" ""]);
    plot!(pltC,C_e[:,1],C_e[:,2],color = e,
          label = "\$\\mathbf{C}^{$e}\\left(\\xi\\right)\$");
end # for e

plot(pltB,pltN,pltC,
     layout = (3, 1),
     size = (600, 800))

# ## NURBS by Bézier extraction
#
# To calculate [NURBS base functions or curves](nb_nurbs_1d.md) it is only
# necessary to consider the weights and apply them onto the localized B-Spline
# base functions.

pltB = plot(xticks = unique(Ξ_B),
            xlabel = "\$\\xi\$",
            ylabel = "\$\\operatorname{N}^{\\mathrm{B},e}_{i,p}" *
                     "\\left(\\xi\\right)\$");
pltN = plot(xticks = unique(Ξ),
            xlabel = "\$\\xi\$",
            ylabel = "\$\\operatorname{R}^{\\mathrm{C},e}_{i,p}" *
                     "\\left(\\xi\\right)\$");
pltC = plot(P[:,1],P[:,2],
            xlabel = "\$x\$",
            ylabel = "\$y\$",
            linewidth = 2,
            label = "\$\\operatorname{P}_{i}\$",
            color = :green,
            line = (:dot, 2),
            marker = (:circle , 5.0, 0.8),
            markerstrokewidth = 0);
for e in 1:size(bezier_ij,1)
    ξ_e = collect(range(Ξ[bezier_ij[e,1]+p],Ξ[bezier_ij[e,1]+p+1],length=n));
    P_e = P[ bezier_ij[e,1].+(0:p) , : ];
    weights_e = weights[ bezier_ij[e,1].+(0:p) ];
    BEO = M_B[ bezier_ij[e,1].+(0:p) , bezier_ij[e,2].+(0:p) ];
    R_e = B * BEO' .* weights_e';
    R_e ./= sum(R_e,dims=2);
    C_e = R_e * P_e;

    plot!(pltB,ξ_e,B,color = e,
          label = ["\$\\mathbf{N}^{\\mathrm{B},$e}" *
                   "\\left(\\xi\\right)\$" "" ""]);
    plot!(pltN,ξ_e,R_e,color = e,
          label = ["\$\\mathbf{R}^{\\mathrm{C},$e}" *
                   "\\left(\\xi\\right)\$" "" ""]);
    plot!(pltC,C_e[:,1],C_e[:,2],color = e,
          label = "\$\\mathbf{C}^{$e}\\left(\\xi\\right)\$");
end # for e

plot(pltB,pltN,pltC,
     layout = (3, 1),
     size = (600, 800))
