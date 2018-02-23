#' Summarize Clusters
#'
#' @description This function creates a column that contains a single observation for each unique value
#' in the key variable. For each feature, a count corresponding to the number of times that feature is
#' identified in a cluster for the give category is also provided.
#'
#' @param clusters A tibble created by \code{qm_create} with two or more clusters worth of data
#' @param key Name of geographic id variable in the tibble specified in \code{clusters}
#' @param category Value of the \code{CAT} variable to be analyzed
#' @param ref Optional sf object; a join will be performed between the sf object and the summarized clusters
#'
#' @return A tibble or a sf object (if \code{ref} is specified) that contains a count of the number of clusters
#' a given feature is included in.
#'
#' @seealso qm_create
#'
#' @import sf
#' @importFrom dplyr filter
#' @importFrom dplyr group_by
#' @importFrom dplyr left_join
#' @importFrom dplyr mutate
#' @importFrom dplyr n
#' @importFrom dplyr rename
#' @importFrom dplyr summarize
#' @importFrom rlang :=
#'
#' @export
qm_summarize <- function(clusters, key, category, ref){

  # define undefined global variables as NULL
  CAT = COUNT = NULL

  # save parameters to list
  paramList <- as.list(match.call())

  # check for missing parameters - clusters
  if (missing(clusters)) {
    stop('A data set containing map clusters must be specified.')
  }

  # check for missing parameters - key
  if (missing(key)) {
    stop('A key identification variable must be specified.')
  }

  # check for missing parameters - key
  if (missing(category)) {
    stop('A single category value must be specified.')
  }

  # quote input variables - key
  if (!is.character(paramList$key)) {
    keyVar <- rlang::enquo(key)
  } else if (is.character(paramList$key)) {
    keyVar <- rlang::quo(!! rlang::sym(key))
  }

  keyVarQ <- rlang::quo_name(rlang::enquo(key))

  # quote input variables - category
  if (!is.character(paramList$category)) {
    categoryVar <- rlang::enquo(category)
  } else if (is.character(paramList$category)) {
    categoryVar <- rlang::quo(!! rlang::sym(category))
  }

  categoryVarQ <- rlang::quo_name(rlang::enquo(category))

  # filter, group, and summarize
  clusters %>%
    dplyr::filter(CAT == category) %>%
    dplyr::group_by(!!keyVar) %>%
    dplyr::summarize(COUNT := dplyr::n()) -> result

  result <- dplyr::rename(result, !!categoryVarQ := COUNT)

  # add geometry
  if (!missing(ref)){

    result <- dplyr::left_join(ref, result, by = keyVarQ)

    result <- dplyr::mutate(result, !!categoryVarQ := ifelse(is.na(!!categoryVar) == TRUE, 0, !!categoryVar))

  }

  # return result
  return(result)

}
