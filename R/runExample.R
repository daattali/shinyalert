#' Run shinyalert example
#'
#' Launch an example Shiny app that shows how easy it is to
#' create modals with \code{shinyalert}.\cr\cr
#' The demo app is also
#' \href{http://daattali.com/shiny/shinyalert-demo/}{available online}
#' to experiment with.
#' @export
runExample <- function() {
  appDir <- system.file("examples", "demo", package = "shinyalert")
  shiny::runApp(appDir, display.mode = "normal")
}
