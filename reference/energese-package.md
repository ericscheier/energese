# energese: ggplot2 Layers for H.T. Odum's Energy Systems Language

Provides grammar-of-graphics ggplot2 layers for H.T. Odum's Energy
Systems Language (ESL) — also known as **Energese**, *Energy Circuit
Language*, or *Generic Systems Symbols*. Odum developed the language in
the 1950s during tropical-forest studies at El Verde, Puerto Rico (Odum
& Pigeon 1970, funded by the U.S. Atomic Energy Commission).

## Details

Every canonical symbol on Wikipedia's Energese reference chart
(<https://commons.wikimedia.org/wiki/File:Energese.jpg>) is exposed:

- [`geom_odum_source()`](https://ericscheier.github.io/energese/reference/geom_odum.md)
  — circle (renewable / external input)

- [`geom_odum_flow()`](https://ericscheier.github.io/energese/reference/geom_odum.md)
  — bare arrow (generic flow)

- [`geom_odum_storage()`](https://ericscheier.github.io/energese/reference/geom_odum.md)
  — Bertalanffy module

- [`geom_odum_consumer()`](https://ericscheier.github.io/energese/reference/geom_odum.md)
  — hexagon (consumer)

- [`geom_odum_interaction()`](https://ericscheier.github.io/energese/reference/geom_odum.md)
  — chevron (multiplicative junction)

- [`geom_odum_producer()`](https://ericscheier.github.io/energese/reference/geom_odum.md)
  — bullet (autocatalytic producer)

- [`geom_odum_switch()`](https://ericscheier.github.io/energese/reference/geom_odum.md)
  — bowtie (logic gate)

- [`geom_odum_self_limiter()`](https://ericscheier.github.io/energese/reference/geom_odum.md)
  — semi-circle (saturating unit)

- [`geom_odum_heat_sink()`](https://ericscheier.github.io/energese/reference/geom_odum.md)
  — down-arrow + ground line (heat sink)

- [`geom_odum_transaction()`](https://ericscheier.github.io/energese/reference/geom_odum.md)
  — elongated diamond (money transaction)

See
[`plot_energese_reference()`](https://ericscheier.github.io/energese/reference/plot_energese_reference.md)
for a single function that reproduces Wikipedia's canonical chart.

Two APIs are exposed:

- **High-level (recommended)** — the ggplot2 Geoms above, with standard
  aesthetics. Vectorised over data rows; composable in a
  [`ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
  pipeline like any other ggplot2 layer.

- **Low-level** — vertex-tibble helpers
  ([odum_symbols](https://ericscheier.github.io/energese/reference/odum_symbols.md))
  that return `(x, y, id)` coordinates suitable for
  [`ggplot2::geom_polygon()`](https://ggplot2.tidyverse.org/reference/geom_polygon.html).
  Use these when you want to hand-compose polygons, animate with
  `gganimate`, or render outside ggplot2.

## Prior art

To the author's knowledge, `energese` is the first R (or Python)
grammar-of-graphics library for ESL. The closest peers are the
now-abandoned Java `EmSim` (an ODE integrator, no rendering API), the
TypeScript GUI editor
<https://github.com/sholtomaud/odum-energy-language> (Sholto Maud, who
also produced the Visio stencil that Wikipedia's Energese chart is based
on), and static SVG reference libraries from the UF Center for
Environmental Policy. See the vignette
([`vignette("energese")`](https://ericscheier.github.io/energese/articles/energese.md))
for a full worked example and prior-art scan.

## References

- Odum, H.T. & Pigeon, R.F. (eds.) (1970). *A Tropical Rain Forest: A
  Study of Irradiation and Ecology at El Verde, Puerto Rico*.

- Odum, H.T. (1994). *Ecological and General Systems: An Introduction to
  Systems Ecology*. Rev. ed.

- Odum, H.T. & Odum, E.C. (2000). *Modeling for All Scales*.

- Odum, H.T. (2007). *Environment, Power, and Society for the
  Twenty-First Century: The Hierarchy of Energy*.

- Brown, M.T. (2004). "A picture is worth a thousand words: energy
  systems language and simulation." *Ecological Modelling* 178: 83-100.
  [doi:10.1016/j.ecolmodel.2003.12.008](https://doi.org/10.1016/j.ecolmodel.2003.12.008)

## See also

The Wikipedia article on [Energy Systems
Language](https://en.wikipedia.org/wiki/Energy_systems_language).

## Author

**Maintainer**: Eric Scheier <hello@emrgi.com>
