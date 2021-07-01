# MagMechFEM_Matlab2Julia

```@contents
Pages = ["index.md"]
Depth = 2
```

## Licence

`TODO`

## Third party code

| Package/Source | Description |
|:---------------|:------------|
| [NURBS Toolbox](NURBStoolbox.md) | Toolbox for creation, manipulation and evaluation of NURBS structures (from [2000Spink](@cite)). Licence: GPLv2. **This dependency will be removed after the completion of the language port. As it is only needed to check against own implementations.** |

This list might be incomplete or inaccurate as the original Matlab source files did not contain specific licence information
and might have been modified after incorporation into the old project (which was not marked either).

## Overview over Modules/Directories

| Module/Directory | Description |
|:-----------------|:------------|
| [IGA/nurbs_toolbox](doc_NURBStoolbox.md) | Toolbox for creation, manipulation and evaluation of NURBS structures (from [2000Spink](@cite)). |
| [IGA/aHBS](doc_AHBS.md) | Module for the __sparse__ adaptive creation and calculation of hierarchical NURBS levels. It adds furthermore routines for 3D calculation. |

## Further remarks

- [Random collection of notes](notes.md) made to understand, debug and explain.
