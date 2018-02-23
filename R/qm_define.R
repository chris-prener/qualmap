#' Define input values
#'
#' @description A wrapper around \code{c()} that is used for constructing vectors of individual feature values.
#' Each output should correspond to a single cluster on the respondent's map.
#'
#' @param ... A comma separated list of individual features
#'
#' @return A vector list each feature.
#'
#' @export
qm_define <- function(...){

  c(...)

}
