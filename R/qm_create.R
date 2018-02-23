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
#'
#' @usage qm_create(ref, key, value, rid, cid, category, ...)
#'
#' @param ref An sf object that serves as a master list of features
#' @param key Quoted name of id variable in the \code{ref} object to match input values to
#' @param value A vector of input values
#' @param rid Respondent identification number; a user defined value that uniquely identifies respondents
#' in the project
#' @param cid Cluster identification number; a user defined value that unqiuely identifies clusters
#' @param category Category type; a user defined value that describes what the cluster represents
#' @param ... An unquoted list of variables from the sf object to include in the out
#'
#' @return A tibble with the cluster values merged with elements of the reference data.
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr as_tibble
#' @importFrom dplyr left_join
#' @importFrom dplyr mutate
#' @importFrom dplyr rename
#' @importFrom rlang :=
#' @importFrom sf st_geometry
#'
#' @export
qm_create <- function(ref, key, value, rid, cid, category, ...) {

  RID = CID = CAT = COUNT = NULL

  keyQ <- rlang::quo_name(rlang::enquo(key))

  value_df <- as.data.frame(value)

  value_df %>%
    dplyr::rename(!!keyQ := value) %>%
    dplyr::mutate(COUNT = 1) -> value_df

  result <- dplyr::left_join(ref, value_df, by = key)

  result %>%
    dplyr::filter(COUNT == 1) %>%
    dplyr::mutate(RID = rid) %>%
    dplyr::mutate(CID = cid) %>%
    dplyr::mutate(CAT = category) %>%
    dplyr::select(RID, CID, CAT, !!keyQ, COUNT, ...) -> result

  sf::st_geometry(result) <- NULL

  result <- as_tibble(result)

  return(result)

}
