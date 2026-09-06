# Contributing to energese

Thanks for your interest! `energese` is a small, focused package
implementing H.T. Odum’s Energy Systems Language (ESL) as `ggplot2`
layers. The scope is intentionally narrow:

- Faithful geometry for Odum’s canonical symbols (as documented in
  Wikipedia’s Energese chart and Odum 1994).
- Grammar-of-graphics idiom (proper `Geom*` ggproto layers with standard
  aesthetics).
- Zero heavy dependencies (only `ggplot2` and `tibble` in Imports).

## Development flow

``` r

# fork + clone, then:
devtools::install_deps()
devtools::document()
devtools::test()
devtools::check()

# to preview the pkgdown site locally
pkgdown::build_site()
```

## Pull request guidelines

- One geometry change or new symbol per PR (keeps review tractable).
- Add / update the corresponding vertex-helper test in
  `tests/testthat/test-odum_symbols.R` and the Geom-composition test in
  `tests/testthat/test-geom_odum.R`.
- Match the canonical Odum geometry where one exists (cite the Wikipedia
  chart or the Odum book page).
- Keep exports curated — don’t proliferate helper functions.

## Reporting bugs

Please open an issue with a minimal
`library(energese); library(ggplot2); …` reproducer +
[`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html). Visual bugs
→ attach the PNG.

## Code of conduct

Please note that this project is released with a [Contributor Code of
Conduct](https://ericscheier.github.io/energese/CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.
