#' Set up a Shiny app to use shinyalert
#'
#' This function must be called from a Shiny app's UI in order for the
#' \code{\link[shinyalert]{shinyalert()}} function to work.\cr\cr
#' You can call \code{useShinyalert()} from anywhere inside the UI.
#'
#' @return Scripts that \code{shinyalert} requires that are automatically
#' inserted to the app's \code{<head>} tag.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyalert(),  # Set up shinyalert
#'       actionButton("btn", "Click me")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$btn, {
#'         # Show a simple modal
#'         shinyalert(title = "You did it!", type = "success")
#'       })
#'     }
#'   )
#' }
#' @seealso \code{\link[shinyalert]{shinyalert}}
#' @export
useShinyalert <- function() {
  shiny::addResourcePath("resources",
                         system.file("www", package = "shinyalert"))

  shiny::singleton(
    shiny::tags$head(
      shiny::tags$script(
        src = file.path("resources", "shared", "sweetalert-1.0.1",
                        "js", "sweetalert.min.js")
      ),
      shiny::tags$link(
        rel = "stylesheet",
        href = file.path("resources", "shared", "sweetalert-1.0.1",
                         "css", "sweetalert.min.css")
      ),
      shiny::tags$script(
        src = file.path("resources", "srcjs", "shinyalert.js")
      )
    )
  )
}
