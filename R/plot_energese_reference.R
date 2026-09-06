#' Plot the canonical Energese reference chart
#'
#' Reproduces Wikipedia's canonical H.T. Odum Energy Systems Language
#' symbol legend (\url{https://commons.wikimedia.org/wiki/File:Energese.jpg},
#' Sholto Maud's Visio stencil) using this package's ggplot2 Geoms.
#' All ten symbols are drawn in the same top-to-bottom order as the
#' Wikipedia chart, each in its own rounded box with its canonical
#' label below.
#'
#' Use this to confirm that the package produces faithful Odum ESL
#' geometry, or as a "cheat sheet" figure in publications.
#'
#' @return A `ggplot` object.
#' @examples
#' plot_energese_reference()
#' @export
plot_energese_reference <- function() {
  # 10 symbols, top → bottom (matching Wikipedia's Energese.jpg order)
  symbols <- data.frame(
    y   = seq(10, 1),
    name = c("\"Source\"",  "Generic\nFlow", "\"Store\"",
              "\"Consumption\"", "\"Interaction\"", "\"Production\"",
              "\"Switch\"", "\"Self-Limiter\"", "Energy\nLoss",
              "\"Transaction\""),
    kind = c("source", "flow", "storage", "consumer", "interaction",
              "producer", "switch", "self_limiter", "heat_sink",
              "transaction"),
    stringsAsFactors = FALSE)

  # Rounded-box background for each symbol row (matches Wikipedia style)
  bg <- data.frame(
    xmin = -1.6, xmax = 1.6,
    ymin = symbols$y - 0.42, ymax = symbols$y + 0.42)

  p <- ggplot2::ggplot() +
    # Row backgrounds
    ggplot2::geom_rect(data = bg,
      ggplot2::aes(xmin = xmin, xmax = xmax,
                   ymin = ymin, ymax = ymax),
      fill = "grey96", colour = "grey70", linewidth = 0.25) +
    # Header banner
    ggplot2::geom_rect(
      ggplot2::aes(xmin = -1.6, xmax = 1.6, ymin = 10.7, ymax = 11.3),
      fill = "white", colour = "grey40", linewidth = 0.35) +
    ggplot2::annotate("text", x = 0, y = 11.0,
                       label = "\"Energese\"",
                       fontface = "italic", size = 6, colour = "grey15")

  # Add each symbol at its row
  sym_data <- function(k) subset(symbols, kind == k)

  # Source (row 10)
  r <- sym_data("source")
  p <- p + geom_odum_source(data = r,
    ggplot2::aes(x = 0, y = y), radius = 0.28,
    fill = "white", colour = "grey20")

  # Flow (row 9)
  r <- sym_data("flow")
  p <- p + geom_odum_flow(data = r,
    ggplot2::aes(x = 0, y = y), width = 0.9, height = 0.35,
    fill = "grey20", colour = "grey20")

  # Storage (row 8)
  r <- sym_data("storage")
  p <- p + geom_odum_storage(data = r,
    ggplot2::aes(x = 0, y = y), width = 0.85, height = 0.6,
    fill = "white", colour = "grey20")

  # Consumer (row 7)
  r <- sym_data("consumer")
  p <- p + geom_odum_consumer(data = r,
    ggplot2::aes(x = 0, y = y), width = 0.85, height = 0.6,
    fill = "white", colour = "grey20")

  # Interaction (row 6)
  r <- sym_data("interaction")
  p <- p + geom_odum_interaction(data = r,
    ggplot2::aes(x = 0, y = y), width = 0.95, height = 0.55,
    fill = "white", colour = "grey20")

  # Producer (row 5)
  r <- sym_data("producer")
  p <- p + geom_odum_producer(data = r,
    ggplot2::aes(x = 0, y = y), width = 0.95, height = 0.55,
    fill = "white", colour = "grey20")

  # Switch (row 4)
  r <- sym_data("switch")
  p <- p + geom_odum_switch(data = r,
    ggplot2::aes(x = 0, y = y), width = 0.6, height = 0.55,
    fill = "white", colour = "grey20")

  # Self-limiter (row 3)
  r <- sym_data("self_limiter")
  p <- p + geom_odum_self_limiter(data = r,
    ggplot2::aes(x = 0, y = y), width = 0.5, height = 0.55,
    fill = "white", colour = "grey20")

  # Heat sink (row 2)
  r <- sym_data("heat_sink")
  p <- p + geom_odum_heat_sink(data = r,
    ggplot2::aes(x = 0, y = y), width = 0.55, height = 0.55,
    fill = "grey40", colour = "grey20")

  # Transaction (row 1) — diamond with $ label
  r <- sym_data("transaction")
  p <- p + geom_odum_transaction(data = r,
    ggplot2::aes(x = 0, y = y), width = 1.0, height = 0.32,
    fill = "white", colour = "grey20") +
    ggplot2::annotate("text", x = 0, y = 1.32, label = "$",
                       size = 3.5, fontface = "bold")

  # Symbol labels below each row (except header)
  p <- p + ggplot2::geom_text(data = symbols,
    ggplot2::aes(x = 0, y = y - 0.30, label = name),
    size = 2.8, colour = "grey20", vjust = 1, lineheight = 0.85)

  # Side banner (like Wikipedia's rotated title on the left)
  p <- p +
    ggplot2::annotate("text", x = -1.85, y = 5.5,
      label = "H.T. Odum's System of Generic Symbols\n(Energy Circuit / Systems Language Symbols)",
      angle = 90, size = 2.8, colour = "grey20", lineheight = 0.9) +
    ggplot2::annotate("text", x = 1.85, y = 5.5,
      label = "Reproduced from Wikipedia's Energese chart\n(commons.wikimedia.org/wiki/File:Energese.jpg)",
      angle = -90, size = 2.4, colour = "grey40", lineheight = 0.9) +
    ggplot2::coord_fixed(xlim = c(-2.1, 2.1), ylim = c(0.3, 11.6),
                          expand = FALSE, ratio = 1.6) +
    ggplot2::theme_void()
  p
}
