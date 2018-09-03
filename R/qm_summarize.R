#' Summarize Clusters
#'
#' @description This function creates a column that contains a single observation for each unique value
#' in the key variable. For each feature, a count corresponding to the number of times that feature is
#' identified in a cluster for the give category is also provided.
#'
#' @usage qm_summarize(ref, key, clusters, category)
#'
#' @param ref An \code{sf} object that serves as a master list of features
#' @param key Name of geographic id variable in the \code{ref} object to match input values to
#' @param clusters A tibble created by \code{qm_combine} with two or more clusters worth of data
#' @param category Value of the \code{CAT} variable to be analyzed
#'
#' @return A tibble or a \code{sf} object (if geometry = \code{TRUE}) that contains a count of the number
#' of clusters a given feature is included in.
#'
#' @seealso \code{qm_combine}
#'
#' @examples
#' # load and format reference data
#' stl <- stLouis
#' stl <- dplyr::mutate(stl, TRACTCE = as.numeric(TRACTCE))
#'
#' # create clusters
#' cluster1 <- qm_define(118600, 119101, 119300)
#' cluster2 <- qm_define(119300, 121200, 121100)
#'
#' # create cluster objects
#' cluster_obj1 <- qm_create(ref = stl, key = TRACTCE, value = cluster1,
#'     rid = 1, cid = 1, category = "positive")
#' cluster_obj2 <- qm_create(ref = stl, key = TRACTCE, value = cluster2,
#'     rid = 1, cid = 2, category = "positive")
#'
#' # combine cluster objects
#' clusters <- qm_combine(cluster_obj1, cluster_obj2)
#'
#' # summarize cluster objects
#' positive <- qm_summarize(ref = stl, key = TRACTCE, clusters = clusters, category = "positive")
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
