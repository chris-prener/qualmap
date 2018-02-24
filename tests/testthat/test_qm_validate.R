context("test cluster validate")

# test data ------------------------------------------------

test_clusterE <- qm_define(118600, 119101, 800000)
test_clusterV <- qm_define(118600, 119101, 119300)

test_sf <- stLouis

# test results ------------------------------------------------

resultE <- qm_validate(ref = test_sf, key = "TRACTCE", value = test_clusterE)
resultV <- qm_validate(ref = test_sf, key = "TRACTCE", value = test_clusterV)

test_that("clusters are vectors", {
  expect_equal(resultE, FALSE)
})

test_that("clusters are vectors", {
  expect_equal(resultV, TRUE)
})
