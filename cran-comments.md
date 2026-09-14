## Test environments
* Local: Linux x86_64, R 4.4.x
* R-hub via `rhub::check_for_cran()`: TBD
* win-builder (devel + release): TBD via `devtools::check_win_devel()`

## R CMD check --as-cran

0 errors | 1 warning | 1 note

Warning:
1. `'qpdf' is needed for checks on size reduction of PDFs` — `qpdf`
   is not installed in the local build environment. CRAN
   infrastructure has it; the warning is expected to disappear on
   CRAN's own check farm.

Note:
1. `checking for future file timestamps ... unable to verify current
   time` — NTP unreachable from the local build environment;
   harmless on CRAN infrastructure.

## Reverse dependencies

None (first release).

## Notes

- The package provides ggplot2 Geoms for H.T. Odum's Energy Systems
  Language (ESL). All 10 canonical symbols per the Wikipedia
  reference chart are implemented as `geom_odum_*` layers.
- No modifications to global state (options, par(), env vars) in
  examples or tests.
- All examples run in under a second each.
- README + vignette figures are pre-rendered (in `man/figures/`) so
  the package builds without a live plotting device.
