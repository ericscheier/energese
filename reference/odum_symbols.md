# Odum ESL vertex helpers

Low-level tibble-returning functions that compute polygon vertices for
each of H.T. Odum's Energy Systems Language (ESL) symbols. Used
internally by the
[`geom_odum_source()`](https://pkg.energese.org/reference/geom_odum.md)
family; also exported for users who want to hand-compose
[`ggplot2::geom_polygon()`](https://ggplot2.tidyverse.org/reference/geom_polygon.html)
layers, animate with `gganimate`, or render outside ggplot2.

Two inputs enter the flat left edge, one output exits the pointed right.
Odum's canonical "multiplicative junction" symbol — distinctly NOT a
diamond (that shape is a `switch` in Odum's ESL).

Odum's autocatalytic-unit symbol. Same silhouette as `storage` rotated
90° right: flat left edge, straight top+bottom, semi-circular right end.

Odum's on/off logic gate. Two triangles meeting at a central point,
bounding-box (w, h).

Odum's "self-limited" unit — represents a producer/consumer whose output
saturates.

Returns a data.frame with TWO groups: the down-arrow polygon and the
horizontal ground line as a separate row-set (id column distinguishes
them). Users can render together with a single `geom_polygon` +
`geom_segment`, or use
[`geom_odum_heat_sink()`](https://pkg.energese.org/reference/geom_odum.md)
which wraps both.

Money flows in the opposite direction of energy in Odum's ESL, so this
symbol is drawn with a dashed connection to the transacting unit. The
returned tibble is the diamond body; the caller adds a
`geom_segment(linetype="dashed")` for the flow line and a text label for
"\$".

Wikipedia's chart shows this as a lone right-pointing arrow. This helper
returns the arrow polygon (shaft + triangular head) for drawing with
`geom_polygon`; use
[`geom_odum_flow()`](https://pkg.energese.org/reference/geom_odum.md) to
add it inside a ggplot pipeline.

## Usage

``` r
odum_circle(cx, cy, r, id, n = 60)

odum_source(cx, cy, r, id, n = 60)

odum_storage(cx, cy, w, h, id, n = 20)

odum_consumer(cx, cy, w, h, id)

odum_interaction(cx, cy, w, h, id)

odum_producer(cx, cy, w, h, id, n = 20)

odum_switch(cx, cy, w, h, id)

odum_self_limiter(cx, cy, w, h, id, n = 30)

odum_heat_sink(cx, cy, w, h, id)

odum_transaction(cx, cy, w, h, id)

odum_money(cx, cy, r, id, n = 60)

odum_flow(cx, cy, w, h, id)
```

## Arguments

- cx, cy:

  Numeric centre of the symbol.

- r:

  Radius (for `odum_circle()` / `odum_money()`).

- id:

  Group id (used as the `group` aesthetic in
  [`geom_polygon()`](https://ggplot2.tidyverse.org/reference/geom_polygon.html)).

- n:

  Number of vertices to sample along curved arcs.

- w, h:

  Width and height of the bounding rectangle.

## Value

A tibble with columns `x`, `y`, `id`. For `odum_transaction()` a second
tibble of dashed-flow line coordinates is returned in the `"flow"`
attribute.

## Details

Geometry follows Wikipedia's canonical reference chart
(<https://commons.wikimedia.org/wiki/File:Energese.jpg>).
