# =============================================================================
# odum_symbols.R — vertex helpers for H.T. Odum's Energy Systems Language.
#
# Geometry matches the canonical reference chart on Wikipedia's
# "Energy systems language" article (Sholto Maud's Visio stencil,
# https://commons.wikimedia.org/wiki/File:Energese.jpg). All 10
# symbols in that chart are implemented here as vertex-returning
# helpers; the ggproto layer in R/geom_odum.R wraps each for use in
# ggplot() pipelines.
#
# The canonical symbols (per Wikipedia / Odum 1994):
#   1. Source           — filled circle
#   2. Generic Flow     — bare arrow (no bounding polygon)
#   3. Store            — Bertalanffy module (flat top, tapered
#                          sides, rounded bottom / bullet)
#   4. Consumption      — regular hexagon
#   5. Interaction      — right-pointing chevron / arrow-pentagon
#   6. Production       — rounded rectangle with pointed right end
#   7. Switch           — hourglass / bowtie
#   8. Self-Limiter     — semi-circle (arc on left, flat on right)
#   9. Energy Loss      — down-arrow terminating at a horizontal
#                          ground line ("heat sink")
#   10. Transaction     — elongated diamond with $ label + dashed
#                          money-flow line
#
# Each helper returns a tibble of (x, y, id) rows suitable for
# geom_polygon() (or geom_path for the flow / heat-sink open forms).
# =============================================================================

#' Odum ESL vertex helpers
#'
#' Low-level tibble-returning functions that compute polygon vertices
#' for each of H.T. Odum's Energy Systems Language (ESL) symbols. Used
#' internally by the [geom_odum_source()] family; also exported for
#' users who want to hand-compose \code{ggplot2::geom_polygon()} layers,
#' animate with \code{gganimate}, or render outside ggplot2.
#'
#' Geometry follows Wikipedia's canonical reference chart
#' (\url{https://commons.wikimedia.org/wiki/File:Energese.jpg}).
#'
#' @param cx,cy Numeric centre of the symbol.
#' @param w,h Width and height of the bounding rectangle.
#' @param r Radius (for [odum_circle()] / [odum_money()]).
#' @param id Group id (used as the \code{group} aesthetic in
#'   \code{geom_polygon()}).
#' @param n Number of vertices to sample along curved arcs.
#' @return A tibble with columns \code{x}, \code{y}, \code{id}. For
#'   [odum_transaction()] a second tibble of dashed-flow line
#'   coordinates is returned in the \code{"flow"} attribute.
#' @name odum_symbols
NULL

#' @rdname odum_symbols
#' @export
odum_circle <- function(cx, cy, r, id, n = 60) {
  t <- seq(0, 2 * pi, length.out = n)
  tibble::tibble(x = cx + r * cos(t), y = cy + r * sin(t), id = id)
}

#' @rdname odum_symbols
#' @export
odum_source <- function(cx, cy, r, id, n = 60) odum_circle(cx, cy, r, id, n)

#' Bertalanffy STORE — flat top, angled sides, rounded bottom.
#'
#' @rdname odum_symbols
#' @export
odum_storage <- function(cx, cy, w, h, id, n = 20) {
  # Wikipedia geometry: pentagon-like shape with a flat top, angled
  # taper on the sides, and a rounded (semi-circular) bottom.
  # This is the "Bertalanffy module" — Odum named it after Ludwig
  # von Bertalanffy, the general-systems theorist.
  half_w <- w / 2
  taper_h <- 0.30 * h        # portion of height taken by the taper
  flat_top_h <- cy + h / 2
  # Radius of the bottom semi-circle: fits inside the tapered width
  bot_r <- 0.85 * half_w
  bot_cy <- cy - h / 2 + bot_r
  # Slight angled taper below the flat top
  shoulder_x <- 0.95 * half_w
  # Arc from RIGHT (0) → bottom (-pi/2) → LEFT (-pi) so traversal
  # order is monotonic and doesn't self-cross the polygon
  arc_t <- seq(0, -pi, length.out = n)
  arc_x <- cx + bot_r * cos(arc_t)      # +bot_r → 0 → -bot_r
  arc_y <- bot_cy + bot_r * sin(arc_t)  # bot_cy → bot_cy - bot_r → bot_cy
  tibble::tibble(
    x = c(cx - half_w, cx + half_w, cx + shoulder_x,
          arc_x, cx - shoulder_x, cx - half_w),
    y = c(flat_top_h, flat_top_h, flat_top_h - taper_h,
          arc_y, flat_top_h - taper_h, flat_top_h),
    id = id)
}

#' Consumer HEXAGON — regular six-sided shape (all edges roughly equal).
#'
#' @rdname odum_symbols
#' @export
odum_consumer <- function(cx, cy, w, h, id) {
  # Regular hexagon proportion: horizontal width w, height h, side
  # inset = w/4 on top+bottom edges.
  inset <- w / 4
  tibble::tibble(
    x = c(cx - w/2,  cx - w/2 + inset, cx + w/2 - inset,
          cx + w/2,  cx + w/2 - inset, cx - w/2 + inset,
          cx - w/2),
    y = c(cy,        cy + h/2,         cy + h/2,
          cy,        cy - h/2,         cy - h/2,
          cy),
    id = id)
}

#' Interaction CHEVRON — right-pointing arrow-pentagon.
#'
#' Two inputs enter the flat left edge, one output exits the pointed
#' right. Odum's canonical "multiplicative junction" symbol —
#' distinctly NOT a diamond (that shape is a `switch` in Odum's ESL).
#'
#' @rdname odum_symbols
#' @export
odum_interaction <- function(cx, cy, w, h, id) {
  # Pentagon with left edge flat, right edge pointed:
  #   top-left → top-right shoulder → right-tip → bottom-right shoulder → bottom-left → close
  shoulder <- 0.35 * w   # left edge to where the taper begins
  tibble::tibble(
    x = c(cx - w/2,  cx - w/2 + shoulder, cx + w/2,
          cx - w/2 + shoulder, cx - w/2, cx - w/2),
    y = c(cy + h/2,  cy + h/2,            cy,
          cy - h/2,           cy - h/2,   cy + h/2),
    id = id)
}

#' PRODUCTION — rounded rectangle with pointed right end.
#'
#' Odum's autocatalytic-unit symbol. Same silhouette as `storage`
#' rotated 90° right: flat left edge, straight top+bottom, semi-circular
#' right end.
#'
#' @rdname odum_symbols
#' @export
odum_producer <- function(cx, cy, w, h, id, n = 20) {
  # Rounded-right rectangle. Left edge flat at (cx - w/2), top+bottom
  # straight to (cx + w/2 - h/2), then semi-circular cap to the pointed
  # right end.
  half_h <- h / 2
  cap_r  <- half_h
  cap_cx <- cx + w/2 - cap_r
  arc_t  <- seq(-pi/2, pi/2, length.out = n)
  arc_x  <- cap_cx + cap_r * cos(arc_t)
  arc_y  <- cy + cap_r * sin(arc_t)
  tibble::tibble(
    x = c(cx - w/2, cap_cx, arc_x, cap_cx, cx - w/2, cx - w/2),
    y = c(cy - half_h, cy - half_h, arc_y, cy + half_h, cy + half_h,
          cy - half_h),
    id = id)
}

#' SWITCH — bowtie / hourglass.
#'
#' Odum's on/off logic gate. Two triangles meeting at a central point,
#' bounding-box (w, h).
#'
#' @rdname odum_symbols
#' @export
odum_switch <- function(cx, cy, w, h, id) {
  # Two separate triangles (left + right), meeting at the centre point.
  # Each is emitted as its OWN id (id + "_L" / "_R") so GeomPolygon
  # renders them as two independent paths — no self-crossing outline.
  left <- tibble::tibble(
    x  = c(cx - w/2, cx, cx - w/2, cx - w/2),
    y  = c(cy + h/2, cy, cy - h/2, cy + h/2),
    id = paste0(id, "_L"))
  right <- tibble::tibble(
    x  = c(cx + w/2, cx, cx + w/2, cx + w/2),
    y  = c(cy + h/2, cy, cy - h/2, cy + h/2),
    id = paste0(id, "_R"))
  rbind(left, right)
}

#' SELF-LIMITER — semi-circle (arc on left, flat right edge).
#'
#' Odum's "self-limited" unit — represents a producer/consumer whose
#' output saturates.
#'
#' @rdname odum_symbols
#' @export
odum_self_limiter <- function(cx, cy, w, h, id, n = 30) {
  # Half-circle. Radius = h/2; flat right edge at x = cx + w/2 * ε (~0).
  # The chart shows the arc pointing LEFT.
  r <- h / 2
  arc_t <- seq(pi/2, 3*pi/2, length.out = n)
  arc_x <- cx + r * cos(arc_t)   # cos is negative in this range → arc left of cx
  arc_y <- cy + r * sin(arc_t)
  tibble::tibble(
    x = c(cx, arc_x, cx),
    y = c(cy + r, arc_y, cy - r),
    id = id)
}

#' HEAT SINK (ENERGY LOSS) — vertical arrow terminating at a ground line.
#'
#' Returns a data.frame with TWO groups: the down-arrow polygon and the
#' horizontal ground line as a separate row-set (id column
#' distinguishes them). Users can render together with a single
#' \code{geom_polygon} + \code{geom_segment}, or use
#' [geom_odum_heat_sink()] which wraps both.
#'
#' @rdname odum_symbols
#' @export
odum_heat_sink <- function(cx, cy, w, h, id) {
  # Downward arrow: shaft from (cx, cy) to (cx, cy - h*0.7), triangular
  # arrowhead, terminating just above the horizontal ground line at
  # (cx - w/2, cy - h)  to (cx + w/2, cy - h).
  shaft_top    <- cy + h/2
  shaft_bottom <- cy - h/2 + 0.30 * h   # arrow tip sits above ground
  head_half    <- 0.20 * w
  ground_y     <- cy - h/2
  # Arrow polygon (rectangular shaft + triangular head)
  arrow <- tibble::tibble(
    x = c(cx - 0.08 * w, cx - 0.08 * w, cx - head_half,
          cx,             cx + head_half, cx + 0.08 * w,
          cx + 0.08 * w, cx - 0.08 * w),
    y = c(shaft_top, shaft_bottom + 0.10 * h, shaft_bottom + 0.10 * h,
          shaft_bottom,   shaft_bottom + 0.10 * h, shaft_bottom + 0.10 * h,
          shaft_top,   shaft_top),
    id = paste0(id, "_arrow"))
  # Ground line as a two-point path (id suffix _ground for separate rendering)
  ground <- tibble::tibble(
    x = c(cx - w/2, cx + w/2),
    y = c(ground_y, ground_y),
    id = paste0(id, "_ground"))
  attr(arrow, "ground") <- ground
  arrow
}

#' TRANSACTION — elongated diamond with $ label + dashed money-flow line.
#'
#' Money flows in the opposite direction of energy in Odum's ESL, so
#' this symbol is drawn with a dashed connection to the transacting
#' unit. The returned tibble is the diamond body; the caller adds a
#' \code{geom_segment(linetype="dashed")} for the flow line and a
#' text label for "$".
#'
#' @rdname odum_symbols
#' @export
odum_transaction <- function(cx, cy, w, h, id) {
  # Elongated horizontal diamond
  tibble::tibble(
    x = c(cx - w/2, cx, cx + w/2, cx, cx - w/2),
    y = c(cy,       cy + h/2, cy, cy - h/2, cy),
    id = id)
}

#' MONEY node — alias for [odum_circle()] (kept for API stability).
#'
#' @rdname odum_symbols
#' @export
odum_money <- function(cx, cy, r, id, n = 60) odum_circle(cx, cy, r, id, n)

#' GENERIC FLOW — a bare arrow (no bounding symbol).
#'
#' Wikipedia's chart shows this as a lone right-pointing arrow. This
#' helper returns the arrow polygon (shaft + triangular head) for
#' drawing with \code{geom_polygon}; use [geom_odum_flow()] to add it
#' inside a ggplot pipeline.
#'
#' @rdname odum_symbols
#' @export
odum_flow <- function(cx, cy, w, h, id) {
  # Right-pointing arrow. Shaft from (cx - w/2) to (cx + w/2 - head_w),
  # head from there to (cx + w/2).
  head_w <- 0.30 * w
  shaft_half_h <- 0.20 * h
  head_half_h  <- h / 2
  tibble::tibble(
    x = c(cx - w/2,           cx + w/2 - head_w, cx + w/2 - head_w,
          cx + w/2,           cx + w/2 - head_w, cx + w/2 - head_w,
          cx - w/2,           cx - w/2),
    y = c(cy - shaft_half_h,  cy - shaft_half_h, cy - head_half_h,
          cy,                 cy + head_half_h,  cy + shaft_half_h,
          cy + shaft_half_h,  cy - shaft_half_h),
    id = id)
}
