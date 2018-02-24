context("test cluster define")

# test data ------------------------------------------------

test_cluster1 <- qm_define(2134, 5234, 9484)

result_cluster1 <- c(2134, 5234, 9484)

# test results ------------------------------------------------

test_that("creating clusters", {
  expect_equal(test_cluster1, result_cluster1)
})
