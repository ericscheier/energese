# energese 0.1.0

Initial CRAN release.

## What's here

* First R grammar-of-graphics library for H.T. Odum's Energy
  Systems Language (ESL) — also known as Energese.
* **10 exported ggproto Geoms** matching Wikipedia's canonical
  Energese reference chart
  (<https://commons.wikimedia.org/wiki/File:Energese.jpg>):
  `geom_odum_source()`, `geom_odum_flow()`, `geom_odum_storage()`
  (Bertalanffy module), `geom_odum_consumer()`,
  `geom_odum_interaction()` (chevron), `geom_odum_producer()`
  (bullet), `geom_odum_switch()` (bowtie),
  `geom_odum_self_limiter()` (semi-circle),
  `geom_odum_heat_sink()` (arrow + ground line),
  `geom_odum_transaction()` (elongated diamond).
* Matching low-level `odum_*` vertex-tibble helpers for direct
  `geom_polygon()` composition or non-ggplot renderers.
* `plot_energese_reference()` — reproduces Wikipedia's Energese
  chart directly from R.
* Vignette with worked examples: symbol legend, simple ecosystem,
  interaction junction, small economic system with money
  transaction.
* README + `inst/CITATION` with the canonical Odum + Brown
  references.
* Prior-art scan: to the author's knowledge, this is the first R
  (or Python) grammar-of-graphics ESL library.
