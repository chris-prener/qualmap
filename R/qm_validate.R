#' Validate input vector
#'
#' @description This function ensures that the input vector values match valid values in a source shapefile.
#'
#' @param ref An sf object that serves as a master list of features
#' @param key Name of geographic id variable in the \code{ref} object to match input values to
#' @param value A vector of input values
#'
#' @return A logical scalar that is \code{TRUE} is all input values match values in the key variable.
#'
#' @export
qm_validate <- function(ref, key, value){

  # save parameters to list
  paramList <- as.list(match.call())

  # quote input variables - key
  keyVarQ <- rlang::quo_name(rlang::enquo(key))

  # compare values from value variable with values in key variable
  value %in% ref[[noquote(keyVarQ)]] -> result

  # confirm that all comparisons were TRUE
  all(result) -> test

  # return test result
  return(test)

}
