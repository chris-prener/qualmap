#' Create cluster object
#'
#' @param ref An sf object that serves as a master list of features
#' @param key Quoted name of id variable in the \code{ref} object to match input values to
#' @param value A vector of input values
#' @param ... An unquoted list of variables from the sf object to include in the out
#'
#' @return A tibble with the cluster values merged with elements of the key data.
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

  COUNT = NULL

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
