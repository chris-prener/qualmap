library(devtools)  # package building
library(dplyr)     # data wrangling
library(sf)        # simple features objects
library(tigris)    # access census tiger/line data

stLouis <- tracts(state = "MO", county = 510)
stLouis <- st_as_sf(stLouis)

stLouis <- select(stLouis, STATEFP, COUNTYFP, TRACTCE, GEOID, NAME, NAMELSAD)

use_data(stLouis, overwrite = TRUE)
