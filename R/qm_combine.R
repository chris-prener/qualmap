#' Combine objects
#'
#' @description A wrapper around \code{dplyr::bind_rows} for combining cluster objects into a single tibble.
#'
#' @usage qm_combine(...)
#'
#' @param ... A list of cluster objects to be combined.
#'
#' @return A single tibble with all observations from the listed cluster objects.
#'
#' @examples
#' # load and format reference data
#' stl <- stLouis
#' stl <- dplyr::mutate(stl, TRACTCE = as.numeric(TRACTCE))
#'
#' # create clusters
#' cluster1 <- qm_define(118600, 119101, 119300)
#' cluster2 <- qm_define(119300, 121200, 121100)
#'
#' # create cluster objects
#' cluster_obj1 <- qm_create(ref = stl, key = TRACTCE, value = cluster1,
#'     rid = 1, cid = 1, category = "positive")
#' cluster_obj2 <- qm_create(ref = stl, key = TRACTCE, value = cluster2,
#'     rid = 1, cid = 2, category = "positive")
#'
#' # combine cluster objects
#' clusters <- qm_combine(cluster_obj1, cluster_obj2)
#'
#' @importFrom dplyr bind_rows
#' @importFrom purrr map
#'
#' @export
qm_combine <- function(...){

  # store elipses data
  dots <- list(...)

  # pull class values for input objects and tests
  classList <- purrr::map(dots, qm_is_cluster)
  classList <- unlist(classList, use.names = FALSE)

  # test class values to ensure that they are class qm_cluster
  if (all(classList) == FALSE){
    stop('One or more of the given objects is not of class qm_cluster. Use qm_is_cluster() to evaluate each object.')
  }

  # pull number of variables in each cluster
  namesCount <- purrr::map(dots, qm_validate_names)
  namesCount <- unlist(namesCount, use.names = FALSE)

  if (length(unique(namesCount)) != 1) {
    stop('The number of columns is not equal across all clusters.')
  }

  colCount <- length(dots[[1]])

  # create combined cluster object
  combinedObj <- dplyr::bind_rows(...)

  # test combinedObj column count
  newCount <- length(combinedObj)

  if (colCount != newCount){
    stop('The given objects do not have identical sets of columns.')
  }

  # return final object
  return(combinedObj)

}

# returns count of number of columns in an object
qm_validate_names <- function(obj){

  colCount <- length(colnames(obj))

  return(colCount)

}
