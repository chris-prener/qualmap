
<!-- README.md is generated from README.Rmd. Please edit that file -->

# qualmap <img src="man/figures/qualmapLogo.png" align="right" />

[![R build
status](https://github.com/chris-prener/qualmap/workflows/R-CMD-check/badge.svg)](https://github.com/chris-prener/qualmap/actions)
[![Coverage
Status](https://img.shields.io/codecov/c/github/chris-prener/qualmap/master.svg)](https://codecov.io/github/chris-prener/qualmap?branch=main)
[![CRAN_status_badge](https://www.r-pkg.org/badges/version/qualmap)](https://cran.r-project.org/package=qualmap)
[![cran
checks](https://cranchecks.info/badges/worst/qualmap)](https://cran.r-project.org/web/checks/check_results_qualmap.html)
[![Downloads](https://cranlogs.r-pkg.org/badges/qualmap?color=brightgreen)](https://www.r-pkg.org:443/pkg/qualmap)
[![DOI](https://zenodo.org/badge/122496910.svg)](https://zenodo.org/badge/latestdoi/122496910)

The goal of `qualmap` is to make it easy to enter data from qualitative
maps. `qualmap` provides a set of functions for taking qualitative GIS
data, hand drawn on a map, and converting it to a simple features
object. These tools are focused on data that are drawn on a map that
contains some type of polygon features. For each area identified on the
map, the id numbers of these polygons can be entered as vectors and
transformed using `qualmap`.

## Motivation and Approach

Qualitative GIS outputs are notoriously difficult to work with because
individuals’ conceptions of space can vary greatly from each other and
from the realities of physical geography themselves. `qualmap` builds on
a semi-structured approach to qualitative GIS data collection.
Respondents use a specially designed basemap that allows them free reign
to identify geographic features of interest and makes it easy to convert
their annotations into digital map features. This is facilitated by
including on the basemap a series of polygons, such as neighborhood
boundaries or census geography, along with an identification number that
can be used by `qualmap`. A circle drawn on the map can therefore be
easily associated with the features that it touches or contains.

`qualmap` provides a suite of functions for entering, validating, and
creating `sf` objects based on these hand drawn clusters and their
associated identification numbers. Once the clusters have been created,
they can be summarized and analyzed either within R or using another
tool.

This approach provides an alternative to either unstructured qualitative
GIS data, which are difficult to work with empirically, and to
digitizing respondents’ annotations as rasters, which require a
sophisticated workflow. This semi-structured approach makes integrating
qualitative GIS with existing census and administrative data simple and
straightforward, which in turn allows these data to be used as measures
in spatial statistical models.

### *Cartographica* Article

An [article describing `qualmap`’s approach to qualitative
GIS](https://doi.org/10.3138/cart-2020-0030) has been published in
[*Cartographica*](https://www.utpjournals.press/loi/cart). All data
associated with the article are also available on [Open Science
Framework](https://osf.io/pxzuc/), and the code are available via [Open
Science Framework](https://osf.io/pxzuc/) and
[GitHub](https://github.com/PrenerLab/sketch_mapping/). Please cite the
paper if you use areal in your work!

## Installation

The easiest way to get `qualmap` is to install it from CRAN:

``` r
install.packages("qualmap")
```

You can install the development version of `qualmap` from
[Github](https://github.com/chris-prener/qualmap) with the `remotes`
package:

``` r
# install.packages("remotes")
remotes::install_github("chris-prener/qualmap")
```

Note that installations that require `sf` to be built from *source* will
require additional software regardless of operating system. You should
check the [`sf` package website](https://r-spatial.github.io/sf/) for
the latest details on installing dependencies for that package.
Instructions vary significantly by operating system.

## Usage

`qualmap` implements six primary verbs for working with mental map data:

1.  `qm_define()` - create a vector of feature id numbers that
    constitute a single “cluster”
2.  `qm_validate()` - check feature id numbers against a reference data
    set to ensure that the values are valid
3.  `qm_preview()` - plot cluster on an interactive map to ensure the
    feature ids have been entered correctly (the preview should match
    the map used as a data collection instrument)
4.  `qm_create()` - create a single cluster object once the data have
    been validated and visually inspected
5.  `qm_combine()` - combine multiple cluster objects together into a
    single tibble data object
6.  `qm_summarize()` - summarize the combined data object based on a
    single qualitative construct to prepare for mapping

The [primary
vignette](https://chris-prener.github.io/qualmap/articles/qualmap.html)
contains an overview of the workflow for implementing these functions.

## Contributor Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](https://chris-prener.github.io/qualmap/CODE_OF_CONDUCT.html).
By participating in this project you agree to abide by its terms.
