# Odum ESL Geoms — ggplot2 layers for H.T. Odum's Energy Systems Language

A family of ten `ggplot2` Geoms that draw the canonical **Energese**
symbols — H.T. Odum's Energy Systems Language. Each Geom places one
symbol per row of data at `aes(x, y)` with size controlled by `width` +
`height` (or `radius`), and takes the standard `fill`, `colour`,
`alpha`, and `linewidth` aesthetics.

## Usage

``` r
GeomOdumSource

geom_odum_source(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  n = 60,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

GeomOdumFlow

geom_odum_flow(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

GeomOdumStorage

geom_odum_storage(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  n = 20,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

GeomOdumConsumer

geom_odum_consumer(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

GeomOdumInteraction

geom_odum_interaction(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

GeomOdumProducer

geom_odum_producer(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  n = 20,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

GeomOdumSwitch

geom_odum_switch(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

GeomOdumSelfLimiter

geom_odum_self_limiter(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  n = 30,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

GeomOdumHeatSink

geom_odum_heat_sink(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

GeomOdumTransaction

geom_odum_transaction(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

GeomOdumMoney

geom_odum_money(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  n = 60,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)
```

## Arguments

- mapping, data, stat, position, na.rm, show.legend, inherit.aes, ...:

  Standard ggplot2 layer arguments.

- n:

  Vertex count for curved symbols.

## Value

A ggplot2 layer.

## Details

Geometry follows the canonical reference chart on Wikipedia
(<https://commons.wikimedia.org/wiki/File:Energese.jpg>).

## Symbols

- `geom_odum_source()` — filled circle (renewable / external input)

- `geom_odum_flow()` — bare right-pointing arrow (generic energy flow)

- `geom_odum_storage()` — Bertalanffy module (energy storage)

- `geom_odum_consumer()` — hexagon (consumer / consumption)

- `geom_odum_interaction()` — chevron (multiplicative junction)

- `geom_odum_producer()` — bullet (autocatalytic producer)

- `geom_odum_switch()` — bowtie (on/off logic gate)

- `geom_odum_self_limiter()` — semi-circle (saturating unit)

- `geom_odum_heat_sink()` — down-arrow + ground line (dispersed heat)

- `geom_odum_transaction()` — elongated diamond (money transaction)

## Aesthetics

Required: `x`, `y`. Optional (with sensible defaults): `width`, `height`
for polygonal symbols; `radius` for source, money; `fill`, `colour`,
`alpha`, `linewidth`.
