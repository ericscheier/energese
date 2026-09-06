# =============================================================================
# geom_odum.R — proper ggplot2 Geoms for H.T. Odum's Energy Systems Language.
#
# Companion to the low-level odum_* helpers in R/odum_symbols.R (which
# return tibble of polygon vertices). These are the recommended user
# API: real ggproto Geoms with standard aes(x, y, w, h, fill, colour),
# vectorized over data rows, composable in a ggplot() pipeline like any
# other ggplot2 layer.
#
# Prior art: to our knowledge, there is no other R (or Python)
# grammar-of-graphics implementation of H.T. Odum's Energy Systems
# Language symbols. Closest peers are the abandoned Java EmSim (ODE
# integrator, no rendering API) and the sholtomaud/odum-energy-language
# TypeScript GUI editor. See emburden-site emergy.html Bundle-U note.
# =============================================================================

#' Odum ESL Geoms — ggplot2 layers for H.T. Odum's Energy Systems Language
#'
#' Draws the canonical Odum ESL symbols (source circle, producer
#' bullet-nosed hexagon, consumer hexagon, storage bullet-tank,
#' interaction diamond, heat-sink triangle, money-transaction circle)
#' as vectorized ggplot2 layers. Each symbol is placed at
#' \code{aes(x, y)} with size controlled by \code{width} + \code{height}
#' aesthetics, and takes the standard \code{fill}, \code{colour},
#' \code{alpha}, \code{linewidth} aesthetics.
#'
#' Under the hood each Geom expands its data rows into polygon vertices
#' via the low-level helpers (\code{\link{odum_producer}},
#' \code{\link{odum_consumer}}, etc.) and delegates to
#' \code{GeomPolygon} for drawing.
#'
#' @section Aesthetics:
#'   Required: \code{x}, \code{y}. Optional (with defaults):
#'   \code{width} (default 0.8), \code{height} (default 0.5),
#'   \code{fill} (default \code{"grey70"}), \code{colour} (default
#'   \code{"black"}), \code{alpha} (default 0.85), \code{linewidth}
#'   (default 0.35). \code{geom_odum_source} and
#'   \code{geom_odum_money} take a \code{radius} aesthetic instead
#'   of \code{width}/\code{height}.
#'
#' @param mapping,data,stat,position,na.rm,show.legend,inherit.aes,...
#'   Standard ggplot2 layer arguments.
#' @param n Number of vertices for curved symbols (source, storage,
#'   money — default 60/20/60 respectively).
#' @return A ggplot2 layer.
#' @examples
#' \dontrun{
#' library(ggplot2)
#' d <- data.frame(
#'   x = c(0, 3, 6, 9, 12),
#'   y = 0,
#'   role = c("source", "producer", "consumer", "storage", "interaction"),
#'   fill = c("#F1C40F", "#228B22", "#C0392B", "#1F77B4", "#F39C12"))
#' ggplot(d, aes(x = x, y = y, fill = I(fill))) +
#'   geom_odum_source(data = d[1, ], aes(radius = 0.4)) +
#'   geom_odum_producer(data = d[2, ], aes(width = 1.5, height = 0.8)) +
#'   geom_odum_consumer(data = d[3, ], aes(width = 1.5, height = 0.8)) +
#'   geom_odum_storage(data = d[4, ], aes(width = 1.5, height = 0.8)) +
#'   geom_odum_interaction(data = d[5, ], aes(width = 0.8, height = 0.8)) +
#'   coord_fixed() + theme_void()
#' }
#' @name geom_odum
NULL

# ─── Internal: build vertex tibble per row of data ─────────────────

.expand_odum <- function(data, gen_fn, ...) {
  # gen_fn: one of odum_producer/consumer/storage/interaction/heat_sink
  # — takes (cx, cy, w, h, id) and returns tibble of (x, y, id)
  out <- vector("list", nrow(data))
  for (i in seq_len(nrow(data))) {
    row <- data[i, , drop = FALSE]
    poly <- gen_fn(cx = row$x, cy = row$y,
                    w = row$width, h = row$height,
                    id = i, ...)
    # Attach every aesthetic (fill, colour, alpha, linewidth) from row
    poly$group <- i
    poly$fill <- row$fill
    poly$colour <- row$colour
    poly$alpha <- row$alpha
    poly$linewidth <- row$linewidth
    poly$PANEL <- row$PANEL
    out[[i]] <- poly
  }
  do.call(rbind, out)
}

.expand_odum_circle <- function(data, n = 60) {
  out <- vector("list", nrow(data))
  for (i in seq_len(nrow(data))) {
    row <- data[i, , drop = FALSE]
    r <- if (!is.null(row$radius)) row$radius else 0.3
    poly <- odum_circle(cx = row$x, cy = row$y, r = r, id = i, n = n)
    poly$group <- i
    poly$fill <- row$fill
    poly$colour <- row$colour
    poly$alpha <- row$alpha
    poly$linewidth <- row$linewidth
    poly$PANEL <- row$PANEL
    out[[i]] <- poly
  }
  do.call(rbind, out)
}

# ─── GeomOdumSource — filled circle ────────────────────────────────

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumSource <- ggplot2::ggproto("GeomOdumSource", ggplot2::GeomPolygon,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(radius = 0.3, fill = "#F1C40F",
                             colour = "black", alpha = 0.85,
                             linewidth = 0.35, subgroup = NULL),
  draw_panel = function(data, panel_params, coord, n = 60) {
    poly <- .expand_odum_circle(data, n = n)
    ggplot2::GeomPolygon$draw_panel(poly, panel_params, coord)
  },
  draw_key = ggplot2::draw_key_polygon
)

#' @rdname geom_odum
#' @export
geom_odum_source <- function(mapping = NULL, data = NULL,
                              stat = "identity", position = "identity",
                              ..., n = 60,
                              na.rm = FALSE, show.legend = NA,
                              inherit.aes = TRUE) {
  ggplot2::layer(
    geom = GeomOdumSource, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(n = n, na.rm = na.rm, ...))
}

# ─── GeomOdumProducer — bullet-nosed hexagon ───────────────────────

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumProducer <- ggplot2::ggproto("GeomOdumProducer", ggplot2::GeomPolygon,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(width = 0.8, height = 0.5, fill = "#228B22",
                             colour = "black", alpha = 0.85,
                             linewidth = 0.35, subgroup = NULL),
  draw_panel = function(data, panel_params, coord) {
    poly <- .expand_odum(data, odum_producer)
    ggplot2::GeomPolygon$draw_panel(poly, panel_params, coord)
  },
  draw_key = ggplot2::draw_key_polygon
)

#' @rdname geom_odum
#' @export
geom_odum_producer <- function(mapping = NULL, data = NULL,
                                stat = "identity", position = "identity",
                                ..., na.rm = FALSE, show.legend = NA,
                                inherit.aes = TRUE) {
  ggplot2::layer(
    geom = GeomOdumProducer, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...))
}

# ─── GeomOdumConsumer — hexagon ────────────────────────────────────

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumConsumer <- ggplot2::ggproto("GeomOdumConsumer", ggplot2::GeomPolygon,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(width = 0.8, height = 0.5, fill = "#C0392B",
                             colour = "black", alpha = 0.85,
                             linewidth = 0.35, subgroup = NULL),
  draw_panel = function(data, panel_params, coord) {
    poly <- .expand_odum(data, odum_consumer)
    ggplot2::GeomPolygon$draw_panel(poly, panel_params, coord)
  },
  draw_key = ggplot2::draw_key_polygon
)

#' @rdname geom_odum
#' @export
geom_odum_consumer <- function(mapping = NULL, data = NULL,
                                stat = "identity", position = "identity",
                                ..., na.rm = FALSE, show.legend = NA,
                                inherit.aes = TRUE) {
  ggplot2::layer(
    geom = GeomOdumConsumer, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...))
}

# ─── GeomOdumStorage — bullet-tank ─────────────────────────────────

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumStorage <- ggplot2::ggproto("GeomOdumStorage", ggplot2::GeomPolygon,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(width = 0.8, height = 0.5, fill = "#1F77B4",
                             colour = "black", alpha = 0.85,
                             linewidth = 0.35, subgroup = NULL),
  draw_panel = function(data, panel_params, coord, n = 20) {
    poly <- .expand_odum(data, function(cx, cy, w, h, id)
      odum_storage(cx, cy, w, h, id, n = n))
    ggplot2::GeomPolygon$draw_panel(poly, panel_params, coord)
  },
  draw_key = ggplot2::draw_key_polygon
)

#' @rdname geom_odum
#' @export
geom_odum_storage <- function(mapping = NULL, data = NULL,
                               stat = "identity", position = "identity",
                               ..., n = 20, na.rm = FALSE,
                               show.legend = NA, inherit.aes = TRUE) {
  ggplot2::layer(
    geom = GeomOdumStorage, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(n = n, na.rm = na.rm, ...))
}

# ─── GeomOdumInteraction — diamond ─────────────────────────────────

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumInteraction <- ggplot2::ggproto("GeomOdumInteraction", ggplot2::GeomPolygon,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(width = 0.5, height = 0.5, fill = "#F39C12",
                             colour = "black", alpha = 0.85,
                             linewidth = 0.35, subgroup = NULL),
  draw_panel = function(data, panel_params, coord) {
    poly <- .expand_odum(data, function(cx, cy, w, h, id)
      odum_interaction(cx, cy, mean(c(w, h)), id))
    ggplot2::GeomPolygon$draw_panel(poly, panel_params, coord)
  },
  draw_key = ggplot2::draw_key_polygon
)

#' @rdname geom_odum
#' @export
geom_odum_interaction <- function(mapping = NULL, data = NULL,
                                   stat = "identity", position = "identity",
                                   ..., na.rm = FALSE,
                                   show.legend = NA, inherit.aes = TRUE) {
  ggplot2::layer(
    geom = GeomOdumInteraction, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...))
}

# ─── GeomOdumHeatSink — down-triangle ──────────────────────────────

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumHeatSink <- ggplot2::ggproto("GeomOdumHeatSink", ggplot2::GeomPolygon,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(width = 0.35, height = 0.35, fill = "grey60",
                             colour = "black", alpha = 0.9,
                             linewidth = 0.35, subgroup = NULL),
  draw_panel = function(data, panel_params, coord) {
    poly <- .expand_odum(data, function(cx, cy, w, h, id)
      odum_heat_sink(cx, cy, mean(c(w, h)), id))
    ggplot2::GeomPolygon$draw_panel(poly, panel_params, coord)
  },
  draw_key = ggplot2::draw_key_polygon
)

#' @rdname geom_odum
#' @export
geom_odum_heat_sink <- function(mapping = NULL, data = NULL,
                                 stat = "identity", position = "identity",
                                 ..., na.rm = FALSE,
                                 show.legend = NA, inherit.aes = TRUE) {
  ggplot2::layer(
    geom = GeomOdumHeatSink, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...))
}

# ─── GeomOdumMoney — outlined circle (dashed strokes for the flow) ─

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumMoney <- ggplot2::ggproto("GeomOdumMoney", ggplot2::GeomPolygon,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(radius = 0.25, fill = NA,
                             colour = "#B5791B", alpha = 0.9,
                             linewidth = 0.4, subgroup = NULL),
  draw_panel = function(data, panel_params, coord, n = 60) {
    poly <- .expand_odum_circle(data, n = n)
    ggplot2::GeomPolygon$draw_panel(poly, panel_params, coord)
  },
  draw_key = ggplot2::draw_key_polygon
)

#' @rdname geom_odum
#' @export
geom_odum_money <- function(mapping = NULL, data = NULL,
                             stat = "identity", position = "identity",
                             ..., n = 60, na.rm = FALSE,
                             show.legend = NA, inherit.aes = TRUE) {
  ggplot2::layer(
    geom = GeomOdumMoney, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(n = n, na.rm = na.rm, ...))
}
