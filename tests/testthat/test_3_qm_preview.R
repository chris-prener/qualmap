context("test cluster preview")

# test data ------------------------------------------------

test_cluster <- qm_define(118600, 119101, 800000)

test_sf <- stLouis
test_sf <- dplyr::mutate(test_sf, TRACTCE = as.numeric(TRACTCE))

# test inputs ------------------------------------------------

# test result ------------------------------------------------

resultV1 <- qm_preview(ref = test_sf, key = TRACTCE, value = test_cluster)

classV1 <- class(resultV1)

test_that("result objects has expected characteristics", {
  expect_equal("leaflet", classV1[[1]])
})
