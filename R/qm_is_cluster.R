#' Validate cluster object
#'
#' @description This function tests to see whether an object contains the characteristics of an object
#'   created by \code{qm_cluster}. It is used as part of the \code{qm_combine} and \code{qm_summarize}
#'   functions, and is exported so that it can be used interactively as well.
#'
#' @usage qm_is_cluster(obj, verbose = FALSE)
#'
#' @param obj Object to test
#' @param verbose A logical scalar; if \code{TRUE}, a tibble with test results is returned
#'
#' @return A logical scalar that is \code{TRUE} if the given object contains the approprite
#'   characteristics; if it does not, \code{FALSE} is returned.
#'
#' @seealso \code{qm_combine}, \code{qm_summarize}
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
#' qm_is_cluster(cluster_obj, verbose = TRUE)
#'
#' @export
qm_is_cluster <- function(obj, verbose = FALSE){

  # check parameters
  if (verbose != TRUE & verbose != FALSE){
    stop("The 'verbose' argument must be either 'TRUE' or 'FALSE'.")
  }

  # verify columns
  if (ncol(obj) < 4){
    count <- FALSE
  } else {
    count <- TRUE
  }

  if ("RID" %in% names(obj) == FALSE){
    rid <- FALSE
  } else {
    rid <- TRUE
  }

  if ("CID" %in% names(obj) == FALSE){
    cid <- FALSE
  } else {
    cid <- TRUE
  }

  if ("CAT" %in% names(obj) == FALSE){
    cat <- FALSE
  } else {
    cat <- TRUE
  }

  # construct output
  output <- dplyr::tibble(
    test = c("Contains at least 4 columns", "Contains RID variable", "Contains CID variable", "Contains CAT variable"),
    result = c(count, rid, cid, cat)
  )

  # summarise optionally
  if (verbose == FALSE){
    output <- all(output$result)
  }

  # return output
  return(output)

}
