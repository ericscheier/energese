# =============================================================================
# geom_odum.R — ggplot2 Geoms for H.T. Odum's Energy Systems Language.
#
# 10 canonical symbols per Wikipedia's Energese reference chart
# (https://commons.wikimedia.org/wiki/File:Energese.jpg):
#
#   geom_odum_source()        — filled circle
#   geom_odum_flow()          — bare right-pointing arrow
#   geom_odum_storage()       — Bertalanffy module (flat top, rounded bottom)
#   geom_odum_consumer()      — regular hexagon
#   geom_odum_interaction()   — right-pointing chevron / arrow-pentagon
#   geom_odum_producer()      — rounded rectangle with pointed right end
#   geom_odum_switch()        — bowtie / hourglass
#   geom_odum_self_limiter()  — semi-circle (arc left, flat right)
#   geom_odum_heat_sink()     — down-arrow terminating at a ground line
#   geom_odum_transaction()   — elongated diamond, money node
#
# Each takes standard ggplot2 aesthetics (x, y, fill, colour, alpha,
# linewidth) + a geometry aesthetic (width + height for polygonal
# symbols; radius for source/money). Vectorised over data rows.
# Delegates rendering to ggplot2::GeomPolygon after computing per-row
# vertices via .expand_odum().
# =============================================================================

#' Odum ESL Geoms — ggplot2 layers for H.T. Odum's Energy Systems Language
#'
#' A family of ten \code{ggplot2} Geoms that draw the canonical
#' \strong{Energese} symbols — H.T. Odum's Energy Systems Language.
#' Each Geom places one symbol per row of data at \code{aes(x, y)}
#' with size controlled by \code{width} + \code{height} (or
#' \code{radius}), and takes the standard \code{fill}, \code{colour},
#' \code{alpha}, and \code{linewidth} aesthetics.
#'
#' Geometry follows the canonical reference chart on Wikipedia
#' (\url{https://commons.wikimedia.org/wiki/File:Energese.jpg}).
#'
#' @section Symbols:
#' \itemize{
#'   \item \code{geom_odum_source()}       — filled circle (renewable / external input)
#'   \item \code{geom_odum_flow()}         — bare right-pointing arrow (generic energy flow)
#'   \item \code{geom_odum_storage()}      — Bertalanffy module (energy storage)
#'   \item \code{geom_odum_consumer()}     — hexagon (consumer / consumption)
#'   \item \code{geom_odum_interaction()}  — chevron (multiplicative junction)
#'   \item \code{geom_odum_producer()}     — bullet (autocatalytic producer)
#'   \item \code{geom_odum_switch()}       — bowtie (on/off logic gate)
#'   \item \code{geom_odum_self_limiter()} — semi-circle (saturating unit)
#'   \item \code{geom_odum_heat_sink()}    — down-arrow + ground line (dispersed heat)
#'   \item \code{geom_odum_transaction()}  — elongated diamond (money transaction)
#' }
#'
#' @section Aesthetics:
#' Required: \code{x}, \code{y}. Optional (with sensible defaults):
#' \code{width}, \code{height} for polygonal symbols;
#' \code{radius} for source, money; \code{fill}, \code{colour},
#' \code{alpha}, \code{linewidth}.
#'
#' @param mapping,data,stat,position,na.rm,show.legend,inherit.aes,...
#'   Standard ggplot2 layer arguments.
#' @param n Vertex count for curved symbols.
#' @return A ggplot2 layer.
#'
#' @examples
#' library(ggplot2)
#'
#' # One of each of the ten symbols in a single plot
#' one <- data.frame(x = 0, y = 0)
#'
#' ggplot(one, aes(x, y)) + geom_odum_source() +
#'   coord_fixed() + theme_void()
#'
#' ggplot(one, aes(x, y)) + geom_odum_flow() +
#'   coord_fixed() + theme_void()
#'
#' ggplot(one, aes(x, y)) + geom_odum_storage() +
#'   coord_fixed() + theme_void()
#'
#' ggplot(one, aes(x, y)) + geom_odum_consumer() +
#'   coord_fixed() + theme_void()
#'
#' ggplot(one, aes(x, y)) + geom_odum_interaction() +
#'   coord_fixed() + theme_void()
#'
#' ggplot(one, aes(x, y)) + geom_odum_producer() +
#'   coord_fixed() + theme_void()
#'
#' ggplot(one, aes(x, y)) + geom_odum_switch() +
#'   coord_fixed() + theme_void()
#'
#' ggplot(one, aes(x, y)) + geom_odum_self_limiter() +
#'   coord_fixed() + theme_void()
#'
#' ggplot(one, aes(x, y)) + geom_odum_heat_sink() +
#'   coord_fixed() + theme_void()
#'
#' ggplot(one, aes(x, y)) + geom_odum_transaction() +
#'   coord_fixed() + theme_void()
#'
#' # Vectorised: many symbols on one canvas driven by data.
#' d <- data.frame(x = c(1, 3, 5, 7),
#'                 y = 0,
#'                 role = c("Sun", "Grass", "Grazer", "Predator"))
#' ggplot(d, aes(x, y)) +
#'   geom_odum_source  (data = d[1, ], radius = 0.4, fill = "#F1C40F") +
#'   geom_odum_producer(data = d[2, ], width = 1.0, height = 0.9,
#'                       fill = "#2E7D32") +
#'   geom_odum_consumer(data = d[3, ], width = 1.0, height = 0.9,
#'                       fill = "#8B4513") +
#'   geom_odum_consumer(data = d[4, ], width = 1.0, height = 0.9,
#'                       fill = "#5D4037") +
#'   geom_text(aes(y = y - 0.9, label = role), size = 3) +
#'   coord_fixed(xlim = c(0, 8), ylim = c(-1.5, 1.5)) +
#'   theme_void()
#'
#' @name geom_odum
NULL

# ─── Internal expand helpers ───────────────────────────────────────

.expand_odum <- function(data, gen_fn, ...) {
  out <- vector("list", nrow(data))
  for (i in seq_len(nrow(data))) {
    row <- data[i, , drop = FALSE]
    poly <- gen_fn(cx = row$x, cy = row$y,
                    w = row$width, h = row$height,
                    id = i, ...)
    # Group each SUB-polygon separately: helpers that return multiple
    # `id` values (e.g. odum_switch's "_L" and "_R" triangles) get
    # distinct group ids so GeomPolygon renders them as separate paths.
    poly$group     <- i * 1000L + as.integer(as.factor(poly$id))
    poly$fill      <- row$fill
    poly$colour    <- row$colour
    poly$alpha     <- row$alpha
    poly$linewidth <- row$linewidth
    poly$PANEL     <- row$PANEL
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
    poly$group     <- i
    poly$fill      <- row$fill
    poly$colour    <- row$colour
    poly$alpha     <- row$alpha
    poly$linewidth <- row$linewidth
    poly$PANEL     <- row$PANEL
    out[[i]] <- poly
  }
  do.call(rbind, out)
}

# ─── GeomOdumSource ────────────────────────────────────────────────

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
  draw_key = ggplot2::draw_key_polygon)

#' @rdname geom_odum
#' @export
geom_odum_source <- function(mapping = NULL, data = NULL,
                              stat = "identity", position = "identity",
                              ..., n = 60, na.rm = FALSE,
                              show.legend = NA, inherit.aes = TRUE) {
  ggplot2::layer(
    geom = GeomOdumSource, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(n = n, na.rm = na.rm, ...))
}

# ─── GeomOdumFlow (bare arrow) ─────────────────────────────────────

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumFlow <- ggplot2::ggproto("GeomOdumFlow", ggplot2::GeomPolygon,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(width = 1.0, height = 0.4, fill = "grey30",
                             colour = "black", alpha = 0.9,
                             linewidth = 0.35, subgroup = NULL),
  draw_panel = function(data, panel_params, coord) {
    poly <- .expand_odum(data, odum_flow)
    ggplot2::GeomPolygon$draw_panel(poly, panel_params, coord)
  },
  draw_key = ggplot2::draw_key_polygon)

#' @rdname geom_odum
#' @export
geom_odum_flow <- function(mapping = NULL, data = NULL,
                            stat = "identity", position = "identity",
                            ..., na.rm = FALSE,
                            show.legend = NA, inherit.aes = TRUE) {
  ggplot2::layer(
    geom = GeomOdumFlow, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...))
}

# ─── GeomOdumStorage (Bertalanffy) ─────────────────────────────────

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumStorage <- ggplot2::ggproto("GeomOdumStorage", ggplot2::GeomPolygon,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(width = 0.8, height = 0.7, fill = "#1F77B4",
                             colour = "black", alpha = 0.85,
                             linewidth = 0.35, subgroup = NULL),
  draw_panel = function(data, panel_params, coord, n = 20) {
    poly <- .expand_odum(data, function(cx, cy, w, h, id)
      odum_storage(cx, cy, w, h, id, n = n))
    ggplot2::GeomPolygon$draw_panel(poly, panel_params, coord)
  },
  draw_key = ggplot2::draw_key_polygon)

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

# ─── GeomOdumConsumer ──────────────────────────────────────────────

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumConsumer <- ggplot2::ggproto("GeomOdumConsumer", ggplot2::GeomPolygon,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(width = 0.8, height = 0.6, fill = "#C0392B",
                             colour = "black", alpha = 0.85,
                             linewidth = 0.35, subgroup = NULL),
  draw_panel = function(data, panel_params, coord) {
    poly <- .expand_odum(data, odum_consumer)
    ggplot2::GeomPolygon$draw_panel(poly, panel_params, coord)
  },
  draw_key = ggplot2::draw_key_polygon)

#' @rdname geom_odum
#' @export
geom_odum_consumer <- function(mapping = NULL, data = NULL,
                                stat = "identity", position = "identity",
                                ..., na.rm = FALSE,
                                show.legend = NA, inherit.aes = TRUE) {
  ggplot2::layer(
    geom = GeomOdumConsumer, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...))
}

# ─── GeomOdumInteraction (chevron) ─────────────────────────────────

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumInteraction <- ggplot2::ggproto("GeomOdumInteraction", ggplot2::GeomPolygon,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(width = 0.8, height = 0.6, fill = "#F39C12",
                             colour = "black", alpha = 0.85,
                             linewidth = 0.35, subgroup = NULL),
  draw_panel = function(data, panel_params, coord) {
    poly <- .expand_odum(data, odum_interaction)
    ggplot2::GeomPolygon$draw_panel(poly, panel_params, coord)
  },
  draw_key = ggplot2::draw_key_polygon)

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

# ─── GeomOdumProducer (rounded rectangle bullet) ───────────────────

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumProducer <- ggplot2::ggproto("GeomOdumProducer", ggplot2::GeomPolygon,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(width = 1.0, height = 0.6, fill = "#228B22",
                             colour = "black", alpha = 0.85,
                             linewidth = 0.35, subgroup = NULL),
  draw_panel = function(data, panel_params, coord, n = 20) {
    poly <- .expand_odum(data, function(cx, cy, w, h, id)
      odum_producer(cx, cy, w, h, id, n = n))
    ggplot2::GeomPolygon$draw_panel(poly, panel_params, coord)
  },
  draw_key = ggplot2::draw_key_polygon)

#' @rdname geom_odum
#' @export
geom_odum_producer <- function(mapping = NULL, data = NULL,
                                stat = "identity", position = "identity",
                                ..., n = 20, na.rm = FALSE,
                                show.legend = NA, inherit.aes = TRUE) {
  ggplot2::layer(
    geom = GeomOdumProducer, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(n = n, na.rm = na.rm, ...))
}

# ─── GeomOdumSwitch (bowtie) ───────────────────────────────────────

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumSwitch <- ggplot2::ggproto("GeomOdumSwitch", ggplot2::GeomPolygon,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(width = 0.6, height = 0.6, fill = "grey85",
                             colour = "black", alpha = 0.9,
                             linewidth = 0.35, subgroup = NULL),
  draw_panel = function(data, panel_params, coord) {
    poly <- .expand_odum(data, odum_switch)
    ggplot2::GeomPolygon$draw_panel(poly, panel_params, coord)
  },
  draw_key = ggplot2::draw_key_polygon)

#' @rdname geom_odum
#' @export
geom_odum_switch <- function(mapping = NULL, data = NULL,
                              stat = "identity", position = "identity",
                              ..., na.rm = FALSE,
                              show.legend = NA, inherit.aes = TRUE) {
  ggplot2::layer(
    geom = GeomOdumSwitch, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...))
}

# ─── GeomOdumSelfLimiter (semi-circle) ─────────────────────────────

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumSelfLimiter <- ggplot2::ggproto("GeomOdumSelfLimiter", ggplot2::GeomPolygon,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(width = 0.6, height = 0.7, fill = "grey85",
                             colour = "black", alpha = 0.9,
                             linewidth = 0.35, subgroup = NULL),
  draw_panel = function(data, panel_params, coord, n = 30) {
    poly <- .expand_odum(data, function(cx, cy, w, h, id)
      odum_self_limiter(cx, cy, w, h, id, n = n))
    ggplot2::GeomPolygon$draw_panel(poly, panel_params, coord)
  },
  draw_key = ggplot2::draw_key_polygon)

#' @rdname geom_odum
#' @export
geom_odum_self_limiter <- function(mapping = NULL, data = NULL,
                                    stat = "identity", position = "identity",
                                    ..., n = 30, na.rm = FALSE,
                                    show.legend = NA, inherit.aes = TRUE) {
  ggplot2::layer(
    geom = GeomOdumSelfLimiter, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(n = n, na.rm = na.rm, ...))
}

# ─── GeomOdumHeatSink (arrow + ground line) ────────────────────────

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumHeatSink <- ggplot2::ggproto("GeomOdumHeatSink", ggplot2::Geom,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(width = 0.35, height = 0.55, fill = "grey60",
                             colour = "black", alpha = 0.9,
                             linewidth = 0.4, subgroup = NULL),
  draw_panel = function(data, panel_params, coord) {
    # Expand each row into arrow polygon + ground segment; render both
    arrows <- do.call(rbind, lapply(seq_len(nrow(data)), function(i) {
      row <- data[i, , drop = FALSE]
      a <- odum_heat_sink(row$x, row$y, row$width, row$height, id = i)
      g <- attr(a, "ground")
      a$group <- i;  g$group <- i + 1000L
      a$fill <- row$fill;   g$fill   <- NA
      a$colour <- row$colour;  g$colour <- row$colour
      a$alpha <- row$alpha;  g$alpha  <- row$alpha
      a$linewidth <- row$linewidth;  g$linewidth <- row$linewidth
      a$PANEL <- row$PANEL;  g$PANEL  <- row$PANEL
      rbind(a, g)
    }))
    poly_data  <- arrows[!grepl("_ground$", arrows$id), ]
    line_data  <- arrows[ grepl("_ground$", arrows$id), ]
    grid::gTree(children = grid::gList(
      ggplot2::GeomPolygon$draw_panel(poly_data, panel_params, coord),
      ggplot2::GeomPath$draw_panel(line_data,   panel_params, coord)))
  },
  draw_key = ggplot2::draw_key_polygon)

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

# ─── GeomOdumTransaction (elongated diamond, $ label) ──────────────

#' @rdname geom_odum
#' @format NULL
#' @export
GeomOdumTransaction <- ggplot2::ggproto("GeomOdumTransaction", ggplot2::GeomPolygon,
  required_aes = c("x", "y"),
  default_aes = ggplot2::aes(width = 1.0, height = 0.4, fill = "white",
                             colour = "black", alpha = 1,
                             linewidth = 0.4, subgroup = NULL),
  draw_panel = function(data, panel_params, coord) {
    poly <- .expand_odum(data, odum_transaction)
    ggplot2::GeomPolygon$draw_panel(poly, panel_params, coord)
  },
  draw_key = ggplot2::draw_key_polygon)

#' @rdname geom_odum
#' @export
geom_odum_transaction <- function(mapping = NULL, data = NULL,
                                   stat = "identity", position = "identity",
                                   ..., na.rm = FALSE,
                                   show.legend = NA, inherit.aes = TRUE) {
  ggplot2::layer(
    geom = GeomOdumTransaction, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...))
}

# ─── GeomOdumMoney (alias for source, outlined) ────────────────────

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
  draw_key = ggplot2::draw_key_polygon)

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
