context("test cluster create")

# test data ------------------------------------------------

test_cluster <- qm_define(118600, 119101, 119300)

test_sf <- stLouis

test_tbl <- as_tibble(data.frame(
  x = c(1,2,3),
  y = c("a", "b", "a")
))

#created_cluster <- qm_create(ref = test_sf, key = "TRACTCE", value = test_cluster,
#                             rid = 1, cid = 1, category = "test")

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
             "`by` can't contain join column `test` which is missing from LHS") # this error message is not helpful

# test missing value parameter
expect_error(qm_create(ref = test_sf, key = "TRACTCE", rid = 1, cid = 1, category = "test"),
             "A vector containing feature ids must be specified.")

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

