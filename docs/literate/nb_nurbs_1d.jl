using Plots;
default(background_color=:transparent, #hide #md
        foreground_color=:grey, #hide #md
        html_output_format=:svg); #hide #md

# # 1D NURBS
#
# These notes are partially based on the NURBS Book from [1997Piegl](@cite).
#
# ## Definition
#
# The definition of NURBS curves $\mathbf{C}\left(\xi\right)$ of the polynomial
# degree $p$ is according to [1997Piegl](@cite)
#
# $$\begin{aligned}
# \mathbf{C}\left(\xi\right)
# &=
# \sum_{i=1}^{n}{\frac{\operatorname{N}_{i,p}\left(\xi\right)\; w_{i}}{
# \sum_{k=1}^{n}{\operatorname{N}_{k,p}\left(\xi\right)\; w_{k}}}\; P_{i}} \\
# \;
# &=
# \sum_{i=1}^{n}{\frac{\operatorname{N}_{i,p}\left(\xi\right)\; w_{i}}{
# \mathbf{w}\left(\xi\right)}\; P_{i}} \\
# \;
# &=
# \sum_{i=1}^{n}{\operatorname{R}_{i,p}\left(\xi\right)\; P_{i}}
# \end{aligned}$$
#
# in which the $\operatorname{N}_{i,p}\left(\xi\right)$ corresponds to the
# $i$-th B-Spline base functions defined as
#
# $$\operatorname{N}_{i,p}\left(\xi\right) =
# \begin{cases}
# \begin{cases}
# 1 & \text{ if } \xi_{i} \leq \xi < \xi_{i+1} \\
# 0 & \text{ else }
# \end{cases} & \text{ if } p=0 \\
# \frac{\xi-\xi_{i}}{\xi_{i+p}-\xi_{i}} \;
# \operatorname{N}_{i,p-1}\left(\xi\right) +
# \frac{\xi_{i+p+1}-\xi}{\xi_{i+p+1}-\xi_{i+1}} \;
# \operatorname{N}_{i+1,p-1}\left(\xi\right) & \text{ if } p > 0
# \end{cases}
# \quad \forall \quad \xi\in\left[\xi_{1},\xi_{n+p+1}\right[_{\mathbb{R}}$$
#
# . So the difference to [B-Splines](nb_b_splines.md) is the rational
# definition and the weights $w_{i}$ which are stored as a column vector for
# each control point $P_{i}$.
#
# $$\mathbf{P}=
# \left[\begin{array}{c}
# P_{1}\cr\vdots\cr P_{i}\cr\vdots\cr P_{n}
# \end{array}\right] =
# \left[\begin{array}{ccc}
# P_{1,x} & P_{1,y} & P_{1,z}\cr
# \vdots & \vdots & \vdots\cr
# P_{i,x} & P_{i,y} & P_{i,z}\cr
# \vdots & \vdots & \vdots\cr
# P_{n,x} & P_{n,y} & P_{n,z}
# \end{array}\right]
# \quad ; \quad
# \mathbf{w}=
# \left[\begin{array}{c}
# w_{1}\cr\vdots\cr w_{i}\cr\vdots\cr w_{n}
# \end{array}\right]$$
#
# The relations between the knot vector
# $\mathbf{\Xi} = \left(\xi_{1},\dots,\xi_{i},\dots,\xi_{n+p+1}\right)$ and the
# $i\in\left[1,n\right]_{\mathbb{Z}}$ the base functions did not change.
#
# Therefore we can calculate the weight function
# $\mathbf{w}\left(\xi\right)=\mathbf{N}\left(\xi\right)\;\mathbf{w}$ either
# with the [B-Spline base functions](nb_b_splines.md#B-Spline-Base-Functions)

function bspline_bf1(p::Integer,Ξ::Vector{typeof(1.0)},ξ::Vector{typeof(1.0)})
n0 = length(Ξ)-1;
N = zeros(typeof(1.0),(length(ξ),n0));
N[(ξ .>= Ξ[1:n0]') .& (ξ .< Ξ[2:n0+1]')] .= 1.0;
N[end , ξ[end] .<= Ξ[2:n0+1]] .= 1.0; # just to have it look nice
for k in 1:p
  for i in 1:n0-k
    temp_1 = (Ξ[i+k] - Ξ[i]);
    temp_2 = (Ξ[i+k+1] - Ξ[i+1]);
    if temp_1 != 0;
      temp_1 = (ξ .- Ξ[i]) ./ temp_1;
    else
      temp_1 = zeros(typeof(1.0),length(ξ));
    end # if
    if temp_2 != 0;
      temp_2 = (Ξ[i+k+1] .- ξ) ./ temp_2;
    else
      temp_2 = zeros(typeof(1.0),length(ξ));
    end # if
    N[:,i] .= temp_1 .* N[:,i] .+ temp_2 .* N[:,i+1];
  end # for i
end # for k
return N[:,1:n0-p];
end # bspline_bf1
nothing #hide

# or the ['de Boor recursion'](nb_b_splines.md#The-'de-Boor-Recursion').
#
# After calculating $\mathbf{w}\left(\xi\right)$ we can define the NURBS base
# functions $\operatorname{R}_{i,p}\left(\xi\right)$
#
# $$\operatorname{R}_{i,p}\left(\xi\right) =
# \frac{\operatorname{N}_{i,p}\left(\xi\right)\; w_{i}}{
# \mathbf{w}\left(\xi\right)}$$
#
# which we store similar to the B-Spline base functions
# $\mathbf{N}\left(\xi\right)$ in a row array $\mathbf{R}\left(\xi\right)$
#
# $$\mathbf{R}\left(\xi\right) = \left[ \begin{array}{ccccc}
# \operatorname{R}_{1,p}\left(\xi\right) & \cdots &
# \operatorname{R}_{i,p}\left(\xi\right) & \cdots &
# \operatorname{R}_{n,p}\left(\xi\right)\end{array} \right]$$
#
# which we can use to calculate the NURBS curve with a matrix multiplication.
#
# $$\mathbf{C}\left(\xi\right) = \mathbf{R}\left(\xi\right)\;\mathbf{P}$$
#
# It is also possible to define homogeneous points $\mathbf{P}_w$
#
# $$\mathbf{P}_w=
# \left[\begin{array}{cc}
# P_{1}\;w_{1} & w_{1}\cr\vdots & \vdots\cr
# P_{i}\;w_{i} & w_{i}\cr\vdots & \vdots\cr
# P_{n}\;w_{n} & w_{n}
# \end{array}\right] =
# \left[\begin{array}{cccc}
# P_{1,x}\;w_{1} & P_{1,y}\;w_{1} & P_{1,z}\;w_{1} & w_{1}\cr
# \vdots & \vdots & \vdots & \vdots \cr
# P_{i,x}\;w_{i} & P_{i,y}\;w_{i} & P_{i,z}\;w_{i} & w_{i}\cr
# \vdots & \vdots & \vdots & \vdots \cr
# P_{n,x}\;w_{n} & P_{n,y}\;w_{n} & P_{n,z}\;w_{n} & w_{n}
# \end{array}\right]$$
#
# calculate the NURBS curve in homogeneous space and transform it back with the
# weight curve $\mathbf{w}\left(\xi\right)$ (which will be calculated alongside
# the homogeneous curve).
#
# $$\mathbf{C}\left(\xi\right) =
# \frac{\mathbf{N}\left(\xi\right)\;\mathbf{P}_{w}}{
# \mathbf{w}\left(\xi\right)}$$
#
# In this case the resulting $\mathbf{C}$ will have a additional column (filled
# with ones) which can be discarded afterwards.
#
# ## Example

p = 2;
Ξ = vec([0.0 0 0 1 1 2 3.5 4 4 4]);
P = [-4 -3 -1 0 1 2 4;
      0  1  8 2 7 1 8;
      0  0  0 0 0 0 0]'/8;
weights = vec([1 1 1 1 1 1/4 1]);
ξ = collect(range(Ξ[1],Ξ[end],length=61));

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

N = bspline_bf1(p,Ξ,ξ);
w = N * weights;
R = (N .* weights') ./ w;
C_bsp = N * P;
C = R * P;

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

pltN = plot(ξ,N,
            color = (1:size(N,2))',
            label = ["\$\\operatorname{N}_{$x,$p}" *
                    "\\left(\\xi\\right)\$" for x in (1:size(N,2))'],
            border = :box,
            widen = false,
            linewidth = 2,
            legend = :outerright,
            xticks = unique(Ξ),
            xlabel = "\$\\xi\$",
            ylabel = "\$\\operatorname{N}_{i,p}\\left(\\xi\\right)\$");
pltR = plot(ξ,R,
            color = (1:size(R,2))',
            label = ["\$\\operatorname{R}_{$x,$p}" *
                    "\\left(\\xi\\right)\$" for x in (1:size(R,2))'],
            border = :box,
            widen = false,
            linewidth = 2,
            legend = :outerright,
            xticks = unique(Ξ),
            xlabel = "\$\\xi\$",
            ylabel = "\$\\operatorname{R}_{i,p}\\left(\\xi\\right)\$");
pltC = plot(P[:,1],P[:,2],
            border = :box,
            legend = :outerright,
            xlabel = "\$x\$",
            ylabel = "\$y\$",
            linewidth = 2,
            label = "\$\\operatorname{P}_{i}\$",
            color = 1:size(P,1),
            line = (:dot, 1, :grey),
            marker = (:circle , 5.0, 0.8),
            markerstrokewidth = 0)
plot!(C_bsp[:,1],C_bsp[:,2],
      label = "\$\\mathbf{C}_{bsp}\\left(\\xi\\right)\$",
      color = 2);
plot!(C[:,1],C[:,2],
      label = "\$\\mathbf{C}\\left(\\xi\\right)\$",
      linewidth = 2,
      color = 1);
plot(pltN,pltR,pltC,layout = (3, 1),size = (600, 800))
