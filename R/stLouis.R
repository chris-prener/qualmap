#' Census Tracts, 2016
#'
#' A simple features data set containing the geometry and associated attributes for the 2016 City of St. Louis
#' census tracts.
#'
#' @docType data
#'
#' @usage data(stl_sf_tracts)
#'
#' @format A data frame with 106 rows and 7 variables:
#' \describe{
#'   \item{STATEFP}{state FIPS code}
#'   \item{COUNTYFP}{county FIPS code}
#'   \item{TRACTCE}{tract FIPS code}
#'   \item{GEOID}{full GEOID string}
#'   \item{NAME}{tract FIPS code, decimal}
#'   \item{NAMELSAD}{tract name}
#'   \item{geometry}{simple features geometry}
#'   }
#'
#' @note These data have been modified from the full version available from the Census Bureau - some
#' variables related to geometry and geography type have been removed.
#'
#' @source \href{https://www.census.gov}{U.S. Census Bureau}
#'
#' #' @examples
#' str(stLouis)
#' head(stLouis)
#'
"stLouis"
