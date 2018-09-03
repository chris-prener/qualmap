#' Validate cluster object
#'
#' @description This function tests to see whether an object is of class \code{qm_cluster}.
#'
#' @usage qm_is_cluster(obj)
#'
#' @param obj Object to test
#'
#' @return A logical scalar that is \code{TRUE} is the given object is of class \code{qm_cluster};
#' it will return \code{FALSE} otherwise.
#'
#' @examples
#' # load and format reference data
#' stl <- stLouis
#' stl <- dplyr::mutate(stl, TRACTCE = as.numeric(TRACTCE))
#'
#' # create cluster
#' cluster <- qm_define(118600, 119101, 119300)
#'
#' # create simple cluster object
#' cluster_obj <- qm_create(ref = stl, key = TRACTCE, value = cluster,
#'     rid = 1, cid = 1, category = "positive")
#'
#' # test cluster object
#' qm_is_cluster(cluster_obj)
#'
#' @export
qm_is_cluster <- function(obj){

  classList <- base::class(obj)

  "qm_cluster" %in% classList -> classResult

  return(classResult)

}
