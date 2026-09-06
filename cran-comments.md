# cran-comments.md

## Release summary

odumesl 0.1.0 — initial CRAN submission.

odumesl adds ggplot2 layers for the seven canonical symbols of
H.T. Odum's Energy Systems Language (source circles, producer
bullet-nosed hexagons, consumer hexagons, storage bullet-tanks,
interaction diamonds, heat-sink triangles, money transaction
nodes). To the author's knowledge this is the first
grammar-of-graphics R (or Python) implementation of ESL — a visual
vocabulary widely used across systems ecology and emergy accounting
since Odum 1971.

## Test environments

* Local: Ubuntu 22.04, R 4.3.x
* R-hub (planned): Windows Server, macOS, Ubuntu-devel
* win-builder (planned): R-devel + R-release

## R CMD check results

0 errors ✓
0 warnings ✓
0 notes ✓ (or: 1 note re: new submission)

## Downstream dependencies

None (this is a new package).

## Prior art / novelty

Deep scan of CRAN, GitHub, PyPI, and the biennial *Emergy Synthesis*
proceedings found no other grammar-of-graphics ESL library. Closest
peers are the abandoned Java EmSim (an ODE integrator, no rendering)
and the TypeScript GUI editor sholtomaud/odum-energy-language.
Details in the vignette + README.

## Reverse dependencies

None (new package).
