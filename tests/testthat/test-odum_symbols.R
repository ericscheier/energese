# Low-level helpers return correct-shape polygons.

test_that("odum_circle returns closed circle polygon", {
  p <- odum_circle(0, 0, 1, id = "c1", n = 40)
  expect_s3_class(p, "tbl_df")
  expect_named(p, c("x", "y", "id"))
  expect_equal(nrow(p), 40)
  # First and last point coincide (closed loop)
  expect_equal(p$x[1], p$x[nrow(p)], tolerance = 1e-9)
  expect_equal(p$y[1], p$y[nrow(p)], tolerance = 1e-9)
  # Centered at (0,0), radius 1 → max |x|, |y| close to 1 (n=40 discretisation)
  expect_equal(max(abs(p$x)), 1, tolerance = 0.01)
  expect_equal(max(abs(p$y)), 1, tolerance = 0.01)
})

test_that("odum_producer returns bullet-nosed hexagon (6 unique + closing)", {
  p <- odum_producer(0, 0, 2, 1, id = "p1")
  expect_equal(nrow(p), 6)          # 5 unique vertices + closing repeat
  # Rightmost vertex is the "nose"
  expect_equal(max(p$x), 1, tolerance = 1e-9)
  # Bottom-left at (-1, -0.5); top-left at (-1, 0.5)
  expect_true(any(p$x == -1 & p$y == -0.5))
  expect_true(any(p$x == -1 & p$y ==  0.5))
})

test_that("odum_consumer returns hexagon with left+right pointed vertices", {
  p <- odum_consumer(0, 0, 2, 1, id = "c1")
  expect_equal(nrow(p), 7)  # 6 unique vertices + closing
  # Leftmost + rightmost at (±1, 0)
  expect_equal(min(p$x), -1); expect_equal(max(p$x), 1)
})

test_that("odum_storage has flat left + rounded right end", {
  p <- odum_storage(0, 0, 2, 1, id = "s1", n = 10)
  # First point (bottom-left) and last (closing to start) at x = -1
  expect_equal(p$x[1], -1, tolerance = 1e-9)
  # Right-arc caps out at x = w/2 = 1 (discretised, small tolerance)
  expect_equal(max(p$x), 1, tolerance = 0.01)
})

test_that("odum_interaction is a diamond", {
  p <- odum_interaction(0, 0, 2, id = "i1")
  expect_equal(nrow(p), 5)   # 4 unique + closing
  # Vertices at (0, ±1), (±1, 0)
  expect_true(any(p$x == 0 & p$y == 1))
  expect_true(any(p$x == 0 & p$y == -1))
  expect_true(any(p$x == 1 & p$y == 0))
  expect_true(any(p$x == -1 & p$y == 0))
})

test_that("odum_heat_sink is a down-pointing triangle", {
  p <- odum_heat_sink(0, 0, 1, id = "h1")
  expect_equal(nrow(p), 4)   # 3 unique + closing
  # Bottom vertex points down (y = -1)
  expect_equal(min(p$y), -1, tolerance = 1e-9)
  expect_equal(max(p$y), 0, tolerance = 1e-9)
})

test_that("odum_money aliases odum_circle", {
  a <- odum_circle(1, 2, 0.5, id = "m1", n = 20)
  b <- odum_money(1, 2, 0.5, id = "m1", n = 20)
  expect_equal(a, b)
})
