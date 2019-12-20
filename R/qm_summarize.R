#' Summarize Clusters
#'
#' @description This function creates a column that contains a single observation for each unique value
#' in the key variable. For each feature, a count corresponding to the number of times that feature is
#' identified in a cluster for the give category is also provided.
#'
#' @usage qm_summarize(ref, key, clusters, category, count, geometry = TRUE, use.na = FALSE)
#'
#' @param ref An \code{sf} object that serves as a master list of features
#' @param key Name of geographic id variable in the \code{ref} object to match input values to
#' @param clusters A tibble created by \code{qm_combine} with two or more clusters worth of data
#' @param category Value of the \code{CAT} variable to be analyzed
#' @param count How should clusters be summarized: by counting each time a feature is included
#'     in a cluster (\code{"clusters"}) or by counting the number of respondents
#'     (\code{"respondents"}) who associated a feature with the given category.
#' @param geometry A logical scalar that returns the full geometry and attributes of \code{ref}
#'     when \code{TRUE} (default). If \code{FALSE}, only the \code{key} and count of features is
#'     returned after validation.
#' @param use.na A logical scalar that returns \code{NA} values in the count variable if a feature
#'     is not included in any clusters when \code{TRUE}. If \code{FALSE} (default), a \code{0} value
#'     is returned in the count variable for each feature that is not included in any clusters. This
#'     parameter only impacts output if the \code{geometry} argument is \code{TRUE}.
#'
#' @return A tibble or a \code{sf} object (if geometry = \code{TRUE}) that contains a count of the number
#' of clusters a given feature is included in. The tibble option (when \code{geometry = FALSE}) will only
#' return valid features. The \code{sf} option (default; when \code{geometry = TRUE}) will return all
#' features with either zeros (when \code{use.na = FALSE}) or \code{NA} values (when \code{use.na = TRUE})
#' for features not included in any clusters.
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
#' positive1 <- qm_summarize(ref = stl, key = TRACTCE, clusters = clusters, category = "positive",
#'     count = "clusters")
#' class(positive1)
#' mean(positive1$positive)
#'
#' # summarize cluster objects with NA's instead of 0's
#' positive2 <- qm_summarize(ref = stl, key = TRACTCE, clusters = clusters, category = "positive",
#'     count = "clusters", use.na = TRUE)
#' class(positive2)
#' mean(positive2$positive, na.rm = TRUE)
#'
#' # return tibble of valid features only
#' positive3 <- qm_summarize(ref = stl, key = TRACTCE, clusters = clusters, category = "positive",
#'     count = "clusters", geometry = FALSE)
#' class(positive3)
#' mean(positive3$positive)
#'
#' # count respondents instead of clusters
#' positive4 <- qm_summarize(ref = stl, key = TRACTCE, clusters = clusters, category = "positive",
#'     count = "respondents")
#' mean(positive4$positive)
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
qm_summarize <- function(ref, key, clusters, category, count, geometry = TRUE, use.na = FALSE){

  # define undefined global variables as NULL
  RID = CAT = COUNT = NULL

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

  # check for missing parameters - count
  if (missing(count)) {
    stop("A method for producing counts, either 'clusters' or 'respondents', must be specified.")
  }

  # check for incorrect parameters - count
  if (count %in% c("clusters", "respondents") == FALSE){
    stop("Counts only accepts 'clusters' or 'respondents' as arguments.")
  }

  # check for missing parameters - geometry
  if (missing(geometry)) {
    geometry <- TRUE
  }

  # check for incorrect parameters - geometry
  if (!is.logical(geometry)) {
    stop('The geometry parameter only accepts TRUE or FALSE as arguments.')
  }

  # check for missing parameters - use.na
  if (missing(use.na)) {
    use.na <- FALSE
  }

  # check for incorrect parameters - use.na
  if (!is.logical(use.na)) {
    stop('The use.na parameter only accepts TRUE or FALSE as arguments.')
  }

  # quote input variables - key
  if (!is.character(paramList$key)) {
    keyVar <- rlang::enquo(key)
  } else if (is.character(paramList$key)) {
    keyVar <- rlang::quo(!! rlang::sym(key))
  }

  keyVarQ <- rlang::quo_name(rlang::enquo(key))

  # check to see if key exists in ref data
  if (keyVarQ %in% colnames(ref) == FALSE){
    stop(glue('The specified key {keyVarQ} cannot be found in the reference data.'))
  }

  # check to see if key exists in clusters data
  if (keyVarQ %in% colnames(clusters) == FALSE){
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
  if (categoryVarQ %in% clusters$CAT == FALSE){
    stop(glue('The specified category {categoryVarQ} cannot be found in the clusters data.'))
  }

  # subset
  clusters <- dplyr::filter(clusters, CAT == category)

  # summarize
  if (count == "clusters"){

    # will return the number of clusters that included each feature for the given category
    clusters <- dplyr::group_by(clusters, !!keyVar)
    clusters <- dplyr::summarize(clusters, !!categoryVarQ := n())
    # clusters <- dplyr::summarize(clusters, COUNT := n())
    # clusters <- dplyr::rename(clusters, !!categoryVarQ := COUNT)

  } else if (count == "respondents"){

    # will return the number of respondents that associated a feature with the category
    clusters <- dplyr::distinct(clusters, RID, CAT, !!keyVar)
    clusters <- dplyr::group_by(clusters, !!keyVar)
    clusters <- dplyr::summarize(clusters, !!categoryVarQ := n())

  }

  # add geometry
  if (geometry == TRUE) {
    clusters <- dplyr::left_join(ref, clusters, by = keyVarQ)
  }

  # replace zeros with missing
  if (use.na == FALSE) {
    clusters <- dplyr::mutate(clusters, !!categoryVarQ := ifelse(is.na(!!categoryVar) == TRUE, 0, !!categoryVar))
  }

  # return result
  return(clusters)

}
