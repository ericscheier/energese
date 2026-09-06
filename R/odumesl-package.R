#' odumesl: ggplot2 Layers for H.T. Odum's Energy Systems Language
#'
#' Provides grammar-of-graphics ggplot2 layers for H.T. Odum's Energy
#' Systems Language (ESL) — a visual vocabulary of seven canonical
#' symbols used across systems ecology and emergy accounting since
#' Odum 1971. Symbols include source circles, autocatalytic producer
#' bullet-nosed hexagons, consumer hexagons, storage bullet-tanks,
#' interaction diamonds, dispersed-heat sink triangles, and money
#' transaction nodes.
#'
#' Two APIs are exposed:
#'
#' * **High-level (recommended)** — ggplot2 Geoms with standard
#'   aesthetics: [geom_odum_source()], [geom_odum_producer()],
#'   [geom_odum_consumer()], [geom_odum_storage()],
#'   [geom_odum_interaction()], [geom_odum_heat_sink()],
#'   [geom_odum_money()]. Vectorised over data rows; composable in a
#'   `ggplot()` pipeline like any other ggplot2 layer.
#' * **Low-level** — vertex-tibble helpers that return `(x, y, id)`
#'   coordinates suitable for `geom_polygon()`: [odum_circle()],
#'   [odum_producer()], [odum_consumer()], [odum_storage()],
#'   [odum_interaction()], [odum_heat_sink()], [odum_money()].
#'   Use these when you want to hand-compose polygons, animate with
#'   `gganimate`, or overlay on non-ggplot renderers.
#'
#' @section Prior art:
#' To the author's knowledge, `odumesl` is the first R (or Python)
#' grammar-of-graphics library for ESL. The closest peers are the
#' now-abandoned Java `EmSim` (an ODE integrator, no rendering API),
#' the TypeScript GUI editor `sholtomaud/odum-energy-language`, and
#' static SVG reference libraries from the University of Florida's
#' Center for Environmental Policy and the International Society for
#' the Advancement of Emergy Research. See `vignette("odumesl")` for
#' a full worked example and prior-art scan.
#'
#' @section Canonical references:
#'   Odum, H.T. (1971). *Environment, Power, and Society*. Wiley.
#'   Odum, H.T. (1994). Ecological and general systems: an
#'   introduction to systems ecology. University Press of Colorado.
#'   Brown, M.T. (2004). "A picture is worth a thousand words: energy
#'   systems language and simulation." *Ecological Modelling* 178:
#'   83-100. \doi{10.1016/j.ecolmodel.2003.12.008}
#'
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom tibble tibble
## usethis namespace: end
NULL
