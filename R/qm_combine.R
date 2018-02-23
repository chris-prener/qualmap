#' Combine objects
#'
#' @description A wrapper around \code{dplyr::bind_rows} for combining cluster objects into a single tibble.
#'
#' @param ... A list of cluster objects to be combined.
#'
#' @return A single tibble with all observations from the listed cluster objects.
#'
#' @importFrom dplr bind_rows
#'
#' @export
qm_combine <- function(...){

  dplyr::bind_rows(...)

}
