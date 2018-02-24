context("test cluster define")

# test data ------------------------------------------------

test_cluster1 <- qm_define(118600, 119101, 800000)

result_cluster1 <- c(118600, 119101, 800000)

# test results ------------------------------------------------

test_that("creating clusters", {
  expect_equal(test_cluster1, result_cluster1)
})

test_that("clusters are vectors", {
  expect_equal(is.vector(test_cluster1), TRUE)
})
