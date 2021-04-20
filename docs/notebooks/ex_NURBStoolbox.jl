
#+ 

using Revise; # hide
push!(LOAD_PATH, "../../src/IGA/nurbs_toolbox/");
using NURBStoolbox;
using Plots;
default(background_color=:transparent,foreground_color=:grey,html_output_format=:svg);

#' 
#' # NURBS Toolbox
#' 
#' This notebook will demonstrate some capabilities of the ported NURBS Toolbox by D.M. Spink ([2000Spink](@cite)).
#' 
#' Note that the original Matlab version has not been ported with the same syntax and behaviours.
#' As Julia is a different language with different features.
#' Skim through those examples to get a grasp on the differences if you know the original toolbox.
#' 
#' ## NURBS Data Types
#' 
#' This section demonstrates how to construct NURBS data types. And how to identify them.
#' 
#' To build NURBS structures it is advised to use the function `nrbmak()` which will accept inputs for surfaces or curves.
#' 
#+ 

line = nrbmak([0.0 1.5; 0.0 3.0],vec([0.0 0.0 1.0 1.0]))


#+ 

coefs = cat([0.0 0.0; 0.0 1.0],[1.0 1.0; 0.0 1.0],dims=3);
knots = [vec([0.0 0.0 1.0 1.]),vec([0.0 0.0 1.0 1.0])];
plane = nrbmak(coefs,knots)

#' 
#' The fields of the data structures can be accessed similar to Matlab.
#' 
#+ 

plane.coefs

#' 
#' Those created data types are typed. And can be therefore used to check for certain types.
#' 
#+ 

println( typeof(line ) )
println( typeof(plane) )

#' 
#' The abstract super type `NURBS` can be used to check for the superset of NURBS.
#' 
#+ 

println( typeof(line )<:NURBS )
println( typeof(plane)<:NURBS )

#' 
#' The types `NURBS1D` and `NURBS2D` can be used to check for NURBS curves or surfaces.
#' 
#+ 

println( typeof(line )<:NURBS1D )
println( typeof(plane)<:NURBS1D )
println( typeof(line )<:NURBS2D )
println( typeof(plane)<:NURBS2D )

#' 
#' ## NURBS Curves
#' 
#' As mentioned creates this toolbox NURBS curves with `nrbmak()`.
#' This function uses a point matrix (each column a point and each row a coordinate)
#' 
#+ 

pnts = [0.5 1.5 4.5 3.0 7.5 6.0 8.5;
        3.0 5.5 5.5 1.5 1.5 4.0 4.5;
        0.0 0.0 0.0 0.0 0.0 0.0 0.0];

#' 
#' and a corresponding knot open knot vector
#' 
#+ 

knots = vec([0 0 0 1/4 1/2 3/4 3/4 1 1 1]);

#' 
#' as input arguments.
#' 
#+ 

crv = nrbmak(pnts,knots);

#' 
#' Note that this toolbox does works with open NURBS curves!
#' 
#' This curve can also build by using the test function `nrbtestcrv()`.
#' To evaluate the curve the function `nrbeval()` can be used.
#' 
#+ 

p1 = nrbeval(crv,collect(range(0,1,length=101)),:cartesian)

#' 
#' The results can be used for plotting or for further evaluation.
#' 
#+ 

plot(p1[1,:],p1[2,:],
    border=:box,
    label="crv",
    aspect_ratio=:equal,
    linewidth=2)
plot!(crv.coefs[1,:],crv.coefs[2,:],
      linestyle=:dash,
      markershape =:circle,
      markerstrokewidth = 0.5,
      label="crv.coefs",
      aspect_ratio=:equal)

#' 
#' ## Surfaces
#' 
#' The creation of NURBS surfaces is done similarly to the curves.
#' The input for `nrbmak` with the difference that the points are defined with a 3D Array.
#' The first and second dimension are used equally to the curve for U-direction and the third dimension stores the points in V direction.
#' 
#' Since the process is similar we use a shortcut for creating the data structure.
#' 
#+ 

srf = nrbtestsrf()

#' 
#' The evaluation of the surface can also be done with `nrbeval()`.
#' 
#+ 

p2 = nrbeval(srf,[collect(range(0,1,length=20)),collect(range(0,1,length=20))]);

#' 
#' The plotting of that data can be done with one of the many plotting ecosystems.
#' 
#+ 

Plots.pyplot();
plot(p2[1,:,:],p2[2,:,:],p2[3,:,:],c = :jet,
     st=:surface,
     legend = nothing,
     camera=[-30,30])
plot!(srf.coefs[1,:,:],srf.coefs[2,:,:],srf.coefs[3,:,:],
      linewidth=0.5,
      st=:wireframe)

#' 
#' The toolbox does also provide a plot wrapper `nrbplot()` for the ease of use.
#' 
#+ 

nrbplot(srf,[10;10],
        c=:winter,
        legend = nothing,
        linewidth=0.5,
        camera=[-40,60],
        linecolor = :black)
ϑ = collect(range(0,stop=2*pi,length=180));
t = cat(cos.(ϑ),sin.(ϑ),dims=2) ./2 .+ 0.5
p3 = nrbeval(srf,permutedims(t,[2,1]));
plot!(p3[1,:],p3[2,:],p3[3,:] .- 2,linewidth=2)

#' 
#' Note that this wrapper `nrbplot()` uses the `Plots.pyplot()` back end for 3D plots which limits the functionality to that ecosystem.
#' One drawback e.g. is that the depth order/buffer is not considered between chained plot commands.
#' That can be seen in the last plot. The curve is plotted `2` units bellow the surface.
#' 
#+ 



#+ 


