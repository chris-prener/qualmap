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

  # check for missing parameters - ref
  if (missing(ref)) {
    stop('A reference, consisting of a simple features object, must be specified.')
  }

  # check class of reference object
  classList <- class(ref)
  classListElement1 <- classList[1]

  if (classListElement1 != "sf"){
    stop("The reference object must be a simple features object.")
  }

  # check for missing parameters - key
  if (missing(key)) {
    stop('A key identification variable must be specified.')
  }

  # check for missing parameters - value
  if (missing(value)) {
    stop('A vector containing feature ids must be specified.')
  }

  # save parameters to list
  paramList <- as.list(match.call())

  # quote input variables - value
  valueQ <- rlang::quo_name(rlang::enquo(value))

  # quote input variables - key
  keyVarQ <- rlang::quo_name(rlang::enquo(key))

  # check class of key value and compare to class of values vector
  keyRefList <- class(ref[[keyVarQ]])
  keyRefListElement1 <- keyRefList[1]

  valueList <- class(value)
  valueListElement1 <- valueList[1]

  if (keyRefListElement1 != valueListElement1){
    stop(glue('Mismatch in class between {keyVarQ} ({keyRefListElement1}) and {valueQ} ({valueListElement1}). These must be the same class to create cluster object.'))
  }

  # compare values from value variable with values in key variable
  value %in% ref[[noquote(keyVarQ)]] -> result

  # confirm that all comparisons were TRUE
  all(result) -> test

  # return test result
  return(test)

}
