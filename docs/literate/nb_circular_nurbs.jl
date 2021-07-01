using Revise; #nb
push!(LOAD_PATH, "../../src/IGA/aHBS/"); #nb
using MagMechFEM_Matlab2Julia.AHBS; #md
using AHBS; #nb
using Plots;
default(background_color=:transparent, #hide #md
        foreground_color=:grey, #hide #md
        html_output_format=:svg); #hide #md

# # Round NURBS Structures
#
# These notes were made to understand how circular NURBS structures work. I
# made only examples for open structures.
#
# ## Plotting Circles
#
# Nurbs circle description by [1997Piegl](@cite) page 299.

p = 2;
a = 1/sqrt(2);
knots = vec([0 0 0 1/4 1/4 1/2 1/2 3/4 3/4 1 1 1]);
points = [ 1  0 0; 1  1 0; 0  1 0; -1 1   0; -1 0 0;
          -1 -1 0; 0 -1 0; 1 -1 0;  1 0 0.0];
weights = vec([1 a 1 a 1 a 1 a 1]);

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

coords = collect(range(0,1,length=51));

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C = univariate_NURBS(coords,p,knots,points,weights);

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

plot(C[:,1],C[:,2],
     label = "\$\\mathbf{C}\\left(\\xi\\right)\$",
     border = :box,
     linewidth = 2,
     legend = :outerright,
     xlabel = "\$x\$",
     ylabel = "\$y\$",
     aspect_ratio = :equal);
plot!(points[:,1],points[:,2],
      label = "\$\\operatorname{P}_{i}\$",
      color = :green,
      line = (:dot, 2),
      marker = (:circle , 5.0, 0.8),
      markerstrokewidth = 0,
      series_annotations = text.(string.(1:size(points,1)) .* " ",
                                 color = :green,:right))

#------------------------------------------------------------------------------

p = 2;
a = cos(30/180*pi);
knots = vec([0 0 0 1/3 1/3 2/3 2/3 1 1 1]);
points = [a 1/2 0; 0 2 0; -a 1/2 0; -2*a -1 0; 0 -1 0; 2*a -1 0; a 1/2 0];
weights = vec([1 1/2 1 1/2 1 1/2 1]);

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

coords = collect(range(0,1,length=51));

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C = univariate_NURBS(coords,p,knots,points,weights);

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

plot(C[:,1],C[:,2],
     label = "\$\\mathbf{C}\\left(\\xi\\right)\$",
     border = :box,
     linewidth = 2,
     legend = :outerright,
     xlabel = "\$x\$",
     ylabel = "\$y\$",
     aspect_ratio = :equal);
plot!(points[:,1],points[:,2],
      label = "\$\\operatorname{P}_{i}\$",
      color = :green,
      line = (:dot, 2),
      marker = (:circle , 5.0, 0.8),
      markerstrokewidth = 0,
      series_annotations = text.(string.(1:size(points,1)) .* " ",
                                 color = :green,:right))

# ## Plotting Ellipsoid

p = [2;2];
n = [9;5];
knots = [vec([0 0 0 0.25 0.25 0.5 0.5 0.75 0.75 1 1 1]),
         vec([0 0 0 0.5 0.5 1 1 1])];
points = [
  -18.0 4.0 -2.0; -18.0 4.0 -2.0; -18.0 4.0 -2.0; -18.0 4.0 -2.0;
  -18.0 4.0 -2.0; -18.0 4.0 -2.0; -18.0 4.0 -2.0; -18.0 4.0 -2.0;
  -18.0 4.0 -2.0; -18.0 8.0 -2.0; -18.0 8.0  2.0; -18.0 4.0  2.0;
  -18.0 0.0  2.0; -18.0   0 -2.0; -18.0   0 -6.0; -18.0 4.0 -6.0;
  -18.0 8.0 -6.0; -18.0 8.0 -2.0;  -3.0 8.0 -2.0;  -3.0 8.0  2.0;
   -3.0 4.0  2.0;  -3.0 0.0  2.0;  -3.0   0 -2.0;  -3.0   0 -6.0;
   -3.0 4.0 -6.0;  -3.0 8.0 -6.0;  -3.0 8.0 -2.0;  12.0 8.0 -2.0;
   12.0 8.0  2.0;  12.0 4.0  2.0;  12.0 0.0  2.0;  12.0   0 -2.0;
   12.0   0 -6.0;  12.0 4.0 -6.0;  12.0 8.0 -6.0;  12.0 8.0 -2.0;
   12.0 4.0 -2.0;  12.0 4.0 -2.0;  12.0 4.0 -2.0;  12.0 4.0 -2.0;
   12.0 4.0 -2.0;  12.0 4.0 -2.0;  12.0 4.0 -2.0;  12.0 4.0 -2.0;
   12.0 4.0 -2.0];
s = sqrt(1/2);
weights = [  1;   s;   1; s;   1; s; 1; s; 1; s; 0.5; s; 0.5;   s; 0.5;
             s; 0.5;   s; 1;   s; 1; s; 1; s; 1;   s; 1;   s; 0.5;   s;
           0.5;   s; 0.5; s; 0.5; s; 1; s; 1; s;   1; s;   1;   s;   1];

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

len = [21;21];
coords = cat(repeat(range(0,1,length=len[2]),inner=len[1]),
             repeat(range(0,1,length=len[1]),outer=len[2]),dims=2);

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C = bivariate_NURBS( coords, p, knots, points, weights, n);

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Plots.pyplot();
R = (reshape(C[:,2],(len[1],len[2])) .- minimum(C[:,2])) ./
    (maximum(C[:,2]) - minimum(C[:,2]))
plt1 = plot(reshape(C[:,1],(len...)),
            reshape(C[:,2],(len...)),
            reshape(C[:,3],(len...)),
            fill_z=R,
            legend = nothing,
            color=:viridis,
            seriestype=:surface,
            linecolor = :blue,
            linewidth=5);
plot!(reshape(points[:,1],(n...)),
      reshape(points[:,2],(n...)),
      reshape(points[:,3],(n...)),
      st=:wireframe,
      linewidth=0.5,
      marker = (:circle , 5.0, 0.8),
      line = (:dot, 0.5),
      xlabel = "\$x\$",
      ylabel = "\$y\$",
      zlabel = "\$z\$");
plt2 = heatmap(range(0,1,length=len[2]),
               range(0,1,length=len[1]), R,
               legend = nothing,
               border = :box,
               color = :viridis,
               aspect_ratio = :equal,
               xlabel = "\$\\xi\$",
               ylabel = "\$\\eta\$",
               widen = false);
plot(plt2,plt1,layout=(1,2))
