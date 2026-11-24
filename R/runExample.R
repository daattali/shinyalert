#' Run shinyalert example
#'
#' Launch an example Shiny app that shows how easy it is to
#' create modals with \code{shinyalert}.\cr\cr
#' The demo app is also
#' \href{https://daattali.com/shiny/shinyalert-demo/}{available online}
#' to experiment with.
#'
#' @details
#' With Shiny 1.8.1 or later, use
#' `shiny::runExample("demo", package = "shinyalert")`.
#' This wrapper also works with earlier Shiny versions.
#' @export
runExample <- function() {
  appDir <- system.file("examples-shiny", "demo", package = "shinyalert")
  shiny::runApp(appDir, display.mode = "normal")
}
