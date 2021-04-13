
#+ 

using Revise;
push!(LOAD_PATH, "../../src/IGA/nurbs_toolbox/");
using NURBStoolbox;

#' 
#' # NURBS Toolbox
#' 
#' This notebook will demonstrate some of the capabilities of the ported NURBS Toolbox by D.M. Spink [TODO cite].
#' 
#' Note that original Matlab version could not ported with the same syntax and behaviours as Julia is a different language with different features.
#' Skim through this examples to get a grasp on the differences if you know the original toolbox.
#' 
#' ## NURBS Data Types
#' 
#' This section demonstrates how to construct NURBS data types. And how to identify them.
#' 
#' To build NURBS structures it is advised to use the function `nrbmak` which will accept inputs for surfaces or curves.
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

typeof(line)


#+ 

typeof(plane)

#' 
#' The abstract super type `NURBS` can be used to check for the superset of NURBS.
#' 
#+ 

typeof(line)<:NURBS


#+ 

typeof(plane)<:NURBS

#' 
#' The types `NURBS1D` and `NURBS2D` can be used to check for NURBS curves or surfaces.
#' 
#+ 

typeof(line)<:NURBS1D


#+ 

typeof(plane)<:NURBS1D


#+ 

typeof(line)<:NURBS2D


#+ 

typeof(plane)<:NURBS2D


#+ 


