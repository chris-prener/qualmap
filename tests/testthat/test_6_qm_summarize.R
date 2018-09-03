context("test cluster summarize")

# test data ------------------------------------------------

test_sf <- stLouis
test_sf <- dplyr::mutate(test_sf, TRACTCE = as.numeric(TRACTCE))

cluster1 <- qm_define(118600, 119101, 119300)
cluster1_obj <- qm_create(ref = test_sf, key = TRACTCE, value = cluster1, rid = 1, cid = 1, category = "positive")

cluster2 <- qm_define(119300, 121200, 121100)
cluster2_obj <- qm_create(ref = test_sf, key = TRACTCE, value = cluster2, rid = 1, cid = 2, category = "positive")

cluster3 <- qm_define(119300, 118600, 119101)
cluster3_obj <- qm_create(ref = test_sf, key = TRACTCE, value = cluster3, rid = 1, cid = 3, category = "negative")

clusters <- qm_combine(cluster1_obj, cluster2_obj, cluster3_obj)
clusters2 <- dplyr::rename(clusters, TRACT = TRACTCE)

test_tbl <- as_tibble(data.frame(
  x = c(1,2,3),
  y = c("a", "b", "a")
))

# test inputs ------------------------------------------------

# test missing ref parameter
expect_error(qm_summarize(key = TRACTCE, clusters = clusters, category = "positive"),
             "A reference, consisting of a simple features object, must be specified.")

# test no sf ref parameter
expect_error(qm_summarize(ref = test_tbl, key = TRACTCE, clusters = clusters, category = "positive"),
             "The reference object must be a simple features object.")

# test missing key parameter
expect_error(qm_summarize(ref = test_sf, clusters = clusters, category = "positive"),
             "A key identification variable must be specified.")

# test incorrect key parameter
expect_error(qm_summarize(ref = test_sf, key = "ham", clusters = clusters, category = "positive"),
             "The specified key ham cannot be found in the reference data.")
expect_error(qm_summarize(ref = test_sf, key = ham, clusters = clusters, category = "positive"),
             "The specified key ham cannot be found in the reference data.")
expect_error(qm_summarize(ref = test_sf, key = "TRACTCE", clusters = clusters2, category = "positive"),
             "The specified key TRACTCE cannot be found in the clusters data.")
expect_error(qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters2, category = "positive"),
             "The specified key TRACTCE cannot be found in the clusters data.")

# test missing clusters parameter
expect_error(qm_summarize(ref = test_sf, key = TRACTCE, category = "postitive"),
             "A data set containing map clusters must be specified.")

# test non qm_cluster object input
expect_error(qm_summarize(ref = test_sf, key = TRACTCE, clusters = test_tbl, category = "positive"),
             "The object test_tbl is not class qm_cluster. The cluster object should be created with qm_combine().", fixed = TRUE)

# test missing category parameter
expect_error(qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters),
             "A category from the cluster object must be specified.")

# test incorrect category parameter
expect_error(qm_summarize(ref = test_sf, key = "TRACTCE", clusters = clusters, category = "ham"),
             "The specified category ham cannot be found in the clusters data.")
expect_error(qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, category = ham),
             "The specified category ham cannot be found in the clusters data.")

# test for incorrect geometry parameter
expect_error(qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, category = positive, geometry = "TRUE"),
             "The geometry parameter only accepts TRUE or FALSE as arguments.")

# test for incorrect use.na parameter
expect_error(qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, category = positive, use.na = "TRUE"),
             "The use.na parameter only accepts TRUE or FALSE as arguments.")

# test results ------------------------------------------------

resultV1 <- qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, category = "positive", geometry = TRUE, use.na = FALSE)
resultV1b <- qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, category = "positive")

nrowV1 <- 106
posV1 <- 0.05660377
classListV1 <- class(resultV1)
classListElementV1 <- classListV1[1]

test_that("result object 1 has expected characteristics", {
  expect_equal(nrowV1, nrow(resultV1))
  expect_equal(posV1, mean(resultV1$positive))
  expect_equal("sf", classListElementV1)
  expect_equal(resultV1, resultV1b)
})

resultV2 <- qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, category = "positive", geometry = TRUE, use.na = TRUE)

nrowV2 <- 106
posV2 <- 1.2
classListV2 <- class(resultV2)
classListElementV2 <- classListV2[1]

test_that("result object 2 has expected characteristics", {
  expect_equal(nrowV2, nrow(resultV2))
  expect_equal(posV2, mean(resultV2$positive, na.rm = TRUE))
  expect_equal("sf", classListElementV2)
})

resultV3 <- qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, category = "positive", geometry = FALSE, use.na = FALSE)

nrowV3 <- 5
posV3 <- 1.2
classListV3 <- class(resultV3)
classListElementV3 <- classListV3[1]

test_that("result object 3 has expected characteristics", {
  expect_equal(nrowV3, nrow(resultV3))
  expect_equal(posV3, mean(resultV3$positive))
  expect_equal("tbl_df", classListElementV3)
})
