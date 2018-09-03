#' qualmap: Opinionated Approach for Digitizing Semi-structured Qualitative GIS Data
#'
#' @description Provides a set of functions for taking qualitative GIS data, hand drawn on a map, and
#' converting it to a simple features object. These tools are focused on data that are drawn on a map
#' that contains some type of polygon features. For each area identified on the map, the id numbers
#' of these polygons can be entered as vectors and transformed using qualmap.
#'
#' @details Qualitative GIS outputs are notoriously difficult to work with because individuals'
#' conceptions of space can vary greatly from each other and from the realities of physical geography
#' themselves. \code{qualmap} builds on a semi-structured approach to qualitative GIS data collection.
#' Respondents use a specially designed basemap that allows them free reign to identify geographic
#' features of interest and makes it easy to convert their annotations into digital map features.
#' This is facilitated by including on the basemap a series of polygons, such as neighborhood
#' boundaries or census geography, along with an identification number that can be used by
#' \code{qualmap}. A circle drawn on the map can therefore be easily associated with the features
#' that it touches or contains.
#'
#' \code{qualmap} provides a suite of functions for entering, validating, and creating \code{sf} objects
#' based on these hand drawn clusters and their associated identification numbers. Once the clusters
#' have been created, they can be summarized and analyzed either within \code{R} or using another tool.
#'
#' This approach provides an alternative to either unstructured qualitative GIS data,
#' which are difficult to work with empirically, and to digitizing respondents' annotations as rasters,
#' which require a sophisticated workflow. This semi-structured approach makes integrating qualitative GIS
#' with existing census and administrative data simple and straightforward, which in turn allows
#' these data to be used as measures in spatial statistical models.
#'
#' There are six key verbs introduced in \code{qualmap}:
#' \itemize{
#'     \item{\emph{define}: create a vector of feature id numbers that constitute a single "cluster"}
#'     \item{\emph{validate}: check feature id numbers against a reference data set to ensure that the
#'     values are valid}
#'     \item{\emph{preview}: plot cluster on an interactive map to ensure the feature ids have been
#'     entered correctly (the preview should match the map used as a data collection instrument)}
#'     \item{\emph{create}: create a single cluster object once the data have been validated and
#'     visually inspected}
#'     \item{\emph{combine}: combine multiple cluster objects together into a single tibble data
#'     object}
#'     \item{\emph{summarize}: summarize the combined data object based on a single qualitative
#'     construct to prepare for mapping}
#' }
#'
#' @section Tidy Evaluation:
#'     \code{qualmap} makes use of tidy evaluation, meaning that key and category references may be
#'     either quoted or unquoted (i.e. bare).
#'
#' @author
#'     \strong{Author and Maintainer:} Christopher Prener, Ph.D. \href{chris.prener@slu.edu}{chris.prener@slu.edu}
#'
#' @seealso Useful links:
#' \itemize{
#'   \item{\href{https://slu-openGIS.github.io/qualmap/}{Package Website and Documentation}}
#'   \item{\href{https://github.com/slu-openGIS/qualmap}{Source Code on GitHub}}
#'   \item{\href{https://github.com/slu-openGIS/qualmap/issues}{Bug Reports and Feature Requests}}
#'   \item{\href{https://slu-openGIS.github.io/}{Chris Prener's Open GIS Project at Saint Louis University}}
#' }
#'
#' @name qualmap
#' @docType package
NULL
