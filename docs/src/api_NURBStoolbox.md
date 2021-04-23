# API: NURBS Toolbox

```@meta
CurrentModule = NURBStoolbox
```

```@contents
Pages = ["api_NURBStoolbox.md"]
Depth = 2
```

## Module

```@raw html
<style>
#horlist ul {
display: grid;
grid-template-columns: repeat(auto-fit, minmax(25ch, 1fr));
grid-gap: 4px;
list-style: none;
}
</style>
<div id="horlist">
```

```@docs
NURBStoolbox
```

```@raw html
</div>
```

## Data Structures


```@raw html
<style>
#horfield li > p + p::before {
content: ": ";
}
#horfield li > p {
display: contents;
}
</style>
<div id="horfield">
```

```@docs
NURBS
NURBS1D
NURBS2D
```

```@raw html
</div>
```

## Evaluation Functions/Methods

```@docs
basisfun
bspeval
nrbmak
nrbeval
nrbplot
nrbplot!
```

## Utility and Modification Functions/Methods

```@docs
findspan
vecscale
vectrans
vecrotx
vecroty
vecrotz
nrbtform
nrbextrude
nrbrevolve
vecdot
veccross
vecmag
vecmag2
vecnorm_toolbox
vecangle
nrbtransp
bspdegelev
nrbdegelev
bspkntins
nrbkntins
bspderiv
nrbderiv
nrbdeval
nrbreverse
nrbruled
nrbcoons
```


## Recipes for NURBS Structures

```@docs
nrbline
nrbrect
nrb4surf
nrbcirc
nrbcylind
```

## Test/Demo Functions/Methods

```@docs
nrbtestcrv
nrbtestsrf
demoline
demorect
democirc
demoellip
democurve
demohelix
democylind
demotorus
demorevolve
demodegelev
demokntins
demodercrv
demodersrf
demoruled
democoons
demo4surf
demogeom
```

## Private Functions/Methods

```@docs
bincoeff
factln
```

## Index

```@index
```
