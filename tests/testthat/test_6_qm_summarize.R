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

test_tbl <- dplyr::tibble(
  x = c(1,2,3),
  y = c("a", "b", "a")
)

# test inputs ------------------------------------------------

# test missing ref parameter
expect_error(qm_summarize(key = TRACTCE, clusters = clusters, category = "positive", count = "clusters"),
             "A reference, consisting of a simple features object, must be specified.")

# test no sf ref parameter
expect_error(qm_summarize(ref = test_tbl, key = TRACTCE, clusters = clusters, category = "positive",
                          count = "clusters"),
             "The reference object must be a simple features object.")

# test missing key parameter
expect_error(qm_summarize(ref = test_sf, clusters = clusters, category = "positive", count = "clusters"),
             "A key identification variable must be specified.")

# test incorrect key parameter
expect_error(qm_summarize(ref = test_sf, key = "ham", clusters = clusters, category = "positive",
                          count = "clusters"),
             "The specified key ham cannot be found in the reference data.")
expect_error(qm_summarize(ref = test_sf, key = ham, clusters = clusters, category = "positive",
                          count = "clusters"),
             "The specified key ham cannot be found in the reference data.")
expect_error(qm_summarize(ref = test_sf, key = "TRACTCE", clusters = clusters2, category = "positive",
                          count = "clusters"),
             "The specified key TRACTCE cannot be found in the clusters data.")
expect_error(qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters2, category = "positive",
                          count = "clusters"),
             "The specified key TRACTCE cannot be found in the clusters data.")

# test missing clusters parameter
expect_error(qm_summarize(ref = test_sf, key = TRACTCE, category = "postitive",
                          count = "clusters"),
             "A data set containing map clusters must be specified.")

# test non qm_cluster object input
expect_error(qm_summarize(ref = test_sf, key = TRACTCE, clusters = test_tbl, category = "positive",
                          count = "clusters"),
             "The object test_tbl is not a cluster object. Create a cluster object with qm_combine().", fixed = TRUE)

# test missing category parameter
expect_error(qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, count = "clusters"),
             "A category from the cluster object must be specified.")

# test incorrect category parameter
expect_error(qm_summarize(ref = test_sf, key = "TRACTCE", clusters = clusters, category = "ham",
                          count = "clusters"),
             "The specified category ham cannot be found in the clusters data.")
expect_error(qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, category = ham,
                          count = "clusters"),
             "The specified category ham cannot be found in the clusters data.")

# test missing count parameter
expect_error(qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, category = "postitive"),
             "A method for producing counts, either 'clusters' or 'respondents', must be specified.")

# test incorrect count parameter
expect_error(qm_summarize(ref = test_sf, key = "TRACTCE", clusters = clusters, category = "postitive",
                          count = "ham"),
             "Counts only accepts 'clusters' or 'respondents' as arguments.")

# test for incorrect geometry parameter
expect_error(qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, category = positive,
                          count = "clusters", geometry = "TRUE"),
             "The geometry parameter only accepts TRUE or FALSE as arguments.")

# test for incorrect use.na parameter
expect_error(qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, category = positive,
                          count = "clusters", use.na = "TRUE"),
             "The use.na parameter only accepts TRUE or FALSE as arguments.")

# test results ------------------------------------------------

resultV1 <- qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, category = "positive",
                         count = "clusters", geometry = TRUE, use.na = FALSE)
resultV1b <- qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, category = "positive",
                          count = "clusters")

nrowV1 <- 106
posV1 <- 0.05660377

test_that("result object 1 has expected characteristics", {
  expect_equal(nrowV1, nrow(resultV1))
  expect_equal(posV1, mean(resultV1$positive))
  expect_equal("sf" %in% class(resultV1), TRUE)
})

resultV2 <- qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, category = "positive",
                         count = "clusters", geometry = TRUE, use.na = TRUE)

nrowV2 <- 106
posV2 <- 1.2

test_that("result object 2 has expected characteristics", {
  expect_equal(nrowV2, nrow(resultV2))
  expect_equal(posV2, mean(resultV2$positive, na.rm = TRUE))
  expect_equal("sf" %in% class(resultV2), TRUE)
})

resultV3 <- qm_summarize(ref = test_sf, key = TRACTCE, clusters = clusters, category = "positive",
                         count = "clusters", geometry = FALSE, use.na = FALSE)

nrowV3 <- 5
posV3 <- 1.2

test_that("result object 3 has expected characteristics", {
  expect_equal(nrowV3, nrow(resultV3))
  expect_equal(posV3, mean(resultV3$positive))
  expect_equal("sf" %in% class(resultV3), FALSE)
})
