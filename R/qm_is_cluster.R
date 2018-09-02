#' Validate cluster object
#'
#' @description This function tests to see whether an object is of class \code{qm_cluster}.
#'
#' @param obj Object to test
#'
#' @return A logical scalar that is \code{TRUE} is the given object is of class \code{qm_cluster};
#' it will return \code{FALSE} otherwise.
#'
#' @export
qm_is_cluster <- function(obj){

  classList <- base::class(obj)

  "qm_cluster" %in% classList -> classResult

  return(classResult)

}
