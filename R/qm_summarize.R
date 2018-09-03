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
#' @importFrom glue glue
#' @importFrom rlang :=
#'
#' @export
qm_summarize <- function(ref, key, clusters, category){

  # define undefined global variables as NULL
  CAT = COUNT = NULL

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

  # check for missing parameters - clusters
  if (missing(clusters)) {
    stop('A data set containing map clusters must be specified.')
  }

  clustersQ <- rlang::quo_name(rlang::enquo(clusters))

  # test class value to ensure that they are class qm_cluster
  if (qm_is_cluster(clusters) == FALSE) {
    stop(glue('The object {clustersQ} is not class qm_cluster. The cluster object should be created with qm_combine().'))
  }

  # check for missing parameters - category
  if (missing(category)) {
    stop('A category from the cluster object must be specified.')
  }

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

  # check to see if key exists in clusters data
  clusterCols <- colnames(clusters)

  keyVarQ %in% clusterCols -> keyExistsC

  if (keyExistsC == FALSE){
    stop(glue('The specified key {keyVarQ} cannot be found in the clusters data.'))
  }

  # quote input variables - category
  if (!is.character(paramList$category)) {
    categoryVar <- rlang::enquo(category)
  } else if (is.character(paramList$category)) {
    categoryVar <- rlang::quo(!! rlang::sym(category))
  }

  categoryVarQ <- rlang::quo_name(rlang::enquo(category))

  # check to see if category exists in clusters data
  categoryVarQ %in% clusters$CAT -> catExists

  if (catExists == FALSE){
    stop(glue('The specified category {categoryVarQ} cannot be found in the clusters data.'))
  }

  # filter, group, and summarize
  clusters %>%
    dplyr::filter(CAT == category) %>%
    dplyr::group_by(!!keyVar) %>%
    dplyr::summarize(COUNT := n()) -> result

  result <- dplyr::rename(result, !!categoryVarQ := COUNT)

  # add geometry
  result <- dplyr::left_join(ref, result, by = keyVarQ)

  result <- dplyr::mutate(result, !!categoryVarQ := ifelse(is.na(!!categoryVar) == TRUE, 0, !!categoryVar))

    # return result
  return(result)

}
