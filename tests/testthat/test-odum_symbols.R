# Low-level ESL vertex helpers — geometry follows Wikipedia's
# Energese chart (commons.wikimedia.org/wiki/File:Energese.jpg).

test_that("odum_circle returns closed circular polygon", {
  p <- odum_circle(0, 0, 1, id = "c1", n = 40)
  expect_s3_class(p, "tbl_df")
  expect_named(p, c("x", "y", "id"))
  expect_equal(nrow(p), 40)
  expect_equal(p$x[1], p$x[nrow(p)], tolerance = 1e-9)
  expect_equal(p$y[1], p$y[nrow(p)], tolerance = 1e-9)
  expect_equal(max(abs(p$x)), 1, tolerance = 0.01)
  expect_equal(max(abs(p$y)), 1, tolerance = 0.01)
})

test_that("odum_source is an alias for odum_circle", {
  a <- odum_circle(1, 2, 0.5, id = "s1", n = 20)
  b <- odum_source(1, 2, 0.5, id = "s1", n = 20)
  expect_equal(a, b)
})

test_that("odum_storage is a Bertalanffy module (flat top, rounded bottom)", {
  p <- odum_storage(0, 0, 1.0, 1.0, id = "st1", n = 20)
  # Bounding: x in ±0.5, y in ±0.5
  expect_lte(max(p$x), 0.5 + 1e-9)
  expect_gte(min(p$x), -0.5 - 1e-9)
  expect_equal(max(p$y), 0.5, tolerance = 1e-9)      # flat top at y = h/2
  # The first two vertices are the flat top corners (both at y = 0.5)
  expect_equal(p$y[1], 0.5, tolerance = 1e-9)
  expect_equal(p$y[2], 0.5, tolerance = 1e-9)
  # Bottom is rounded — has multiple y-values near the bottom
  bot_ys <- p$y[p$y < -0.3]
  expect_gt(length(bot_ys), 3)
})

test_that("odum_consumer is a regular hexagon (left+right points)", {
  p <- odum_consumer(0, 0, 2, 1, id = "c1")
  expect_equal(nrow(p), 7)   # 6 vertices + closing
  expect_equal(min(p$x), -1); expect_equal(max(p$x), 1)
})

test_that("odum_interaction is a right-pointing chevron (not a diamond)", {
  p <- odum_interaction(0, 0, 1, 1, id = "i1")
  # Left edge is a flat vertical segment (two vertices with x = -0.5,
  # y = ±0.5). Right edge tapers to a single point (x = +0.5, y = 0).
  left_edge <- p[abs(p$x + 0.5) < 1e-9, ]
  right_tip <- p[abs(p$x - 0.5) < 1e-9, ]
  expect_gte(nrow(left_edge), 2)     # flat left side
  expect_equal(nrow(right_tip), 1)   # single pointed tip
  expect_equal(right_tip$y, 0)       # tip is horizontally centered
})

test_that("odum_producer is a rounded-right rectangle (bullet)", {
  p <- odum_producer(0, 0, 2, 1, id = "p1", n = 20)
  # Left edge flat: two vertices with x = -1
  left_edge <- p[abs(p$x + 1) < 1e-9, ]
  expect_gte(nrow(left_edge), 3)
  # Right edge extends to x = +1 (rounded cap, n=20 discretisation)
  expect_equal(max(p$x), 1, tolerance = 0.01)
})

test_that("odum_switch is a bowtie: two separate triangles", {
  p <- odum_switch(0, 0, 1, 1, id = "sw1")
  # Two ids: "sw1_L" and "sw1_R"
  expect_setequal(unique(p$id), c("sw1_L", "sw1_R"))
  expect_equal(sum(p$id == "sw1_L"), 4)   # 3 vertices + closing
  expect_equal(sum(p$id == "sw1_R"), 4)
  # Each triangle spans half of the width
  expect_equal(min(p$x[p$id == "sw1_L"]), -0.5)
  expect_equal(max(p$x[p$id == "sw1_L"]),  0)
  expect_equal(min(p$x[p$id == "sw1_R"]),  0)
  expect_equal(max(p$x[p$id == "sw1_R"]),  0.5)
})

test_that("odum_self_limiter is a semi-circle facing left", {
  p <- odum_self_limiter(0, 0, 1, 1, id = "sl1", n = 30)
  # Flat edge at x = 0 (the two endpoints of the arc)
  # Arc extends to the left (x <= 0)
  expect_lte(max(p$x), 0 + 1e-6)
  expect_gte(min(p$x), -0.5 - 0.01)
})

test_that("odum_heat_sink returns arrow polygon + ground attribute", {
  a <- odum_heat_sink(0, 0, 1, 1, id = "h1")
  expect_s3_class(a, "tbl_df")
  expect_true(!is.null(attr(a, "ground")))
  g <- attr(a, "ground")
  # Ground is a horizontal segment at y = cy - h/2
  expect_equal(g$y[1], g$y[2])
  expect_equal(g$y[1], -0.5, tolerance = 1e-9)
})

test_that("odum_transaction is an elongated horizontal diamond", {
  p <- odum_transaction(0, 0, 2, 0.6, id = "t1")
  expect_equal(nrow(p), 5)   # 4 vertices + closing
  # Left/right tips at (±1, 0); top/bottom tips at (0, ±0.3)
  expect_true(any(abs(p$x + 1) < 1e-9 & abs(p$y) < 1e-9))
  expect_true(any(abs(p$x - 1) < 1e-9 & abs(p$y) < 1e-9))
  expect_true(any(abs(p$x) < 1e-9 & abs(p$y + 0.3) < 1e-9))
  expect_true(any(abs(p$x) < 1e-9 & abs(p$y - 0.3) < 1e-9))
})

test_that("odum_money aliases odum_circle", {
  a <- odum_circle(1, 2, 0.5, id = "m1", n = 20)
  b <- odum_money(1, 2, 0.5, id = "m1", n = 20)
  expect_equal(a, b)
})

test_that("odum_flow is a right-pointing arrow (shaft + head)", {
  p <- odum_flow(0, 0, 2, 1, id = "f1")
  # Right tip at x = +1
  expect_equal(max(p$x), 1, tolerance = 1e-9)
  # Left flat edge at x = -1
  expect_equal(min(p$x), -1, tolerance = 1e-9)
  # Arrow head widens beyond shaft
  head_ys <- p$y[abs(p$x - (1 - 0.6)) < 1e-9]
  expect_gte(length(head_ys), 2)
})
