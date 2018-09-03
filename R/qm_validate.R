#' Validate input vector
#'
#' @description This function ensures that the input vector values match valid values in a source shapefile.
#'
#' @usage qm_validate(ref, key, value)
#'
#' @param ref An \code{sf} object that serves as a master list of features
#' @param key Name of geographic id variable in the \code{ref} object to match input values to
#' @param value A vector of input values created with \code{qm_define}
#'
#' @return A logical scalar that is \code{TRUE} is all input values match values in the key variable.
#'
#' @seealso qm_define
#'
#' @examples
#' # load and format reference data
#' stl <- stLouis
#' stl <- dplyr::mutate(stl, TRACTCE = as.numeric(TRACTCE))
#'
#' # create clusters
#' clusterValid <- qm_define(118600, 119101, 119300)
#' clusterError <- qm_define(118600, 119101, 800000)
#'
#' # validate clusters
#' qm_validate(ref = stl, key = TRACTCE, value = clusterValid)
#'
#' qm_validate(ref = stl, key = TRACTCE, value = clusterError)
#'
#' @importFrom glue glue
#'
#' @export
qm_validate <- function(ref, key, value){

  # save parameters to list
  paramList <- as.list(match.call())

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

  # quote input variables - value
  valueVarQ <- rlang::quo_name(rlang::enquo(value))

  # quote input variables - key
  if (!is.character(paramList$key)) {
    keyVar <- rlang::enquo(key)
  } else if (is.character(paramList$key)) {
    keyVar <- rlang::quo(!! rlang::sym(key))
  }

  keyVarQ <- rlang::quo_name(rlang::enquo(key))

  # check to see if key exists in ref data
  refCols <- colnames(ref)

  keyVarQ %in% refCols -> keyExists

  if (keyExists == FALSE){
    stop(glue('The specified key {keyVarQ} cannot be found in the reference data.'))
  }

  # check class of key value and compare to class of values vector
  keyRefList <- class(ref[[keyVarQ]])
  keyRefListElement1 <- keyRefList[1]

  valueList <- class(value)
  valueListElement1 <- valueList[1]

  if (keyRefListElement1 != valueListElement1){
    stop(glue('Mismatch in class between {keyVarQ} ({keyRefListElement1}) and {valueVarQ} ({valueListElement1}). These must be the same class to create cluster object.'))
  }

  # compare values from value variable with values in key variable
  value %in% ref[[noquote(keyVarQ)]] -> result

  # confirm that all comparisons were TRUE
  all(result) -> test

  # return test result
  return(test)

}
