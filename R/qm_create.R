#' Create cluster object
#'
#' @description Each vector of input values is converted to a tibble organized in a "tidy" fashion.
#'
#' @details A cluster object contains a row for each feature in the reference data set. The \code{key} variable
#' values are included in a variable named identically to the \code{key}. Additionally, a variable called
#' \code{COUNT} is created. This will always be equal to \code{1} for each observation. It is intended to be
#' used for summarization later in the data analysis process. Finally, three pieces of metadata are also included
#' as arguments to provide data for subsetting later: a respondent identification number (\code{rid}), a
#' cluster identification number (\code{cid}), and a category for the cluster type (\code{category}). These
#' arguments are converted into values for the output variables \code{RID}, \code{CID}, and \code{CAT} respectively.
#' Input data for \code{qm_create} are validated using \code{qm_validate} as part of the cluster object
#' creation process.
#'
#' @usage qm_create(ref, key, value, rid, cid, category, ...)
#'
#' @param ref An \code{sf} object that serves as a master list of features
#' @param key Name of geographic id variable in the \code{ref} object to match input values to
#' @param value A vector of input values created with \code{qm_define}
#' @param rid Respondent identification number; a user defined integer value that uniquely identifies respondents
#' in the project
#' @param cid Cluster identification number; a user defined integer value that uniquely identifies clusters
#' @param category Category type; a user defined value that describes what the cluster represents
#' @param ... An unquoted list of variables from the sf object to include in the output
#'
#' @return A tibble with the cluster values merged with elements of the reference data. This tibble is stored with
#' a custom class of \code{qm_cluster} to facilitate data validation.
#'
#' @seealso qm_define
#'
#' @examples
#' # load and format reference data
#' stl <- stLouis
#' stl <- dplyr::mutate(stl, TRACTCE = as.numeric(TRACTCE))
#'
#' # create cluster
#' cluster <- qm_define(118600, 119101, 119300)
#'
#' # create simple cluster object
#' cluster_obj1 <- qm_create(ref = stl, key = TRACTCE, value = cluster,
#'     rid = 1, cid = 1, category = "positive")
#'
#' # create cluster object with additional variables added from reference data
#' cluster_obj2 <- qm_create(ref = stl, key = TRACTCE, value = cluster,
#'     rid = 1, cid = 1, category = "positive", NAME, NAMELSAD)
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr as_tibble
#' @importFrom dplyr left_join
#' @importFrom dplyr mutate
#' @importFrom dplyr rename
#' @importFrom glue glue
#' @importFrom rlang :=
#' @importFrom sf st_geometry
#'
#' @export
qm_create <- function(ref, key, value, rid, cid, category, ...) {

  # define undefined global variables as NULL
  RID = CID = CAT = COUNT = is = NULL

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

  # check for missing parameters - rid
  if (missing(rid)) {
    stop('A respondent identification number (rid) must be specified.')
  }

  # check input type - rid
  if (is.numeric(rid) != TRUE) {
    stop('The respondent identification number (rid) must a numeric value.')
  }

  # check for missing parameters - cid
  if (missing(cid)) {
    stop('A cluster identification number (cid) must be specified.')
  }

  # check input type - cid
  if (is.numeric(cid) != TRUE) {
    stop('The cluster identification number (cid) must a numeric value.')
  }

  # check for missing parameters - category
  if (missing(category)) {
    stop('A category for this cluster must be specified.')
  }

  # check input type - category
  if (is.character(category) != TRUE) {
    stop('The category must a string.')
  }

  # quote input variables - key
  if (!is.character(paramList$key)) {
    keyVar <- rlang::enquo(key)
  } else if (is.character(paramList$key)) {
    keyVar <- rlang::quo(!! rlang::sym(key))
  }

  keyVarQ <- rlang::quo_name(rlang::enquo(key))

  # validate data
  valid <- tryCatch(qm_validate(ref = ref, key = (!!keyVar), value = value), error = function(e) e, warning = function(w) w)

  if(is(valid, "error") == TRUE) {
    stop("Error in data validation: Use qualmap::qm_validate() to diagnose the problem.")
  } else if (valid == FALSE) {
    stop("Error in data validation: Use qualmap::qm_validate() to diagnose the problem.")
  }

  # convert vector to temporary data frame
  value_df <- as.data.frame(value)

  # prepare temporary data frame for join
  value_df %>%
    dplyr::rename(!!keyVarQ := value) %>%
    dplyr::mutate(COUNT = 1) -> value_df

  # join temp data frame to reference data
  result <- dplyr::left_join(ref, value_df, by = keyVarQ)

  # subset joined data down to only valid observations & requested variables, add metadata variables
  result %>%
    dplyr::filter(COUNT == 1) %>%
    dplyr::mutate(RID = as.integer(rid)) %>%
    dplyr::mutate(CID = as.integer(cid)) %>%
    dplyr::mutate(CAT = category) %>%
    dplyr::select(RID, CID, CAT, !!keyVarQ, COUNT, ...) -> result

  # remove geometry
  sf::st_geometry(result) <- NULL

  # convert result to a tibble
  result <- as_tibble(result)

  # add new class
  class(result) <- append(class(result), "qm_cluster")

  # return result
  return(result)

}
