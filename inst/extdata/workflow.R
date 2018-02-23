library(dplyr)   # data wrangling
library(sf)      # simple features objects
library(tigris)  # access census tiger/line data

library(leaflet)

stLouis <- tracts(state = "MO", county = 510)
stLouis <- st_as_sf(stLouis)
stLouis <- mutate(stLouis, TRACTCE = as.numeric(TRACTCE))

cluster1 <- c(118600, 119101, 119300)

qm_validate(stLouis, "TRACTCE", cluster1)

qm_preview(stLouis, "TRACTCE", cluster1)

cluster1_obj <- qm_create(stLouis, "TRACTCE", cluster1, rid = 1, cid = 1, category = "ham", GEOID)


cluster2 <- c(119300, 121100, 121200)

qm_validate(stLouis, "TRACTCE", cluster2)

qm_preview(stLouis, "TRACTCE", cluster2)

cluster2_obj <- qm_create(stLouis, "TRACTCE", cluster2, rid = 1, cid = 2, category = "ham", GEOID)
