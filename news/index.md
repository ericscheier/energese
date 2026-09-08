# Changelog

## energese 0.1.0

Initial CRAN release.

### What’s here

- First R grammar-of-graphics library for H.T. Odum’s Energy Systems
  Language (ESL) — also known as Energese.
- **10 exported ggproto Geoms** matching Wikipedia’s canonical Energese
  reference chart
  (<https://commons.wikimedia.org/wiki/File:Energese.jpg>):
  [`geom_odum_source()`](https://pkg.energese.org/reference/geom_odum.md),
  [`geom_odum_flow()`](https://pkg.energese.org/reference/geom_odum.md),
  [`geom_odum_storage()`](https://pkg.energese.org/reference/geom_odum.md)
  (Bertalanffy module),
  [`geom_odum_consumer()`](https://pkg.energese.org/reference/geom_odum.md),
  [`geom_odum_interaction()`](https://pkg.energese.org/reference/geom_odum.md)
  (chevron),
  [`geom_odum_producer()`](https://pkg.energese.org/reference/geom_odum.md)
  (bullet),
  [`geom_odum_switch()`](https://pkg.energese.org/reference/geom_odum.md)
  (bowtie),
  [`geom_odum_self_limiter()`](https://pkg.energese.org/reference/geom_odum.md)
  (semi-circle),
  [`geom_odum_heat_sink()`](https://pkg.energese.org/reference/geom_odum.md)
  (arrow + ground line),
  [`geom_odum_transaction()`](https://pkg.energese.org/reference/geom_odum.md)
  (elongated diamond).
- Matching low-level `odum_*` vertex-tibble helpers for direct
  [`geom_polygon()`](https://ggplot2.tidyverse.org/reference/geom_polygon.html)
  composition or non-ggplot renderers.
- [`plot_energese_reference()`](https://pkg.energese.org/reference/plot_energese_reference.md)
  — reproduces Wikipedia’s Energese chart directly from R.
- Vignette with worked examples: symbol legend, simple ecosystem,
  interaction junction, small economic system with money transaction.
- README + `inst/CITATION` with the canonical Odum + Brown references.
- Prior-art scan: to the author’s knowledge, this is the first R (or
  Python) grammar-of-graphics ESL library.
