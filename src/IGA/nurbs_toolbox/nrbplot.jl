#    Copyright (c) 2021 J.A. Duffek
#    Copyright (c) 2000 D.M. Spink
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, see <http://www.gnu.org/licenses/>.

using Plots;

"""
    nrbplot(nurbs::NURBS{I,F},
            npts::Union{I, Vector{I}} [;
            plotargs... ]
           ) where {I<:Integer,F<:AbstractFloat}

Plot a NURBS curve or a surface.

# Arguments:
- `nurbs`: NURBS structure
- `npts`: Number of evaluation points, for a surface a vector with two elements
  for the number of points along the U and V directions respectively.
- `plotargs`: plot arguments to pass to the wrapped plot function

!!! note "Note:"
    For 3D Plots `nrbplot` uses the `Plots.pyplot()` backend. Use plot
    arguments compatible with that backend.

# Examples:
```julia
julia> nrbplot(nrb,subd)
julia> nrbplot(nrb,subd,c=:winter)
```

Plot the test surface with 20 points along the U direction and 30 along the V
direction
```julia
julia> nrbplot(nrbtestsrf,[20;30],c=:copper)
```

!!! note "Note:"
    Contrary to the Matlab version does this ported version supports no
    specialised input arguments just pass named plot arguments which will
    be passed to the wrapped plot functions.

!!! note "Note:"
    It is also possible to overload the Julia `plot()` function with the
    mechanic [Recipes](https://docs.juliaplots.org/latest/recipes).

# Reference
- see also: [`nrbeval`](@ref)
"""
function nrbplot(nurbs::NURBS{I,F},
                 npts::Union{I, Vector{I}};
                 plotargs...
                ) where {I<:Integer,F<:AbstractFloat}
# TODO: this ported version does not do all the tests of the matlab version,
#       instead the type features of julia are used -> check if the matlab
#       errors get caught
# TODO: have a look into Recipes to make the plotting more adaptive and to
#       maybe replace this function
# TODO: implement a nrbplot!() version or allow overloading and pass that ! to
#       the plot routines

# TODO: make this workaround obsolete with Recipes
# filter out key indicating append to old plot as workaround
# in order not to write a near indetical copy of this function
appendflag = false;
if :nrbplot_append in keys(plotargs)
  appendflag = plotargs[:nrbplot_append];
  plotargs = (; filter(p->first(p) != :nrbplot_append,
                       collect(pairs(plotargs)))...);
end

subd = npts .+ 1;

if typeof(nurbs)<:NURBS2D
  if !(typeof(npts)<:Vector{I}) || length(npts)!=2
    throw(ArgumentError("To plot surfaces a Vector{I} with the length 2 is " *
                        "needed!"));
  end # if
  # default color map
  defaults = (; c=:jet, st=:surface, aspect_ratio=:auto);
  settings = merge( defaults, plotargs );
  # TODO: pyplot 3D does not supports equal axis scale, add that later

  # plot a NURBS surface
  p = nrbeval(nurbs,[collect(range(0,1,length=subd[1])),
                     collect(range(0,1,length=subd[2]))]);

  Plots.pyplot();
  if appendflag
   plot!(p[1,:,:],p[2,:,:],p[3,:,:];settings...);
 else
   plot(p[1,:,:],p[2,:,:],p[3,:,:];settings...);
 end
  # TODO: the julia plotting eco system for 3D plots is still a bit chaotic
  #       come back later and make this solution a bit more robust
else
  if !(typeof(npts)<:I)
    throw(ArgumentError("Valid argument of npts for curves is <:Integer!"));
  end # if

  # plot a NURBS curve
  p = nrbeval(nurbs,collect(range(0,1,length=subd)));

  if all(i->i==0,p[3,:])
    # 2D curve

    # default color map
    defaults = (; aspect_ratio=:equal);
    settings = merge( defaults, plotargs );

    if appendflag
      plot!(p[1,:],p[2,:];settings...);
    else
      plot(p[1,:],p[2,:];settings...);
    end
  else
    # 3D curve

    # default color map
    defaults = (; aspect_ratio=:auto);
    settings = merge( defaults, plotargs );
    # TODO: pyplot 3D does not supports equal axis scale, add that later

    Plots.pyplot();
    if appendflag
      plot!(p[1,:],p[2,:],p[3,:];settings...);
    else
      plot(p[1,:],p[2,:],p[3,:];settings...);
    end
    # TODO: the julia plotting eco system for 3D plots is still a bit chaotic
    #       come back later and make this solution a bit more robust
  end
end # if
end # nrbplot

"""
    nrbplot!(nurbs::NURBS{I,F},
             npts::Union{I, Vector{I}} [;
             plotargs... ]
            ) where {I<:Integer,F<:AbstractFloat}

Plot a NURBS curve or a surface.

Wrapper of [`nrbplot`](@ref) in order to introduce the Julia plot append
mechanic for that plot routine.

!!! note "Note:"
    This function serves only as wrapper for the [`nrbplot`](@ref) function for
    input arguments and usage look at that function.

# Reference
- see [`nrbplot`](@ref)
"""
function nrbplot!(nurbs::NURBS{I,F},
                  npts::Union{I, Vector{I}};
                  plotargs...
                 ) where {I<:Integer,F<:AbstractFloat}
# append nrbplot_append = true to plotargs
defaults = (; nrbplot_append=true);
plotargs = merge( defaults, plotargs );
nplt = nrbplot(nurbs,npts; plotargs...);
end
