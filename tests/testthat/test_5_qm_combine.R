context("test cluster combine")

# test data ------------------------------------------------

test_sf <- stLouis
test_sf <- dplyr::mutate(test_sf, TRACTCE = as.numeric(TRACTCE))

cluster1 <- qm_define(118600, 119101, 119300)
cluster1_obj <- qm_create(ref = test_sf, key = TRACTCE, value = cluster1, rid = 1, cid = 1, category = "positive")
cluster4a_obj <- qm_create(ref = test_sf, key = TRACTCE, value = cluster1, rid = 1, cid = 1, category = "positive", NAMELSAD)
cluster4b_obj <- qm_create(ref = test_sf, key = TRACTCE, value = cluster1, rid = 1, cid = 1, category = "positive", NAME)

cluster2 <- qm_define(119300, 121200, 121100)
cluster2_obj <- qm_create(ref = test_sf, key = TRACTCE, value = cluster2, rid = 1, cid = 2, category = "positive")
cluster5_obj <- qm_create(ref = test_sf, key = TRACTCE, value = cluster2, rid = 1, cid = 2, category = "positive", NAME)

cluster3 <- qm_define(119300, 118600, 119101)

cluster3_obj <- qm_create(ref = test_sf, key = TRACTCE, value = cluster3, rid = 1, cid = 3, category = "negative")
cluster6_obj <- qm_create(ref = test_sf, key = TRACTCE, value = cluster3, rid = 1, cid = 3, category = "negative", NAME)

test_obj <- dplyr::tibble(
  RID = c(1,1,1),
  CID = c(1,1,1),
  TRACTCE = c(119300, 118600, 119101)
)

test_obj %>%
  dplyr::mutate(RID = as.integer(RID)) %>%
  dplyr::mutate(CID = as.integer(CID)) -> test_obj

test_obj2 <- dplyr::tibble(
  RID = c(1,1,1,1,1,1,1,1,1),
  CID = c(1,1,1,2,2,2,3,3,3),
  CAT = c("positive", "positive", "positive", "positive", "positive", "positive", "negative", "negative", "negative"),
  TRACTCE = c(119300, 118600, 119101, 119300, 121200, 121100, 119300, 118600, 119101)
)

test_obj2 %>%
  dplyr::mutate(RID = as.integer(RID)) %>%
  dplyr::mutate(CID = as.integer(CID)) -> test_obj2

test_obj3 <- dplyr::tibble(
  RID = c(1,1,1,1,1,1,1,1,1),
  CID = c(1,1,1,2,2,2,3,3,3),
  CAT = c("positive", "positive", "positive", "positive", "positive", "positive", "negative", "negative", "negative"),
  TRACTCE = c(119300, 118600, 119101, 119300, 121200, 121100, 119300, 118600, 119101),
  NAME = c("1193", "1186", "1191.01", "1193", "1212", "1211", "1193", "1186", "1191.01")
)

test_obj3 %>%
  dplyr::mutate(RID = as.integer(RID)) %>%
  dplyr::mutate(CID = as.integer(CID)) -> test_obj3

# test inputs ------------------------------------------------

# test non qm_cluster object input
expect_error(qm_combine(cluster1_obj, cluster2_obj, test_obj),
             "One or more of the given objects is not a cluster object. Use qm_is_cluster() to evaluate each object.", fixed = TRUE)

# test column number equality
expect_error(qm_combine(cluster1_obj, cluster2_obj, cluster6_obj),
             "The number of columns is not equal across all clusters.")

# test column name differences
expect_error(qm_combine(cluster4a_obj, cluster5_obj, cluster6_obj),
             "The given objects do not have identical sets of columns.")

# test results ------------------------------------------------

clustersV1 <- qm_combine(cluster1_obj, cluster2_obj, cluster3_obj)

test_that("returns TRUE - test result 1 matches test_tbl2", {
  expect_equal(clustersV1, test_obj2, check.attributes = FALSE)
})

clustersV2 <- qm_combine(cluster4b_obj, cluster5_obj, cluster6_obj)

test_that("returns TRUE - test result 2 matches test_tbl3", {
  expect_equal(clustersV2, test_obj3, check.attributes = FALSE)
})

objV1 <- qm_is_cluster(clustersV1)
objV2 <- qm_is_cluster(clustersV2)

test_that("result objects have cluster characteristics", {
  expect_equal(objV1, TRUE)
  expect_equal(objV2, TRUE)
})
