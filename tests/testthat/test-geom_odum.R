# ggproto Geoms build valid ggplot layers — 10 canonical symbols.
library(ggplot2)

df <- data.frame(x = 1:10, y = 0)

test_that("all 10 geom_odum_* return valid ggplot Layer objects", {
  layers <- list(
    geom_odum_source     (data = df[1,],  mapping = aes(x = x, y = y)),
    geom_odum_flow       (data = df[2,],  mapping = aes(x = x, y = y)),
    geom_odum_storage    (data = df[3,],  mapping = aes(x = x, y = y)),
    geom_odum_consumer   (data = df[4,],  mapping = aes(x = x, y = y)),
    geom_odum_interaction(data = df[5,],  mapping = aes(x = x, y = y)),
    geom_odum_producer   (data = df[6,],  mapping = aes(x = x, y = y)),
    geom_odum_switch     (data = df[7,],  mapping = aes(x = x, y = y)),
    geom_odum_self_limiter(data = df[8,], mapping = aes(x = x, y = y)),
    geom_odum_heat_sink  (data = df[9,],  mapping = aes(x = x, y = y)),
    geom_odum_transaction(data = df[10,], mapping = aes(x = x, y = y))
  )
  for (l in layers) expect_s3_class(l, "Layer")
})

test_that("composing all ten Geoms in one ggplot builds without error", {
  p <- ggplot() +
    geom_odum_source     (data = df[1,],  aes(x = x, y = y)) +
    geom_odum_flow       (data = df[2,],  aes(x = x, y = y)) +
    geom_odum_storage    (data = df[3,],  aes(x = x, y = y)) +
    geom_odum_consumer   (data = df[4,],  aes(x = x, y = y)) +
    geom_odum_interaction(data = df[5,],  aes(x = x, y = y)) +
    geom_odum_producer   (data = df[6,],  aes(x = x, y = y)) +
    geom_odum_switch     (data = df[7,],  aes(x = x, y = y)) +
    geom_odum_self_limiter(data = df[8,], aes(x = x, y = y)) +
    geom_odum_heat_sink  (data = df[9,],  aes(x = x, y = y)) +
    geom_odum_transaction(data = df[10,], aes(x = x, y = y)) +
    theme_void()
  b <- ggplot_build(p)
  expect_s3_class(b, "ggplot_built")
  expect_length(b$data, 10)
  for (i in seq_along(b$data)) expect_gt(nrow(b$data[[i]]), 0)
})

test_that("vectorised aesthetics work per row", {
  d <- data.frame(x = c(0, 2, 4), y = 0,
                  fill = c("#F1C40F", "#228B22", "#C0392B"))
  p <- ggplot() +
    geom_odum_producer(data = d, aes(x = x, y = y, fill = I(fill)),
                       width = 1.5, height = 0.8)
  expect_s3_class(ggplot_build(p), "ggplot_built")
})

test_that("plot_energese_reference() produces a valid ggplot", {
  p <- plot_energese_reference()
  expect_s3_class(p, "ggplot")
  b <- ggplot_build(p)
  expect_s3_class(b, "ggplot_built")
  # Should have many layers (bg + banner + 10 symbols + labels + text)
  expect_gt(length(b$data), 10)
})
