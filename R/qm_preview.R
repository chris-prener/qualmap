#' Preview Input
#'
#' @description This function renders the input vector as a polygon shapefile using the leaflet package.
#'
#' @param ref An sf object that serves as a master list of features
#' @param key Name of geographic id variable in the \code{ref} object to match input values to
#' @param value A vector of input values
#'
#' @return An interactive leaflet map with the values from the input vector highlighted in red.
#'
#' @import sf
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
qm_preview <- function(ref, key, value){

  # define undefined global variables as NULL
  COUNT = NULL

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

  # prepare temporary data frame for mapping
  value_df %>%
    dplyr::rename(!!keyVarQ := value) %>%
    dplyr::mutate(COUNT = 1) -> value_df

  # join temp data frame to reference data
  result <- dplyr::left_join(ref, value_df, by = keyVarQ)

  # add 0 values to COUNT if NA
  result <- dplyr::mutate(result, COUNT = ifelse(is.na(COUNT) == TRUE, 0, COUNT))

  # transform data to WGS 84
  result <- sf::st_transform(result, 4326)

  # set leaflet variables
  bins <- c(0, 1)
  pal <- leaflet::colorBin(colorRamp(c("#808080", "#ff4e4e")), domain = result$COUNT)
  tiles <- leaflet::providers$CartoDB.Positron

  # create map
  leaflet::leaflet(result) %>%
    leaflet::addProviderTiles(tiles) %>%
    leaflet::addPolygons(fillColor = ~pal(COUNT),
                            weight = 2,
                            opacity = 1,
                            color = "white",
                            dashArray = "3",
                            fillOpacity = 0.7)
}



