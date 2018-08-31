context("test cluster create")

# test data ------------------------------------------------

test_cluster <- qm_define(118600, 119101, 119300)
test_clusterE <- qm_define(222222, 119101, 119300)
test_clusterE2 <- qm_define("118600", "119101", "119300")

test_sf <- stLouis
test_sf <- dplyr::mutate(test_sf, TRACTCE = as.numeric(TRACTCE))

test_tbl <- as_tibble(data.frame(
  x = c(1,2,3),
  y = c("a", "b", "a")
))

test_tbl2 <- as_tibble(data.frame(
  RID = c(1,1,1),
  CID = c(1,1,1),
  CAT = c("positive", "positive", "positive"),
  TRACTCE = c(119300, 118600, 119101),
  COUNT = c(1,1,1),
  stringsAsFactors = FALSE
))

test_tbl2 %>%
  dplyr::mutate(RID = as.integer(RID)) %>%
  dplyr::mutate(CID = as.integer(CID)) -> test_tbl2

test_tbl3 <- as_tibble(data.frame(
  RID = c(1,1,1),
  CID = c(1,1,1),
  CAT = c("positive", "positive", "positive"),
  TRACTCE = c(119300, 118600, 119101),
  COUNT = c(1,1,1),
  NAME = c("1193", "1186", "1191.01"),
  stringsAsFactors = FALSE
))

test_tbl3 %>%
  dplyr::mutate(RID = as.integer(RID)) %>%
  dplyr::mutate(CID = as.integer(CID)) -> test_tbl3

# test inputs ------------------------------------------------

# test missing ref parameter
expect_error(qm_create(key = "TRACTCE", value = test_cluster, rid = 1, cid = 1, category = "test"),
             "A reference, consisting of a simple features object, must be specified.")

# test ambiguous ref parameter
expect_error(qm_create("TRACTCE", test_cluster, 1, 1, "test"),
             "The reference object must be a simple features object.")

# test no sf ref parameter
expect_error(qm_create(ref = test_tbl, key = "TRACTCE", value = test_cluster, rid = 1, cid = 1, category = "test"),
             "The reference object must be a simple features object.")

# test missing key parameter
expect_error(qm_create(ref = test_sf, value = test_cluster, rid = 1, cid = 1, category = "test"),
             "A key identification variable must be specified.")

# test incorrect key parameter
expect_error(qm_create(ref = test_sf, key = "test", value = test_cluster, rid = 1, cid = 1, category = "test"),
             "Error in data validation: Use qualmap::qm_validate() to diagnose the problem.", fixed = TRUE)
expect_error(qm_create(ref = test_sf, key = test, value = test_cluster, rid = 1, cid = 1, category = "test"),
             "Error in data validation: Use qualmap::qm_validate() to diagnose the problem.", fixed = TRUE)

# test missing value parameter
expect_error(qm_create(ref = test_sf, key = "TRACTCE", rid = 1, cid = 1, category = "test"),
             "A vector containing feature ids must be specified.")

# test incorrect value parameter
expect_error(qm_create(ref = test_sf, key = "TRACTCE", value = test_clusterE, rid = 1, cid = 1, category = "test"),
             "Error in data validation: Use qualmap::qm_validate() to diagnose the problem.", fixed = TRUE)
expect_error(qm_create(ref = test_sf, key = "TRACTCE", value = test_clusterE2, rid = 1, cid = 1, category = "test"),
             "Error in data validation: Use qualmap::qm_validate() to diagnose the problem.", fixed = TRUE)

# test missing rid parameter
expect_error(qm_create(ref = test_sf, key = "TRACTCE", value = test_cluster, cid = 1, category = "test"),
             "A respondent identification number (rid) must be specified.", fixed = TRUE)

# test misspecified rid parameter
expect_error(qm_create(ref = test_sf, key = "TRACTCE", value = test_cluster, rid = "ham", cid = 1, category = "test"),
             "The respondent identification number (rid) must a numeric value.", fixed = TRUE)
expect_error(qm_create(ref = test_sf, key = "TRACTCE", value = test_cluster, rid = TRUE, cid = 1, category = "test"),
             "The respondent identification number (rid) must a numeric value.", fixed = TRUE)

# test missing cid parameter
expect_error(qm_create(ref = test_sf, key = "TRACTCE", value = test_cluster, rid = 1, category = "test"),
             "A cluster identification number (cid) must be specified.", fixed = TRUE)

# test misspecified cid parameter
expect_error(qm_create(ref = test_sf, key = "TRACTCE", value = test_cluster, rid = 1, cid = "ham", category = "test"),
             "The cluster identification number (cid) must a numeric value.", fixed = TRUE)
expect_error(qm_create(ref = test_sf, key = "TRACTCE", value = test_cluster, rid = 1, cid = TRUE, category = "test"),
             "The cluster identification number (cid) must a numeric value.", fixed = TRUE)

# test missing category parameter
expect_error(qm_create(ref = test_sf, key = "TRACTCE", value = test_cluster, rid = 1, cid = 1),
             "A category for this cluster must be specified.")

# test misspecified cid parameter
expect_error(qm_create(ref = test_sf, key = "TRACTCE", value = test_cluster, rid = 1, cid = 1, category = 1),
             "The category must a string.")
expect_error(qm_create(ref = test_sf, key = "TRACTCE", value = test_cluster, rid = 1, cid = 1, category = TRUE),
             "The category must a string.")

# test results ------------------------------------------------

resultV1 <- qm_create(ref = test_sf, key = "TRACTCE", value = test_cluster, rid = 1, cid = 1, category = "positive")
resultV2 <- qm_create(ref = test_sf, key = TRACTCE, value = test_cluster, rid = 1, cid = 1, category = "positive")

test_that("returns TRUE - test result 1 matches test_tbl2", {
  expect_equal(resultV1, test_tbl2)
})

test_that("returns TRUE - test result 2 matches test_tbl2", {
  expect_equal(resultV2, test_tbl2)
})

resultV3 <- qm_create(ref = test_sf, key = "TRACTCE", value = test_cluster, rid = 1, cid = 1, category = "positive", NAME)

test_that("returns TRUE - test result 3 matches test_tbl3", {
  expect_equal(resultV3, test_tbl3)
})
