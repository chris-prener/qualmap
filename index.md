
# qualmap <img src="man/figures/qualmapLogo.png" align="right" />

[![R build status](https://github.com/chris-prener/qualmap/workflows/R-CMD-check/badge.svg)](https://github.com/chris-prener/qualmap/actions)
[![Coverage Status](https://img.shields.io/codecov/c/github/chris-prener/qualmap/master.svg)](https://codecov.io/github/chris-prener/qualmap?branch=main)
[![CRAN_status_badge](https://www.r-pkg.org/badges/version/qualmap)](https://cran.r-project.org/package=qualmap)
[![cran checks](https://cranchecks.info/badges/worst/qualmap)](https://cran.r-project.org/web/checks/check_results_qualmap.html)
[![Downloads](https://cranlogs.r-pkg.org/badges/qualmap?color=brightgreen)](https://www.r-pkg.org/pkg/qualmap)
[![DOI](https://zenodo.org/badge/122496910.svg)](https://zenodo.org/badge/latestdoi/122496910)

The goal of `qualmap` is to make it easy to enter data from qualitative maps. `qualmap` provides a set of functions for taking qualitative GIS data, hand drawn on a map, and converting it to a simple features object. These tools are focused on data that are drawn on a map that contains some type of polygon features. For each area identified on the map, the id numbers of these polygons can be entered as vectors and transformed using `qualmap`.

## Quick Start
The easiest way to get `qualmap` is to install it from CRAN:

``` r
install.packages("qualmap")
```

Alternatively, the development version of `qualmap` can be accessed from GitHub with `remotes`:

```r
# install.packages("remotes")
remotes::install_github("chris-prener/qualmap")
```

Additional details, including some tips for installing `sf`, can be found in the [Get started article](articles/qualmap.html#getting-started).

## Contributor Code of Conduct
Please note that this project is released with a [Contributor Code of Conduct](https://chris-prener.github.io/qualmap/CODE_OF_CONDUCT.html). By participating in this project you agree to abide by its terms.
