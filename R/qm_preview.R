#' Preview Input
#'
#' @description This function renders the input vector as a polygon shapefile using the leaflet package.
#'
#' @param .data An sf object
#' @param key Quoted name of id variable to match input values to
#' @param value A vector of input values
#'
#' @return An interactive leaflet map with the values from the input vector highlighted in red.
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr left_join
#' @importFrom dplyr mutate
#' @importFrom dplyr rename
#' @importFrom grDevices colorRamp
#' @importFrom leaflet addPolygons
#' @importFrom leaflet addProviderTiles
#' @importFrom leaflet colorBin
#' @importFrom leaflet leaflet
#' @importFrom rlang :=
#' @importFrom sf st_transform
#'
#' @export
qm_preview <- function(.data, key, value){

  COUNT = NULL

  keyQ <- rlang::quo_name(rlang::enquo(key))

  value_df <- as.data.frame(value)

  value_df %>%
    dplyr::rename(!!keyQ := value) %>%
    dplyr::mutate(COUNT = 1) -> value_df

  result <- dplyr::left_join(.data, value_df, by = key)

  result <- dplyr::mutate(result, COUNT = ifelse(is.na(COUNT) == TRUE, 0, COUNT))
  result <- sf::st_transform(result, 4326)

  bins <- c(0, 1)
  pal <- leaflet::colorBin(colorRamp(c("#808080", "#ff4e4e")), domain = result$COUNT)
  tiles <- leaflet::providers$CartoDB.Positron

  leaflet::leaflet(result) %>%
    leaflet::addProviderTiles(tiles) %>%
    leaflet::addPolygons(fillColor = ~pal(COUNT),
                            weight = 2,
                            opacity = 1,
                            color = "white",
                            dashArray = "3",
                            fillOpacity = 0.7)
}



