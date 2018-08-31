load_all()
x <- mutate(stLouis, TRACTCE = as.numeric(TRACTCE))

cluster1 <- qm_define(118600, 119101, 119300)
qm_validate(ref = x, key = TRACTCE, value = cluster1)

cluster1_obj <- qm_create(ref = x, key = TRACTCE, value = cluster1, rid = 1, cid = 1, category = "positive")

cluster2 <- qm_define(119300, 121200, 121100)
qm_validate(ref = x, key = TRACTCE, value = cluster2)

cluster2_obj <- qm_create(ref = x, key = TRACTCE, value = cluster2, rid = 1, cid = 2, category = "positive")

cluster3 <- qm_define(119300, 118600, 119101)
qm_validate(ref = x, key = TRACTCE, value = cluster3)

cluster3_obj <- qm_create(ref = x, key = TRACTCE, value = cluster3, rid = 1, cid = 3, category = "negative")
cluster4_obj <- qm_create(ref = x, key = TRACTCE, value = cluster3, rid = 1, cid = 3, category = "negative", NAME)

class(cluster1_obj)
class(cluster2_obj)
class(cluster3_obj)
class(cluster4_obj)

clusters <- qm_combine(cluster1_obj, cluster2_obj, cluster3_obj)

clusters <- qm_combine(cluster1_obj, cluster2_obj, cluster3_obj, cluster4_obj)
