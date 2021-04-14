# NURBS Toolbox

## Licence

This toolbox is licensed under the GPLv2 licence as stated in the `LICENSE` file in its corresponding directory.

## Overview

This toolbox has been ported from Matlab to Julia as part of a bigger language porting project.
Unfortunately the used files did not contain a file clearly indicating the licence.
Therefore, the licence was set to GPLv2 assuming the roots and its original licence.

This package was originally written in 2000 by D.M. Spink for Matlab and Scilab[^1]. And initially hosted on the MathWorks servers.
It was reuploaded by a third party[^2] this state of the packages is used in this port (Version 1.0 by [2000Spink](@cite)).
The seemingly original successor of the toolbox is the Octace community package nurbs[^3] which is actively maintained.

The original description characterizing this toolbox has been published on the website of M. Spink[^1]. Here is an excerpt of that site.

> The NURBS toolbox is collection of routines for the creation, and manipulation of Non-Uniform Rational B-Splines (NURBS). NURBS have to some extent become the de facto industry standard for representing complex geometric information in CAD, CAE and CAM, and are an integral part of many standard data exchange formats such as IGES, STEP and PHIGS.
>
> The toolbox is available for either [Matlab](https://www.mathworks.com/) or [Scilab](https://www.scilab.org/), and contains both script files and c routines to increase the performance. The intention of these toolboxes is not to provide the worlds fastest NURBS manipulation packages, but that coupled with the matlab/scilab environments they provide a friendly means for interactive research and algorithm prototyping.
>
> All the nurbs routines are prefix with `nrb` to differentiate them from any other similar sounding matlab script files by other authors. The data structure used to represent the NURBS in Matlab is compatible with that used in the [Spline Toolbox](http://www.mathworks.com/products/splines) by [C. de Boor](http://pages.cs.wisc.edu/~deboor/) and The MathWorks, Inc and can be manipulated as four dimensional univariate or multivariate B-Splines. Both packages also include demonstration scripts that show examples on how to use the toolbox, and also online help is available.
>
>For a detailed explanation of NURBS and how to manipulate them, I can strongly recommend the book by [Les Piegl](https://www.csee.usf.edu/~lespiegl/) and Wayne Tiller called 'The NURBS Book' ISBN 3-540-61545-8. Please note that the 'C' code algorithms is this library are modified versions of the pseudo-code within the book.
>
>[ ... ]
>
>The NURBS toolbox is provide free of any charges and has a GPL license. The source code is available for the Linux, Solaris and Windows, however should compile easily on other platforms.

[^1]: Spink, M. (2016, Jan. 10) NURBS Toolbox. ARIA. `http://aria.uklinux.net/nurbs.php3` accessible via [WayBackMachine](https://web.archive.org/web/20160110131409/aria.uklinux.net/nurbs.php3)
[^2]: Penguian (2010). NURBS Toolbox by D.M. Spink [https://www.mathworks.com/matlabcentral/fileexchange/26390-nurbs-toolbox-by-d-m-spink](https://www.mathworks.com/matlabcentral/fileexchange/26390-nurbs-toolbox-by-d-m-spink), MATLAB Central File Exchange. Retrieved April 14, 2021.
[^3]: M. Spink, D. Claxton, C. de Falco, R. Vazquez (2021-03-09) Nurbs. Octave Forge Community packages. [https://octave.sourceforge.io/nurbs/index.html](https://octave.sourceforge.io/nurbs/index.html)

## Examples

For further examples see the [demo notebook](notebooks/ex_NURBStoolbox.md).

## API

The [API reference](api_NURBStoolbox.md) could provide a deeper understanding of the capabilities of the toolbox.
