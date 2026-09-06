#' energese: ggplot2 Layers for H.T. Odum's Energy Systems Language
#'
#' Provides grammar-of-graphics ggplot2 layers for H.T. Odum's Energy
#' Systems Language (ESL) — also known as **Energese**, *Energy
#' Circuit Language*, or *Generic Systems Symbols*. Odum developed
#' the language in the 1950s during tropical-forest studies at El
#' Verde, Puerto Rico (Odum & Pigeon 1970, funded by the U.S. Atomic
#' Energy Commission).
#'
#' Every canonical symbol on Wikipedia's Energese reference chart
#' (\url{https://commons.wikimedia.org/wiki/File:Energese.jpg}) is
#' exposed:
#'
#' * [geom_odum_source()]       — circle (renewable / external input)
#' * [geom_odum_flow()]         — bare arrow (generic flow)
#' * [geom_odum_storage()]      — Bertalanffy module
#' * [geom_odum_consumer()]     — hexagon (consumer)
#' * [geom_odum_interaction()]  — chevron (multiplicative junction)
#' * [geom_odum_producer()]     — bullet (autocatalytic producer)
#' * [geom_odum_switch()]       — bowtie (logic gate)
#' * [geom_odum_self_limiter()] — semi-circle (saturating unit)
#' * [geom_odum_heat_sink()]    — down-arrow + ground line (heat sink)
#' * [geom_odum_transaction()]  — elongated diamond (money transaction)
#'
#' See [plot_energese_reference()] for a single function that
#' reproduces Wikipedia's canonical chart.
#'
#' Two APIs are exposed:
#'
#' * **High-level (recommended)** — the ggplot2 Geoms above, with
#'   standard aesthetics. Vectorised over data rows; composable in a
#'   `ggplot()` pipeline like any other ggplot2 layer.
#' * **Low-level** — vertex-tibble helpers ([odum_symbols]) that
#'   return `(x, y, id)` coordinates suitable for
#'   `ggplot2::geom_polygon()`. Use these when you want to
#'   hand-compose polygons, animate with `gganimate`, or render
#'   outside ggplot2.
#'
#' @section Prior art:
#' To the author's knowledge, `energese` is the first R (or Python)
#' grammar-of-graphics library for ESL. The closest peers are the
#' now-abandoned Java `EmSim` (an ODE integrator, no rendering API),
#' the TypeScript GUI editor
#' \url{https://github.com/sholtomaud/odum-energy-language} (Sholto
#' Maud, who also produced the Visio stencil that Wikipedia's
#' Energese chart is based on), and static SVG reference libraries
#' from the UF Center for Environmental Policy. See the vignette
#' (`vignette("energese")`) for a full worked example and prior-art
#' scan.
#'
#' @section References:
#'   - Odum, H.T. & Pigeon, R.F. (eds.) (1970). *A Tropical Rain
#'     Forest: A Study of Irradiation and Ecology at El Verde, Puerto
#'     Rico*.
#'   - Odum, H.T. (1994). *Ecological and General Systems: An
#'     Introduction to Systems Ecology*. Rev. ed.
#'   - Odum, H.T. & Odum, E.C. (2000). *Modeling for All Scales*.
#'   - Odum, H.T. (2007). *Environment, Power, and Society for the
#'     Twenty-First Century: The Hierarchy of Energy*.
#'   - Brown, M.T. (2004). "A picture is worth a thousand words:
#'     energy systems language and simulation." *Ecological
#'     Modelling* 178: 83-100.
#'     \doi{10.1016/j.ecolmodel.2003.12.008}
#'
#' @seealso The Wikipedia article on
#'   \href{https://en.wikipedia.org/wiki/Energy_systems_language}{Energy
#'   Systems Language}.
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom tibble tibble
## usethis namespace: end
NULL

# Silence R CMD check NOTEs about NSE column references in aes()
utils::globalVariables(c("xmin", "xmax", "ymin", "ymax",
                          "kind", "y", "name"))
