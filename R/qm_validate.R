#' Validate input vector
#'
#' @description This function ensures that the input vector values match valid values in a source shapefile.
#'
#' @param .data An sf object
#' @param key Quoted name of id variable to match input values to
#' @param value A vector of input values
#'
#' @return A logical scalar that is \code{TRUE} is all input values match values in the key variable.
#'
#' @importFrom assertthat assert_that
#'
#' @export
qm_validate <- function(.data, key, value){

  # compare values from value variable with values in key variable
  value %in% .data[[key]] -> result

  # confirm that all comparisons were TRUE
  assertthat::assert_that(all(result) == TRUE) -> test

  # return test result
  return(test)

}
