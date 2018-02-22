<!-- README.md is generated from README.Rmd. Please edit that file -->
qualmap <img src="https://slu-dss.github.io/img/gisLogoSm.png" align="right" />
===============================================================================

[![lifecycle\_badge](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://github.com/slu-openGIS/qualmap) [![CRAN\_status\_badge](http://www.r-pkg.org/badges/version/gateway)](https://cran.r-project.org/package=gateway)

The goal of qualmap is to make it easy to enter data from qualitative maps.

Motivation and Approach
-----------------------

Qualitative GIS outputs are notoriously difficult to work with because individuals' conceptions of space can vary greatly from each other and from the realities of physical geography themselves. This package implements a process for converting qualitative GIS data from an exercise where respondents are asked to identify salient locations on a map. The basemaps used in this approach have a series of polygons, such as neighborhood boundaries or census geography. A circle drawn on the map is compared during data entry to a key identifying each feature, and the feature ids are entered for each feature that the respondent's cricle touches.

Installation
------------

You can install `qualmap` from GitHub with:

``` r
devtools::install_github("slu-openGIS/qualmap")
```

Useage
------

### Data Preparation

To begin, you will need a simple features object containing the polygons you will be matching respondents' data to. Census geography polygons can be downloaded via `tigris`, and other polygon shapefiles can be read into `R` using the `sf` package.

Here is an example of preparing data downloaded via `tigris`:

``` r
library(dplyr)   # data wrangling
library(sf)      # simple features objects
library(tigris)  # access census tiger/line data

stLouis <- tracts(state = "MO", county = 510)
stLouis <- st_as_sf(stLouis)
stLouis <- mutate(stLouis, TRACTCE = as.numeric(TRACTCE))
```

We download the census tract data for St. Louis, which come in `sp` format, using the `tracts()` function from `tigris`. We then use the `sf` package's `st_as_sf()` function to convert these data to a simple features object and convert the `TRACTCE` variable to numeric format.

### Data Entry

Once we have a reference data set constructed, we can begin entering the tract numbers that constitute a single circle on the map or "cluster". We use the `c()` function from base `R` to input these id numbers into a vector:

``` r
cluster1 <- c(118600, 119101, 119300)
```

We can use the `qm_validate()` function to check each value in the vector and ensure that these values all match the `key` variable in the reference data:

``` r
> qm_validate(stLouis, "TRACTCE", cluster1)
[1] TRUE
```

If `qm_validate()` returns a `TRUE` value, all data are matches. If it returns `FALSE`, at least one of the input values does not match any of the `key` variable values. In this case, our `key` is the `TRACTCE` variable in the `sf` object we created earlier.

Once the data are validated, we can preview them interactively using `qm_preview()`, which will show the features identified in the given vector in red on the map:

``` r
qm_preview(stLouis, "TRACTCE", cluster1)
```

![](/man/figures/previewMap.png)

Contributor Code of Conduct
---------------------------

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
