<!-- README.md is generated from README.Rmd. Please edit that file -->
qualmap <img src="man/figures/qualmapLogo.png" align="right" />
===============================================================

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Travis-CI Build
Status](https://travis-ci.org/slu-openGIS/qualmap.svg?branch=master)](https://travis-ci.org/slu-openGIS/qualmap)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/slu-openGIS/qualmap?branch=master&svg=true)](https://ci.appveyor.com/project/slu-openGIS/qualmap)
[![Coverage
Status](https://img.shields.io/codecov/c/github/slu-openGIS/qualmap/master.svg)](https://codecov.io/github/slu-openGIS/qualmap?branch=master)
[![CRAN\_status\_badge](http://www.r-pkg.org/badges/version/gateway)](https://cran.r-project.org/package=gateway)

The goal of `qualmap` is to make it easy to enter data from qualitative
maps.

Motivation and Approach
-----------------------

Qualitative GIS outputs are notoriously difficult to work with because
individuals’ conceptions of space can vary greatly from each other and
from the realities of physical geography themselves. This package
implements a process for converting qualitative GIS data from an
exercise where respondents are asked to identify salient locations on a
map. The basemaps used in this approach have a series of polygons, such
as neighborhood boundaries or census geography. A circle drawn on the
map is compared during data entry to a key identifying each feature, and
the feature ids are entered for each feature that the respondent’s
cricle touches. These circles are referred to as “clusters”.

Installation
------------

### Installing Dependencies

You should check the [`sf` package
website](https://r-spatial.github.io/sf/) for the latest details on
installing dependenices for that packge. Instructions vary significantly
by operating system. For best results, have `sf` installed before you
install `qualmap`. Other dependencies, like `dplyr` and `leaflet`, will
be installed automatically with `qualmap` if they are not already
present.

### Installing qualmap

You can install `qualmap` from GitHub with the `remotes` package:

``` r
# install.packages("remotes")
remotes::install_github("slu-openGIS/qualmap")
```

Useage
------

`qualmap` implements six verbs for working with mental map data:

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
vignette](https://slu-openGIS.github.io/qualmap/articles/qualmap.html)
contains an overview of the workflow for implementing these functions.

Contributor Code of Conduct
---------------------------

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
