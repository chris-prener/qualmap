library(dplyr)   # data wrangling
library(sf)      # simple features objects
library(tigris)  # access census tiger/line data

library(leaflet)

stLouis <- tracts(state = "MO", county = 510)
stLouis <- st_as_sf(stLouis)
stLouis <- mutate(stLouis, TRACTCE = as.numeric(TRACTCE))


clusterE <- qm_define(118600, 119101, 800000)

qm_validate(ref = stLouis, key = "TRACTCE", value = clusterE)

cluster1 <- qm_define(118600, 119101, 119300)

qm_validate(ref = stLouis, key = "TRACTCE", value = cluster1)
qm_validate(ref = stLouis, key = TRACTCE, value = cluster1)

qm_preview(stLouis, "TRACTCE", cluster1)

qm_preview(stLouis, TRACTCE, cluster1)

cluster1_obj <- qm_create(ref = stLouis, key = TRACTCE, value = cluster1, rid = 1, cid = 1, category = "positive")

cluster1_obj <- qm_create(stLouis, TRACTCE, cluster1, rid = 1, cid = 1, category = "positive")


cluster2 <- qm_define(119300, 121100, 121200)

qm_validate(stLouis, "TRACTCE", cluster2)

qm_preview(stLouis, "TRACTCE", cluster2)

cluster2_obj <- qm_create(stLouis, "TRACTCE", cluster2, rid = 1, cid = 2, category = "positive")



cluster3 <- qm_define(118600, 119101, 119300)

qm_validate(stLouis, "TRACTCE", cluster3)

qm_preview(stLouis, "TRACTCE", cluster3)

cluster3_obj <- qm_create(stLouis, "TRACTCE", cluster3, rid = 1, cid = 3, category = "negative")

clusters <- qm_combine(cluster1_obj, cluster2_obj, cluster3_obj)


pos <- qm_summarize(clusters = clusters, key = TRACTCE, category = "positive")

possf <- qm_summarize(clusters = clusters, key = TRACTCE, category = "positive", ref = stLouis)

library(ggplot2)
library(viridis)

ggplot() + geom_sf(data = possf, mapping = aes(fill = positive)) + scale_fill_viridis()

ggsave("man/figures/exampleMap.png")
