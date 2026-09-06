# ggproto Geoms build valid ggplot layers.
library(ggplot2)

df <- data.frame(x = c(0, 3, 6, 9, 12, 15, 18), y = 0)

test_that("all geom_odum_* return valid ggplot Layer objects", {
  layers <- list(
    geom_odum_source(data = df[1, ], mapping = aes(x = x, y = y)),
    geom_odum_producer(data = df[2, ], mapping = aes(x = x, y = y)),
    geom_odum_consumer(data = df[3, ], mapping = aes(x = x, y = y)),
    geom_odum_storage(data = df[4, ], mapping = aes(x = x, y = y)),
    geom_odum_interaction(data = df[5, ], mapping = aes(x = x, y = y)),
    geom_odum_heat_sink(data = df[6, ], mapping = aes(x = x, y = y)),
    geom_odum_money(data = df[7, ], mapping = aes(x = x, y = y))
  )
  for (l in layers) expect_s3_class(l, "Layer")
})

test_that("composing all seven Geoms in one ggplot builds without error", {
  p <- ggplot() +
    geom_odum_source(data = df[1, ], aes(x = x, y = y)) +
    geom_odum_producer(data = df[2, ], aes(x = x, y = y)) +
    geom_odum_consumer(data = df[3, ], aes(x = x, y = y)) +
    geom_odum_storage(data = df[4, ], aes(x = x, y = y)) +
    geom_odum_interaction(data = df[5, ], aes(x = x, y = y)) +
    geom_odum_heat_sink(data = df[6, ], aes(x = x, y = y)) +
    geom_odum_money(data = df[7, ], aes(x = x, y = y)) +
    theme_void()
  # ggplot_build shouldn't raise
  b <- ggplot_build(p)
  expect_s3_class(b, "ggplot_built")
  # We should have 7 data layers
  expect_length(b$data, 7)
  # Each layer's rendered data should have polygon vertices
  for (i in seq_along(b$data)) expect_gt(nrow(b$data[[i]]), 0)
})

test_that("aes(fill, width, height) work per row (vectorised)", {
  d <- data.frame(x = c(0, 2, 4), y = 0,
                  fill = c("#F1C40F", "#228B22", "#C0392B"))
  p <- ggplot() +
    geom_odum_producer(data = d, aes(x = x, y = y, fill = I(fill)),
                       width = 1.5, height = 0.8)
  expect_s3_class(ggplot_build(p), "ggplot_built")
})

test_that("aesthetic defaults are sensible (no warnings on bare mapping)", {
  # Warnings should not fire for missing width/height — they come from default_aes
  expect_silent(
    ggplot() + geom_odum_producer(data = df, aes(x = x, y = y)) +
    theme_void()
  )
})
