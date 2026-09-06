# =============================================================================
# odum_symbols.R — Reusable geom polygons for H.T. Odum's Energy Systems
# Language (ESL) — circles, producers, consumers, storages, interactions,
# heat sinks. Each helper returns a tibble of (x, y, id) rows suitable for
# geom_polygon(); compose with ggplot2 to build ESL circuit diagrams
# (see Bundle Q — HEII systems-language schematic, scripts/render_systems*.R).
# =============================================================================

#' Odum ESL circle — source, or the body of a tank/money-transaction node
#' @param cx,cy Numeric centre.
#' @param r Radius.
#' @param id Group id for geom_polygon.
#' @param n Number of vertices (default 60).
#' @return tibble with columns x, y, id.
#' @export
odum_circle <- function(cx, cy, r, id, n = 60) {
  t <- seq(0, 2*pi, length.out = n)
  tibble::tibble(x = cx + r * cos(t), y = cy + r * sin(t), id = id)
}

#' Odum ESL PRODUCER (autocatalytic unit) — bullet-nosed hexagon.
#' Represents plants, agriculture, power stations — units that capture and
#' concentrate emergy into a product output on the pointed (right) end.
#' @param cx,cy Numeric centre.
#' @param w,h Width and height of the bounding rectangle.
#' @param id Group id.
#' @return tibble with columns x, y, id.
#' @export
odum_producer <- function(cx, cy, w, h, id) {
  nose <- h * 0.6
  tibble::tibble(
    x = c(cx - w/2, cx + w/2 - nose, cx + w/2,
          cx + w/2 - nose, cx - w/2, cx - w/2),
    y = c(cy - h/2, cy - h/2, cy,
          cy + h/2, cy + h/2, cy - h/2),
    id = id)
}

#' Odum ESL CONSUMER — hexagon.
#' Uses stored emergy (households, sectors, cultural producers).
#' @inheritParams odum_producer
#' @export
odum_consumer <- function(cx, cy, w, h, id) {
  side <- w * 0.28
  tibble::tibble(
    x = c(cx - w/2, cx - w/2 + side, cx + w/2 - side,
          cx + w/2, cx + w/2 - side, cx - w/2 + side, cx - w/2),
    y = c(cy, cy - h/2, cy - h/2,
          cy, cy + h/2, cy + h/2, cy),
    id = id)
}

#' Odum ESL STORAGE — bullet-tank (flat left, rounded right end).
#' Represents storages of matter, energy, or information.
#' @inheritParams odum_producer
#' @param n Vertices in the semi-circle arc (default 20).
#' @export
odum_storage <- function(cx, cy, w, h, id, n = 20) {
  r <- h / 2
  t <- seq(-pi/2, pi/2, length.out = n)
  right_arc_x <- (cx + w/2 - r) + r * cos(t)
  right_arc_y <- cy + r * sin(t)
  tibble::tibble(
    x = c(cx - w/2, right_arc_x, cx - w/2, cx - w/2),
    y = c(cy - h/2, right_arc_y, cy + h/2, cy - h/2),
    id = id)
}

#' Odum ESL INTERACTION — diamond (multiplicative junction).
#' Represents where two or more flows combine multiplicatively.
#' @param cx,cy Numeric centre.
#' @param s Diamond size (side).
#' @param id Group id.
#' @export
odum_interaction <- function(cx, cy, s, id) {
  tibble::tibble(
    x = c(cx, cx + s/2, cx, cx - s/2, cx),
    y = c(cy + s/2, cy, cy - s/2, cy, cy + s/2),
    id = id)
}

#' Odum ESL HEAT SINK — small triangle pointing down.
#' Represents dispersed (unusable) heat at the end of a transformation.
#' @param cx,cy Numeric centre (top vertex of triangle).
#' @param s Triangle side.
#' @param id Group id.
#' @export
odum_heat_sink <- function(cx, cy, s, id) {
  tibble::tibble(
    x = c(cx - s/2, cx + s/2, cx, cx - s/2),
    y = c(cy, cy, cy - s, cy),
    id = id)
}

#' Odum ESL MONEY node — outlined circle (draw with dashed lines for the
#' transaction flow going the opposite direction of energy).
#' Alias for \code{\link{odum_circle}}.
#' @inheritParams odum_circle
#' @export
odum_money <- function(cx, cy, r, id, n = 60) odum_circle(cx, cy, r, id, n)
