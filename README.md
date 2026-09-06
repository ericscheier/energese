# odumesl · ggplot2 layers for H.T. Odum's Energy Systems Language

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/odumesl)](https://CRAN.R-project.org/package=odumesl)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

**odumesl** is the first (that we know of) grammar-of-graphics
implementation of Howard T. Odum's **Energy Systems Language (ESL)** —
the visual vocabulary of seven canonical symbols used across systems
ecology, ecological engineering, and emergy accounting since Odum
1971.

Every ESL symbol is exposed as a proper `ggplot2` layer:

| Symbol            | Purpose                              | Function                 |
|-------------------|--------------------------------------|--------------------------|
| Circle            | Source (renewable / external input)  | `geom_odum_source()`     |
| Bullet-nosed hex  | Producer (autocatalytic unit)        | `geom_odum_producer()`   |
| Hexagon           | Consumer                             | `geom_odum_consumer()`   |
| Bullet-tank       | Storage                              | `geom_odum_storage()`    |
| Diamond           | Interaction (multiplicative junction)| `geom_odum_interaction()`|
| Triangle (down)   | Heat sink (dispersed heat)           | `geom_odum_heat_sink()`  |
| Outlined circle   | Money transaction                    | `geom_odum_money()`      |

Each takes standard ggplot2 aesthetics (`x`, `y`, `fill`, `colour`,
`alpha`, `linewidth`) plus a geometry aesthetic (`width` + `height` for
polygonal symbols, `radius` for circular ones), is vectorised over
rows of data, and composes naturally with `ggplot()`, `facet_*()`,
`gganimate`, `patchwork`, etc.

## Installation

```r
# CRAN (once accepted)
install.packages("odumesl")

# Development version
# install.packages("remotes")
remotes::install_github("ericscheier/odumesl")
```

## Example

```r
library(ggplot2)
library(odumesl)

d <- data.frame(
  x    = c(0, 3, 6, 9, 12, 15, 18),
  y    = 0,
  role = c("source", "producer", "consumer", "storage",
           "interaction", "heat_sink", "money"),
  fill = c("#F1C40F", "#228B22", "#C0392B", "#1F77B4",
           "#F39C12", "#7F7F7F", "white"))

ggplot(d, aes(x = x, y = y, fill = I(fill))) +
  geom_odum_source     (data = d[1, ], radius = 0.5) +
  geom_odum_producer   (data = d[2, ], width = 1.5, height = 0.9) +
  geom_odum_consumer   (data = d[3, ], width = 1.5, height = 0.9) +
  geom_odum_storage    (data = d[4, ], width = 1.5, height = 0.9) +
  geom_odum_interaction(data = d[5, ], width = 0.9, height = 0.9) +
  geom_odum_heat_sink  (data = d[6, ], width = 0.6, height = 0.6) +
  geom_odum_money      (data = d[7, ], radius = 0.4,
                        colour = "#B5791B") +
  geom_text(aes(y = -1.5, label = role), size = 3.5) +
  coord_cartesian(xlim = c(-1, 19), ylim = c(-2, 1)) +
  theme_void()
```

## Design

Under the hood each `geom_odum_*` extends `ggplot2::GeomPolygon` and
uses an internal `.expand_odum()` helper to convert each row of data
into a set of polygon vertices, then delegates rendering to
`GeomPolygon`. This means every layer supports the full ggplot2
grammar out of the box — facets, animations, palettes, coordinate
systems, statistical transformations.

For users who want direct access to the polygon coordinates
(e.g. for `gganimate` `transition_states` or non-ggplot renderers),
the low-level vertex helpers are also exported:

```r
odum_producer(cx = 0, cy = 0, w = 2, h = 1, id = "p1")
#> # A tibble: 6 × 3
#>       x     y id
#>   <dbl> <dbl> <chr>
#> 1  -1.0  -0.5 p1
#> 2   0.4  -0.5 p1
#> 3   1.0   0.0 p1
#> 4   0.4   0.5 p1
#> 5  -1.0   0.5 p1
#> 6  -1.0  -0.5 p1
```

## Prior art

A deep scan of CRAN, GitHub, PyPI, and the biennial *Emergy Synthesis*
proceedings turned up no other grammar-of-graphics ESL library. The
closest peers:

* **EmSim** (Valyi & Ortega 2004) — Java ODE integrator for ESL
  diagrams, no rendering API, effectively abandoned.
* **sholtomaud/odum-energy-language** — TypeScript GUI drag-and-drop
  editor, no data binding.
* **University of Florida CEP** + **International Society for the
  Advancement of Emergy Research** — reference SVG images, not
  programmatic stencils.

`odumesl` fills the gap: programmatic, data-bindable Odum ESL layers
in R's grammar of graphics.

## Citation

If you use `odumesl` in academic work, please cite:

> Scheier, E. (2026). *odumesl: ggplot2 Layers for H.T. Odum's Energy
> Systems Language*. R package version 0.1.0.
> <https://github.com/ericscheier/odumesl>

Please also cite the canonical Odum references:

* Odum, H.T. (1994). *Ecological and General Systems: An Introduction
  to Systems Ecology*. University Press of Colorado.
* Brown, M.T. (2004). "A picture is worth a thousand words: Energy
  systems language and simulation." *Ecological Modelling* 178: 83-100.
  <https://doi.org/10.1016/j.ecolmodel.2003.12.008>

## License

MIT © Eric Scheier
