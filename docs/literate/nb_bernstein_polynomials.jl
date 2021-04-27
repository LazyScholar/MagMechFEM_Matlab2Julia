using Plots;
Plots.reset_defaults(); #hide #md
default(background_color=:transparent, #hide #md
        foreground_color=:grey, #hide #md
        html_output_format=:svg); #hide #md

# # Bernstein Polynomials
#
#  These notes are partially based on the NURBS Book from [1997Piegl](@cite).

p = 4;
xi = range(0,1,length=40);
ξ = range(-1,1,length=length(xi));

# ## Bernstein Polynomials [0,1]
#
# According to [1997Piegl](@cite) the $i\in\left[0,p\right]_{\mathbb{Z}}$
# Bernstein Polynomials
#
# $$\operatorname{B}_{i,p}\left(\xi\right) =
# \frac{p!}{i!\; \left(p-i\right)!}\; \xi^{i}\; \left(1-\xi\right)^{p-i}
# \quad \forall \quad \xi\in\left[0,1\right]_{\mathbb{R}}$$
#
# of the polynomial degree $p$

B = transpose(factorial(p)./(factorial.(0:p).*factorial.(p .- (0:p))));
B = xi.^(transpose(0:p)).*(1 .- xi).^(p .- transpose(0:p)) .* B;
plot(xi,B,
     label = ["\$\\operatorname{B}_{$x,$p}" *
              "\\left(\\xi\\right)\$" for x in (0:p)'],
     color = (1:p+1)',
     border = :box,
     linewidth = 2,
     legend = :outerright,
     xlabel = "\$\\xi\$",
     ylabel = "\$\\operatorname{B}_{i,p}\\left(\\xi\\right)\$",
     widen = false);

# can be defined recursively.
# The definition
#
# $$\operatorname{B}_{i,p}\left(\xi\right) =
# \xi \; \operatorname{B}_{i-1,p-1}\left(\xi\right) +
# \left(1-\xi\right) \; \operatorname{B}_{i,p-1}\left(\xi\right)$$
#
# according to the recursive algorithm A1.3 from [1997Piegl](@cite) with the
# additional restrictions
#
# $$\operatorname{B}_{0,0}\left(\xi\right) = 1 \text{ and }
# \operatorname{B}_{i,p}\left(\xi\right) = 0 \; \forall \; i<0 \lor i>p$$
#
# will lead to the same Bernstein Polynomials.

B = zeros(typeof(1.0),(length(xi),p+1));
B[:,1] .= 1;
xi_compl = 1 .- xi;
temp_0 = zeros(typeof(1.0),length(xi));
temp_1 = zeros(typeof(1.0),length(xi));
for j in 2:p+1
  temp_0 .= 0;
  for k in 1:j-1
    temp_1 .= B[:,k];
    B[:,k] .= temp_0 .+ xi_compl .* temp_1;
    temp_0 .= xi .* temp_1;
  end # for k
  B[:,j] .= temp_0;
end # for j
plot!(xi,B,
      label = ["\$\\operatorname{B}_{$x,$p}" *
               "\\left(\\xi\\right)\$" for x in (0:p)'],
      color = (1:p+1)',
      line = (:dot, 2),
      marker = (:circle , 5.0, 0.8),
      markerstrokewidth = 0)

# ## Derivatives of Bernstein Polynomials [0,1]
#
# The derivatives for the Bernstein Polynomials
#
# $$\operatorname{B}_{i,p}\left(\xi\right) =
# \frac{p!}{i!\; \left(p-i\right)!}\; \xi^{i}\; \left(1-\xi\right)^{p-i}$$
#
# on the definition area $\xi\in\left[0,1\right]_{\mathbb{R}}$
#
# $$\begin{aligned}
# \frac{\mathrm{d}}{\mathrm{d}\xi}\; \operatorname{B}_{i,p}\left(\xi\right)
# &=
# \frac{p!}{i!\;\left(p-i\right)!}\;
# \left[i \; \xi^{i-1}\; \left(1-\xi\right)^{p-i} - \xi^{i}\; \left(p-i\right)
# \; \left(1-\xi\right)^{p-i-1}\right] \\
# \;
# &=
# p \; \left[\frac{\left(p-1\right)!}{\left(i-1\right)!\;\left(p-i\right)!} \;
# \xi^{i-1}\; \left(1-\xi\right)^{p-i} -
# \frac{\left(p-1\right)!}{i!\;\left(p-i-1\right)!}\;
# \xi^{i} \; \left(1-\xi\right)^{p-i-1}\right]
# \end{aligned}$$
#
# can be build with Bernstein Polynomials of a lesser degree
#
# $$\frac{\mathrm{d}}{\mathrm{d}\xi}\; \operatorname{B}_{i,p}\left(\xi\right) =
# p \; \left[\operatorname{B}_{i-1,p-1}\left(\xi\right) -
# \operatorname{B}_{i,p-1}\left(\xi\right)\right]$$
#
# with $\operatorname{B}_{i,p-1}\left(\xi\right) = 0 \; \forall \; i<0 \lor
# i \geq p$.
#
# The second derivatives
#
# $$\begin{aligned}
# \frac{\mathrm{d}^{2}}{\mathrm{d}\xi^{2}}\;
# \operatorname{B}_{i,p}\left(\xi\right)
# &=
# p \; \left[\frac{\left(p-1\right)!}{\left(i-1\right)!\;\left(p-i\right)!} \;
# \left[ \left(i-1\right) \; \xi^{i-2}\; \left(1-\xi\right)^{p-i} -
# \xi^{i-1}\; \left(p-i\right) \; \left(1-\xi\right)^{p-i-1} \right] -
# \frac{\left(p-1\right)!}{i!\;\left(p-i-1\right)!} \; \left[ i \; \xi^{i-1} \;
# \left(1-\xi\right)^{p-i-1} - \xi^{i} \; \left(p-i-1\right) \;
# \left(1-\xi\right)^{p-i-2} \right] \right] \\
# \;
# &=
# p \; \left(p-1\right) \; \left[ \left[
# \frac{\left(p-2\right)!}{\left(i-2\right)!\;\left(p-i\right)!} \;
# \xi^{i-2}\; \left(1-\xi\right)^{p-i} -
# \frac{\left(p-2\right)!}{\left(i-1\right)!\;\left(p-i-1\right)!} \;
# \xi^{i-1}\; \left(1-\xi\right)^{p-i-1} \right] -
# \left[\frac{\left(p-2\right)!}{\left(i-1\right)!\;\left(p-i-1\right)!} \;
# \xi^{i-1} \; \left(1-\xi\right)^{p-i-1} -
# \frac{\left(p-2\right)!}{i!\;\left(p-i-2\right)!} \; \xi^{i} \;
# \left(1-\xi\right)^{p-i-2}  \right] \right]
# \end{aligned}$$
#
# can be defined with Bernstein Polynomials of two times lower degrees
#
# $$\begin{aligned}
# \frac{\mathrm{d}^{2}}{\mathrm{d}\xi^{2}}\;
# \operatorname{B}_{i,p}\left(\xi\right)
# &=
# p \; \left[ \frac{\mathrm{d}}{\mathrm{d}\xi}\;
# \operatorname{B}_{i-1,p-1}\left(\xi\right) -
# \frac{\mathrm{d}}{\mathrm{d}\xi}\;
# \operatorname{B}_{i,p-1}\left(\xi\right)\right] \\
# \;
# &=
# p \; \left(p-1\right)\; \left[ \left[
# \operatorname{B}_{i-2,p-2}\left(\xi\right) -
# \operatorname{B}_{i-1,p-2}\left(\xi\right) \right] - \left[
# \operatorname{B}_{i-1,p-2}\left(\xi\right) -
# \operatorname{B}_{i  ,p-2}\left(\xi\right)
# \right] \right]
# \end{aligned}$$
#
# with $\operatorname{B}_{i,p-2}\left(\xi\right)=0 \; \forall \; i<0 \lor
# i \geq p-1$.
#
# And the third derivatives
#
# $$\begin{aligned}
# \frac{\mathrm{d}^{3}}{\mathrm{d}\xi^{3}}\;
# \operatorname{B}_{i,p}\left(\xi\right)
# &=
# p \; \left[ \frac{\mathrm{d}^{2}}{\mathrm{d}\xi^{2}}\;
# \operatorname{B}_{i-1,p-1}\left(\xi\right) -
# \frac{\mathrm{d}^{2}}{\mathrm{d}\xi^{2}}\;
# \operatorname{B}_{i,p-1}\left(\xi\right)\right] \\
# \;
# &=
# p \; \left(p-1\right) \left[ \left[
# \frac{\mathrm{d}}{\mathrm{d}\xi}\;\operatorname{B}_{i-2,p-2}\left(\xi\right)
# -
# \frac{\mathrm{d}}{\mathrm{d}\xi}\;\operatorname{B}_{i-1,p-2}\left(\xi\right)
# \right] -  \left[
# \frac{\mathrm{d}}{\mathrm{d}\xi}\;\operatorname{B}_{i-1,p-2}\left(\xi\right)
# -
# \frac{\mathrm{d}}{\mathrm{d}\xi}\;\operatorname{B}_{i,p-2}\left(\xi\right)
# \right] \right]
# \end{aligned}$$
#
# with $\operatorname{B}_{i,p-3}\left(\xi\right)=0 \; \forall \; i<0 \lor
# i \geq p-2$ follow the same rule and can be defined with Polynomials of
# three times lower degrees.
#
# Considering the pattern one can define the $k$-th derivatives of the
# Bernstein Polynomials with the recursive formula
#
# $$\frac{\mathrm{d}^{k}}{\mathrm{d}\xi^{k}}\;
# \operatorname{B}_{i,p}\left(\xi\right)= \left(p-k+1\right) \;
# \left[\frac{\mathrm{d}^{k-1}}{\mathrm{d}\xi^{k-1}}\;
# \operatorname{B}_{i-1,p-1}\left(\xi\right) -
# \frac{\mathrm{d}^{k-1}}{\mathrm{d}\xi^{k-1}}\;
# \operatorname{B}_{i,p-1}\left(\xi\right)\right]$$
#
# with $\frac{\mathrm{d}^{0}}{\mathrm{d}\xi^{0}}
# \operatorname{B}_{i,p}\left(\xi\right) =
# \operatorname{B}_{i,p}\left(\xi\right)$ and
# $\operatorname{B}_{i,p-k}\left(\xi\right)=0 \; \forall \; i<0 \lor
# i \geq p-k+1$.
#
# Therefore one could calculate the derivatives while also calculating the
# Bernstein Polynomials recursively.
#
# Here the calculation scheme for Bernstein Polynomials of the degree $p=3$
#
# $$\begin{matrix}
# \; & \; & \; & \; & \; & \; & B_{0,3} \cr
# \; & \; & \; & \; & \; & \nearrow  & \; \cr
# B_{-1,0} & \; & \; & \; & B_{0,2} & \; & \; \cr
# \; & \;& \; & \nearrow & \; & \searrow & \; \cr
# \; & \; & B_{0,1} & \; & \; & \; & B_{1,3}\cr
# \; & \nearrow & \; & \searrow & \; & \nearrow  & \; \cr
# B_{0,0} & \; & \; & \; & B_{1,2} & \; & \; \cr
# \; & \searrow & \; & \nearrow & \; & \searrow  & \; \cr
# \; & \; & B_{1,1} & \; & \; & \; & B_{2,3} \cr
# \; & \; & \; & \searrow & \; & \nearrow  & \; \cr
# B_{1,0} & \; & \; & \; & B_{2,2} & \; & \; \cr
# \; & \; & \; & \; & \; & \searrow  & \; \cr
# \; & \; & \; & \; & \; & \; & B_{3,3} \cr
# \end{matrix}$$
#
# and the corresponding schemes for the derivatives
#
# $$\begin{array}{c|c|c}
# \begin{matrix}
# \; & \; & \frac{\mathrm{d}}{\mathrm{d}\xi}B_{0,3} \cr
# \; & \nearrow & \; \cr
# B_{0,2} & \; & \; \cr
# \; & \searrow & \; \cr
# \; & \; & \frac{\mathrm{d}}{\mathrm{d}\xi}B_{1,3} \cr
# \; & \nearrow & \; \cr
# B_{1,2} & \; & \; \cr
# \; & \searrow & \; \cr
# \; & \; & \frac{\mathrm{d}}{\mathrm{d}\xi}B_{2,3} \cr
# \; & \nearrow & \; \cr
# B_{2,2} & \; & \; \cr
# \; & \searrow & \; \cr
# \; & \; & \frac{\mathrm{d}}{\mathrm{d}\xi}B_{3,3} \cr
# \end{matrix}
# &
# \begin{matrix}
# \; & \; & \; & \; & \frac{\mathrm{d}^{2}}{\mathrm{d}\xi^{2}}B_{0,3} \cr
# \; & \; & \; & \nearrow & \; \cr
# \; & \; & B_{0,2} & \; & \; \cr
# \; & \nearrow & \; & \searrow & \; \cr
# B_{0,1} & \; & \; & \; & \frac{\mathrm{d}^{2}}{\mathrm{d}\xi^{2}}B_{1,3} \cr
# \; & \searrow & \; & \nearrow & \; \cr
# \; & \; & B_{1,2} & \; & \; \cr
# \; & \nearrow & \; & \searrow & \; \cr
# B_{1,1} & \; & \; & \; & \frac{\mathrm{d}^{2}}{\mathrm{d}\xi^{2}}B_{2,3} \cr
# \; & \searrow & \; & \nearrow & \; \cr
# \; & \; & B_{2,2} & \; & \; \cr
# \; & \; & \; & \searrow & \; \cr
# \; & \; & \; & \; & \frac{\mathrm{d}^{2}}{\mathrm{d}\xi^{2}}B_{3,3} \cr
# \end{matrix}
# &
# \begin{matrix}
# \;&\;&\;&\; & \; & \; &  \frac{\mathrm{d}^{3}}{\mathrm{d}\xi^{3}}B_{0,3} \cr
# \; & \; & \; & \; & \; & \nearrow  & \; \cr
# B_{-1,0} & \; & \; & \; & B_{0,2} & \; & \; \cr
# \; & \;& \; & \nearrow & \; & \searrow & \; \cr
# \;&\;& B_{0,1}&\;&\;& \; & \frac{\mathrm{d}^{3}}{\mathrm{d}\xi^{3}}B_{1,3}\cr
# \; & \nearrow & \; & \searrow & \; & \nearrow  & \; \cr
# B_{0,0} & \; & \; & \; & B_{1,2} & \; & \; \cr
# \; & \searrow & \; & \nearrow & \; & \searrow  & \; \cr
# \;&\;& B_{1,1}&\;&\;&\; & \frac{\mathrm{d}^{3}}{\mathrm{d}\xi^{3}}B_{2,3} \cr
# \; & \; & \; & \searrow & \; & \nearrow  & \; \cr
# B_{1,0} & \; & \; & \; & B_{2,2} & \; & \; \cr
# \; & \; & \; & \; & \; & \searrow  & \; \cr
# \;&\;&\;& \; & \; & \; & \frac{\mathrm{d}^{3}}{\mathrm{d}\xi^{3}}B_{3,3} \cr
# \end{matrix}
# \end{array}$$

B = zeros(typeof(1.0),(length(xi),p+1));
dB = Vector{typeof(B)}(undef,p);
B[:,1] .= 1;
xi_compl = 1 .- xi;
temp_0 = zeros(typeof(1.0),length(xi));
temp_1 = zeros(typeof(1.0),length(xi));
temp_d0 = zeros(typeof(1.0),length(xi));
temp_d1 = zeros(typeof(1.0),length(xi));
for j in 2:p+1
  temp_d = p-j+2;
  dB[temp_d] = copy(B);
  temp_m = 1;
  for i in j:p+1
    temp_m *= i-1;
    temp_d0 .= 0;
    for k in 1:i
      temp_d1 .= dB[temp_d][:,k];
      dB[temp_d][:,k] .= temp_d0 .- temp_d1;
      temp_d0 .= temp_d1;
    end # for k
  end # for i
  dB[temp_d] .*= temp_m;
  temp_0 .= 0;
  for k in 1:j-1
    temp_1 .= B[:,k];
    B[:,k] .= temp_0 .+ xi_compl .* temp_1;
    temp_0 .= xi .* temp_1;
  end # for k
  B[:,j] .= temp_0;
end # for j

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

pltL = Vector{Plots.Plot}(undef,p+1);
pltL[1] = plot(xi,B,ylabel = "\$\\operatorname{B}_{i,p}\\left(\\xi\\right)\$");
for d in 1:p
  pltL[1+d] = plot(xi,dB[d]);
  if d == 1
    plot!(ylabel = "\$\\frac{\\mathrm{d}}{\\mathrm{d}\\xi}\\;" *
                   "\\operatorname{B}_{i,p}\\left(\\xi\\right)\$");
  else
    plot!(ylabel = "\$\\frac{\\mathrm{d}^{$d}}{\\mathrm{d}\\xi^{$d}}\\;" *
                   "\\operatorname{B}_{i,p}\\left(\\xi\\right)\$");
  end # if
  if d == p; plot!(xlabel = "\$\\xi\$"); end
end # for d
plot(pltL...,
     layout = (p+1, 1),
     legend = false,
     border = :box,
     color = (1:p+1)',
     linewidth = 2,
     widen = false,
     size = (600, 800))

# ## Bernstein Polynomials [-1,1]
#
# If we substitutes $\xi = \frac{1}{2}\;\left(\overline{\xi}+1\right)$ into the
# definitions above we get
#
# $$\operatorname{B}_{i,p}\left(\overline{\xi}\right) =
# \frac{p!}{i!\; \left(p-i\right)!}\; \frac{1}{2^{p}}\;
# \left(\overline{\xi}+1\right)^{i}\; \left(1-\overline{\xi}\right)^{p-i}
# \quad \forall \quad \overline{\xi}\in\left[-1,1\right]_{\mathbb{R}}$$
#
# which is the definition for the Bernstein Polynomials on the linear standard
# FEM area $\overline{\xi}\in\left[-1,1\right]_{\mathbb{R}}$.

B = transpose(factorial(p)./(factorial.(0:p).*factorial.(p .- (0:p)))) ./ 2^p;
B = (ξ .+ 1).^(transpose(0:p)).*(1 .- ξ).^(p .- transpose(0:p)) .* B;
plot(ξ,B,
     label = ["\$\\operatorname{B}_{$x,$p}" *
              "\\left(\\overline{\\xi}\\right)\$" for x in (0:p)'],
     color = (1:p+1)',
     border = :box,
     linewidth = 2,
     legend = :outerright,
     xlabel = "\$\\overline{\\xi}\$",
     ylabel = "\$\\operatorname{B}_{i,p}\\left(\\overline{\\xi}\\right)\$",
     widen = false);

# The recursive definition will change to
#
# $$\operatorname{B}_{i,p}\left(\overline{\xi}\right)=
# \frac{1}{2}\;\left[\left(\overline{\xi}+1\right) \;
# \operatorname{B}_{i-1,p-1}\left(\overline{\xi}\right) +
# \left(1-\overline{\xi}\right)\;
# \operatorname{B}_{i,p-1}\left(\overline{\xi}\right)\right]$$
#
# with the additional restrictions
#
# $$\operatorname{B}_{0,0}\left(\overline{\xi}\right) = 1 \text{ and }
# \operatorname{B}_{i,p}\left(\overline{\xi}\right) = 0 \; \forall \; i<0 \lor
# i>p \text{ .}$$

B = zeros(typeof(1.0),(length(ξ),p+1));
B[:,1] .= 1;
ξ0 = (ξ .+ 1) ./ 2;
ξ0_compl = (1 .- ξ) ./ 2;
temp_0 = zeros(typeof(1.0),length(ξ));
temp_1 = zeros(typeof(1.0),length(ξ));
for j in 2:p+1
  temp_0 .= 0;
  for k in 1:j-1
    temp_1 .= B[:,k];
    B[:,k] .= temp_0 .+ ξ0_compl .* temp_1;
    temp_0 .= ξ0 .* temp_1;
  end # for k
  B[:,j] .= temp_0;
end # for j
plot!(ξ,B,
      label = ["\$\\operatorname{B}_{$x,$p}" *
               "\\left(\\overline{\\xi}\\right)\$" for x in (0:p)'],
      color = (1:p+1)',
      line = (:dot, 2),
      marker = (:circle , 5.0, 0.8),
      markerstrokewidth = 0)

# ## Derivatives of Bernstein Polynomials [-1,1]
#
# The derivatives for the Bernstein Polynomials
#
# $$\operatorname{B}_{i,p}\left(\overline{\xi}\right) = \frac{p!}{i!\;
# \left(p-i\right)!}\; \frac{1}{2^{p}}\; \left(\overline{\xi}+1\right)^{i}\;
# \left(1-\overline{\xi}\right)^{p-i}$$
#
# on the linear FEM definition area
# $\overline{\xi}\in\left[-1,1\right]_{\mathbb{R}}$ can be calculated like
# above. After either following the same steps or via substitution we can write
# the generalised derivation relation
#
# $$\frac{\mathrm{d}^{k}}{\mathrm{d}\overline{\xi}^{k}}\;
# \operatorname{B}_{i,p}\left(\overline{\xi}\right)= \frac{p-k+1}{2} \;
# \left[\frac{\mathrm{d}^{k-1}}{\mathrm{d}\overline{\xi}^{k-1}}\;
# \operatorname{B}_{i-1,p-1}\left(\overline{\xi}\right) -
# \frac{\mathrm{d}^{k-1}}{\mathrm{d}\overline{\xi}^{k-1}}\;
# \operatorname{B}_{i,p-1}\left(\overline{\xi}\right)\right]$$
#
# with $\frac{\mathrm{d}^{0}}{\mathrm{d}\overline{\xi}^{0}}\;
# \operatorname{B}_{i,p}\left(\overline{\xi}\right) =
# \operatorname{B}_{i,p}\left(\overline{\xi}\right)$ and
# $\operatorname{B}_{i,p-k}\left(\overline{\xi}\right)=0 \; \forall \; i<0
# \lor i \geq p-k+1$.
#
# The only difference is the changed argument variable and the factor
# $\frac{1}{2}$. Therefore the algorithm to calculate the derivatives has to be
# changed minimally.

B = zeros(typeof(1.0),(length(ξ),p+1));
dB = Vector{typeof(B)}(undef,p);
B[:,1] .= 1;
ξ0 = (ξ .+ 1) ./ 2;
ξ0_compl = (1 .- ξ) ./ 2;
temp_0 = zeros(typeof(1.0),length(ξ));
temp_1 = zeros(typeof(1.0),length(ξ));
temp_d0 = zeros(typeof(1.0),length(ξ));
temp_d1 = zeros(typeof(1.0),length(ξ));
for j in 2:p+1
  temp_d = p-j+2;
  dB[temp_d] = copy(B);
  temp_m = 1;
  for i in j:p+1
    temp_m *= (i-1)/2;
    temp_d0 .= 0;
    for k in 1:i
      temp_d1 .= dB[temp_d][:,k];
      dB[temp_d][:,k] .= temp_d0 .- temp_d1;
      temp_d0 .= temp_d1;
    end # for k
  end # for i
  dB[temp_d] .*= temp_m;
  temp_0 .= 0;
  for k in 1:j-1
    temp_1 .= B[:,k];
    B[:,k] .= temp_0 .+ ξ0_compl .* temp_1;
    temp_0 .= ξ0 .* temp_1;
  end # for k
  B[:,j] .= temp_0;
end # for j

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

pltL = Vector{Plots.Plot}(undef,p+1);
pltL[1] = plot(ξ,B,ylabel = "\$\\operatorname{B}_{i,p}" *
                            "\\left(\\overline{\\xi}\\right)\$");
for d in 1:p
  pltL[1+d] = plot(ξ,dB[d]);
  if d == 1
    plot!(ylabel = "\$\\frac{\\mathrm{d}}{\\mathrm{d}\\xi}\\;" *
                   "\\operatorname{B}_{i,p}\\left(\\overline{\\xi}\\right)\$");
  else
    plot!(ylabel = "\$\\frac{\\mathrm{d}^{$d}}{\\mathrm{d}\\xi^{$d}}\\;" *
                   "\\operatorname{B}_{i,p}\\left(\\overline{\\xi}\\right)\$");
  end # if
  if d == p; plot!(xlabel = "\$\\overline{\\xi}\$"); end
end # for d
plot(pltL...,
     layout = (p+1, 1),
     legend = false,
     border = :box,
     color = (1:p+1)',
     linewidth = 2,
     widen = false,
     size = (600, 800))
