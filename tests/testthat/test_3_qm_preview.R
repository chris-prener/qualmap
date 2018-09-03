context("test cluster preview")

# test data ------------------------------------------------

test_cluster <- qm_define(118600, 119101, 119300)
test_clusterE <- qm_define(222222, 119101, 119300)
test_clusterE2 <- qm_define("118600", "119101", "119300")

test_sf <- stLouis
test_sf <- dplyr::mutate(test_sf, TRACTCE = as.numeric(TRACTCE))

test_tbl <- dplyr::as_tibble(data.frame(
  x = c(1,2,3),
  y = c("a", "b", "a")
))

# test inputs ------------------------------------------------

# test missing ref parameter
expect_error(qm_preview(key = "TRACTCE", value = test_cluster),
             "A reference, consisting of a simple features object, must be specified.")

# test ambiguous ref parameter
expect_error(qm_preview("TRACTCE", test_cluster),
             "The reference object must be a simple features object.")

# test no sf ref parameter
expect_error(qm_preview(ref = test_tbl, key = "TRACTCE", value = test_cluster),
             "The reference object must be a simple features object.")

# test missing key parameter
expect_error(qm_preview(ref = test_sf, value = test_cluster),
             "A key identification variable must be specified.")

# test incorrect key parameter
expect_error(qm_preview(ref = test_sf, key = "test", value = test_cluster),
             "Error in data validation: Use qualmap::qm_validate() to diagnose the problem.", fixed = TRUE)
expect_error(qm_preview(ref = test_sf, key = test, value = test_cluster),
             "Error in data validation: Use qualmap::qm_validate() to diagnose the problem.", fixed = TRUE)

# test missing value parameter
expect_error(qm_preview(ref = test_sf, key = "TRACTCE"),
             "A vector containing feature ids must be specified.")

# test incorrect value parameter
expect_error(qm_preview(ref = test_sf, key = "TRACTCE", value = test_clusterE),
             "Error in data validation: Use qualmap::qm_validate() to diagnose the problem.", fixed = TRUE)
expect_error(qm_preview(ref = test_sf, key = "TRACTCE", value = test_clusterE2),
             "Error in data validation: Use qualmap::qm_validate() to diagnose the problem.", fixed = TRUE)


# test result ------------------------------------------------

resultV1 <- qm_preview(ref = test_sf, key = TRACTCE, value = test_cluster)

classV1 <- class(resultV1)

test_that("result objects has expected characteristics", {
  expect_equal("leaflet", classV1[[1]])
})
