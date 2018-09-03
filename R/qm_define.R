#' Define input values
#'
#' @description A wrapper around \code{c()} that is used for constructing vectors of individual feature values.
#' Each output should correspond to a single cluster on the respondent's map.
#'
#' @usage qm_define(...)
#'
#' @param ... A comma separated list of individual features
#'
#' @return A vector list each feature.
#'
#' @examples
#' cluster <- qm_define(118600, 119101, 119300)
#'
#' @export
qm_define <- function(...){

  # concatenate listed values
  c(...)

}
