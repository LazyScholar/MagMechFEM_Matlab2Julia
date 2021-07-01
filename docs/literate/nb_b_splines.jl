using Plots;
default(background_color=:transparent, #hide #md
        foreground_color=:grey, #hide #md
        html_output_format=:svg); #hide #md

# # B-Splines
#
# These notes are partially based on the NURBS Book from [1997Piegl](@cite).
#
# ## B-Spline Base Functions
#
# B-Spline Base Functions $\operatorname{N}_{i,p}\left(\xi\right)$ recursively
# definead as
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
# according to [1997Piegl](@cite) (definition 2.5 on page 50) (the fractions
# are defined to be zero if the divisor is zeros). The knots $\xi_{i}$ in this
# formula are defined inside the knot  vector
# $\mathbf{\Xi} = \left(\xi_{1},\dots,\xi_{i},\dots,\xi_{n+p+1}\right)$
# (with $\xi_{i}\geq\xi_{i-1}$ and therefore also named knot tuple
# $\mathbf{\Xi}$). The recursive function, the knots of
# $\mathbf{\Xi}$ in combination with the polynomial degree $p$ are sufficient
# to construct the $i\in\left[1,n\right]_{\mathbb{Z}}$ base functions
# $\operatorname{N}_{i,p}\left(\xi\right)$.

p = 2;
Ξ = vec([0 1 2 3.5 4 5 5 6]);
ξ = collect(range(Ξ[1],Ξ[end],length=61));

#------------------------------------------------------------------------------

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

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

N = bspline_bf1(p,Ξ,ξ);
plot(ξ,N,
     label = ["\$\\operatorname{N}_{$x,$p}" *
              "\\left(\\xi\\right)\$" for x in (1:length(Ξ)-1-p)'],
     color = (1:length(Ξ)-1-p)',
     border = :box,
     linewidth = 2,
     legend = :outerright,
     xlabel = "\$\\xi\$",
     ylabel = "\$\\operatorname{N}_{i,p}\\left(\\xi\\right)\$",
     widen = false);

# The occurrence and spacing of the knots $\xi$ in the tuple $\mathbf{\Xi}$.
# Characterize the final form of the Base Functions
# $\operatorname{N}_{i,p}\left(\xi\right)$. And can therefore used to omit the
# branching in the formula similar to the
# [Bernstein Polynomials](nb_bernstein_polynomials.md) (the divisors
# are sometimes zero). Which could be used to vectorize the recursive
# calculation (only useful for huge problems).

function bspline_bf2(p::Integer,Ξ::Vector{typeof(1.0)},ξ::Vector{typeof(1.0)})
n0 = length(Ξ)-1;
N = zeros(typeof(1.0),(length(ξ),n0));
N[(ξ .>= Ξ[1:n0]') .& (ξ .< Ξ[2:n0+1]')] .= 1.0;
N[end , ξ[end] .<= Ξ[2:n0+1]] .= 1.0;  # just to have it look nice
temp_1 = BitVector(fill(false,n0+1));
temp_2 = BitVector([Ξ[1:n0] .!= Ξ[2:n0+1];false]);
for k in 1:p
  n = n0-k;
  temp_1[1:n0] .= temp_2[1:n0];
  temp_1[n+1] = false;
  temp_2[1] = false;
  temp_N = (Ξ[temp_2 >> k]' .- ξ) ./ (Ξ[temp_2 >> k] .- Ξ[temp_2])' .*
           N[:,temp_2[1:n0]];
  N[:,temp_1[1:n0]] .*= (ξ .- Ξ[temp_1]') ./ (Ξ[temp_1 >> k] .- Ξ[temp_1])';
  N[:,temp_2[1:n0] << 1] .+= temp_N;
  temp_2 .|= (temp_2 << 1);
  temp_2[n+1] = false;
end # for k
return N[:,1:n0-p];
end # bspline_bf2
nothing #hide

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

plot!(ξ,bspline_bf2(p,Ξ,ξ),
      label = ["\$\\operatorname{N}_{$x,$p}" *
               "\\left(\\xi\\right)\$" for x in (1:length(Ξ)-1-p)'],
      color = (1:length(Ξ)-1-p)',
      line = (:dot, 2),
      marker = (:circle , 5.0, 0.8),
      markerstrokewidth = 0)

# For further details and properties on B-Splines see the NURBS Book from
# [1997Piegl](@cite).
#
# > The further notes are only done with open (synonymous for non-periodic or
# > clamped) B-Splines which are characterized by $p+1$ equal knot entries at
# > the start and end of their  knot tuple $\mathbf{\Xi}$.
#
# ## B-Splines
#
# B-Splines are characterized via knot vector $\mathbf{\Xi}$, polynomial or
# spline degree $p$ and their control points $\mathbf{P}$. Those control points
# $P_{i}$ of the same arbitrary dimension (e.g.
# $P_{i} = \left(P_{i,x},P_{i,y}\right)$ for 2 dimensional curves or
# $P_{i} = \left(P_{i,x},P_{i,y},P_{i,y}\right)$ for 3 dimensional ones). For
# the ease of use they can be stored in point matrices/vectors e.g.
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
# \end{array}\right]$$
#
# which length $n$ has to match with the number of base functions which in turn
# gets defined by the length of the knot vector $n+p+1$.

p = 2;
Ξ = vec([0 0 0 1 1 2 3.5 4 4 4]);
ξ = collect(range(Ξ[1],Ξ[end],length=61));
P = [-4 -3 -1 0 1 2 4;
      0  1  8 2 7 1 8;
      0  0  0 0 0 0 0]'.*1.0;

# And the base functions $\operatorname{N}_{i,p}\left(\xi\right)$ are
# structured in a horizontal array
#
# $$\mathbf{N}\left(\xi\right) = \left[ \begin{array}{ccccc}
# \operatorname{N}_{1,p}\left(\xi\right) & \cdots &
# \operatorname{N}_{i,p}\left(\xi\right) & \cdots &
# \operatorname{N}_{n,p}\left(\xi\right)\end{array} \right]$$
#
# where each $\operatorname{N}_{i,p}\left(\xi\right)$ could be seen as a
# vertical vector after evaluation.

N = bspline_bf2(p,Ξ,ξ);

# This makes it convenient to write the definition of the B-Splines
#
# $$\mathbf{C}\left(\xi\right) =
# \sum_{i=1}^{n}{\operatorname{N}_{i,p}\left(\xi\right)\;P_{i}}$$
#
# as einstein sum convention
#
# $$\mathbf{C}\left(\xi\right) =
# \operatorname{N}_{i,p}\left(\xi\right)\;P_{i}$$
#
# or simply as matrix multiplication
#
# $$\mathbf{C} = \mathbf{N}\;\mathbf{P}$$
#
# (the arguments $\xi$ are omitted for a leaner definition).

C = N * P;

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

plot(ξ,N,
     label = ["\$\\operatorname{N}_{$x,$p}" *
              "\\left(\\xi\\right)\$" for x in (1:length(Ξ)-1-p)'],
     color = (1:length(Ξ)-1-p)',
     border = :box,
     linewidth = 2,
     legend = :outerright,
     xlabel = "\$\\xi\$",
     ylabel = "\$\\operatorname{N}_{i,p}\\left(\\xi\\right)\$",
     widen = false)

plot(C[:,1],C[:,2],
     label = "\$\\mathbf{C}\\left(\\xi\\right)\$",
     border = :box,
     linewidth = 2,
     legend = :outerright,
     xlabel = "\$x\$",
     ylabel = "\$y\$",
     aspect_ratio = :equal);
plot!(P[:,1],P[:,2],
      label = "\$\\operatorname{P}_{i}\$",
      color = :green,
      line = (:dot, 2),
      marker = (:circle , 5.0, 0.8),
      markerstrokewidth = 0)

# ## The 'de Boor Recursion'
#
# Carl de Boor postulated 1970 a algorithm to calculate the B-Splines directly
# without calculating the base functions (see [1972Boor](@cite)). This quite
# efficient algorithm uses the characteristics of the recursive formula (the
# base functions are on certain areas zero and the divisors too). And avoids
# useless calculation. The resulting calculation is quite similar to the
# construction of the bernstein/bézier splines.
#
# For completeness here the derivation.
#
# $$\mathbf{C}\left(\xi\right) =
# \sum_{i=1}^{n}{\operatorname{N}_{i,p}\left(\xi\right)\;P_{i}}$$
#
# Each paramteric value $\xi$ of the curve lies between two neighboring knots
# $\xi_{k}\leq\xi < \xi_{k+1}$. And on this range are only $p+1$ base functions
# non zero.
#
# $$\xi_{k} \leq \xi < \xi_{k+1} \Rightarrow
# \text{ support : }\left\{ \operatorname{N}_{k-p,p}\left(\xi\right), \dots ,
# \operatorname{N}_{k,p}\left(\xi\right) \right\} \text{ other }
# \operatorname{N}_{i,p}\left(\xi\right) \text{ zero}$$
#
# Therefore one can define a point on the spline for one specific $\xi$ as
#
# $$\begin{aligned}
# \mathbf{C}\left(\xi\right)
# &=
# \sum_{i=k-p}^{k}{\left[ \frac{\xi - \xi_{i}}{\xi_{i+p} - \xi_{i}}\;
# \operatorname{N}_{i,p-1}\left(\xi\right)\; P_{i} \right]}  +
# \sum_{i=k-p}^{k}{\left[ \frac{\xi_{i+p+1} - \xi}{\xi_{i+p+1} - \xi_{i+1}}\;
# \operatorname{N}_{i+1,p-1}\left(\xi\right) \; P_{i} \right]}\\
# \;
# &=
# \sum_{i=k-p}^{k}{\left[ \frac{\xi - \xi_{i}}{\xi_{i+p} - \xi_{i}}\;
# \operatorname{N}_{i,p-1}\left(\xi\right) \; P_{i} \right]}  +
# \sum_{i=k-p+1}^{k+1}{\left[ \frac{\xi_{i+p} - \xi}{\xi_{i+p} - \xi_{i}}\;
# \operatorname{N}_{i,p-1}\left(\xi\right)\;  P_{i-1} \right]}
# \end{aligned}$$
#
# and with the knowledge that
#
# $$\xi_{k}  \leq \xi < \xi_{k+1} \Rightarrow
# \text{ support : } \left\{ \operatorname{N}_{k-p+1,p-1}\left(\xi\right),
# \dots, \operatorname{N}_{k,p-1}\left(\xi\right) \right\} \text{ other }
# \operatorname{N}_{i,p-1}\left(\xi\right) \text{ zero}$$
#
# we can combine the sums into one sum.
#
# $$\mathbf{C}\left(\xi\right) =
# \sum_{i=k-p+1}^{k}{\left[ \left( \frac{\xi - \xi_{i}}{\xi_{i+p} - \xi_{i}}\;
# P_{i} + \frac{\xi_{i+p} - \xi}{\xi_{i+p} - \xi_{i}}\; P_{i-1} \right)\;
# \operatorname{N}_{i,p-1}\left(\xi\right) \right] }$$
#
# Those considerations can be redone recursively to the lowest level and with
# the start condition
# $\operatorname{N}_{i,0}\left(\xi\right)=1 \; \forall \;
# \xi_{k}  \leq \xi < \xi_{k+1}$ follows
#
# $$\mathbf{C}^{j}_{i}\left(\xi\right) =
# \begin{cases}
# P_{i} & \text{ for } j = 0 \\
# \left(1-\alpha^{j}_{i}\left(\xi\right)\right)\;
# \mathbf{C}^{j-1}_{i-1}\left(\xi\right) +
# \alpha^{j}_{i}\left(\xi\right)\; \mathbf{C}^{j-1}_{i}\left(\xi\right) &
# \text{ for } j > 0
# \end{cases} \quad ; \quad \alpha^{j}_{i}\left(\xi\right) =
# \frac{\xi - \xi_{i}}{\xi_{i+p-j+1} - \xi_{i}}$$
#
# which is the recursive definition of the B-Spline for one specific $\xi$.

function bspline_deBoor(p::Integer,Ξ::Vector{typeof(1.0)},
                        ξ::Vector{typeof(1.0)},P::Matrix{typeof(1.0)})
knot_span = (Ξ[1:end-1]' .<= ξ) .& (ξ .< Ξ[2:end]');
temp = vec(.~any(knot_span, dims=2));
if any(temp)
  knot_span[temp,:] .= (ξ[temp] .== Ξ[2:end]') .& (ξ[temp] .> Ξ[1:end-1]');
end # if
knot_span = findfirst.(eachrow(knot_span));
temp_P = zeros(eltype(P),(length(ξ),size(P,2),p+1));
for k in 0:p
  temp_P[:,:,k+1] = P[knot_span .- k,:];
end # for k
α = zeros(eltype(ξ),length(ξ));
idx = zeros(typeof(1),length(ξ));
for j in 1:p
  for i in 1:p-j+1
    idx .= knot_span .+ (1-i);
    α .= (ξ .- Ξ[idx]) ./ (Ξ[idx .+ (p-j+1)] .- Ξ[idx]);
    temp_P[:,:,i] = temp_P[:,:,i+1] .* (1 .- α) .+ temp_P[:,:,i  ] .* α;
  end # for i
end # for j
return temp_P[:,:,1];
end # bspline_deBoor
nothing #hide

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C = bspline_deBoor(p,Ξ,ξ,P);

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

plot(C[:,1],C[:,2],
     label = "\$\\mathbf{C}\\left(\\xi\\right)\$",
     border = :box,
     linewidth = 2,
     legend = :outerright,
     xlabel = "\$x\$",
     ylabel = "\$y\$",
     aspect_ratio = :equal);
plot!(P[:,1],P[:,2],
      label = "\$\\operatorname{P}_{i}\$",
      color = :green,
      line = (:dot, 2),
      marker = (:circle , 5.0, 0.8),
      markerstrokewidth = 0)

# The following code and the animation show the relationship between the
# bézier and the B-Splines. And shows how the de Boor algorithm works.

N = bspline_bf2(p,Ξ,ξ); #hide #md
Plots.gr(); #hide #md
Plots.reset_defaults();
animation = @animate for s in 1:length(ξ)
plt1 = plot(ξ,N,
            color = (1:size(P,1))',
            linewidth = 1,
            legend = :none,
            border = :none,
            widen = false);
plot!([ξ[s];ξ[s]],[0.0,1.0],color = :red);

plt2 = plot(C[1:s,1],C[1:s,2],
            border = :none,
            line = (:dot, 2),
            color = :grey,
            legend = :none,
            aspect_ratio = :equal);
scatter!(P[:,1],P[:,2],
         color = 1:size(P,1),
         markerstrokewidth = 0);

if ξ[s] != Ξ[end]
  k = findfirst((Ξ[1:end-1] .<= ξ[s]) .& (ξ[s] .< Ξ[2:end]));
else
  k = length(Ξ)-p-1;
end
temp_P = reverse(P[k-p:k,:],dims=1);
plot!(temp_P[:,1],temp_P[:,2]);
for j in 1:p
  for i in 1:p-j+1
    idx = k + (1-i);
    α = (ξ[s] - Ξ[idx]) / (Ξ[idx + (p-j+1)] - Ξ[idx]);
    temp_P[i,:] .= temp_P[i+1,:] .* (1 - α) .+ temp_P[i,:] .* α;
  end # for i
  temp_P = temp_P[1:end-1,:];
  plot!(temp_P[:,1],temp_P[:,2],marker = :circle);
end # for j
plot(plt1,plt2,layout = grid(2, 1, heights=[0.2 ,0.8]),size = (600, 700))
end
gif(animation, "animation_deBoor.gif", fps = 10)

#------------------------------------------------------------------------------

Plots.pyplot(); #hide #md
