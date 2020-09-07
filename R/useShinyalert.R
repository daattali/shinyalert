#' Set up a Shiny app to use shinyalert
#'
#' This function must be called from a Shiny app's UI in order for the
#' \code{\link[shinyalert]{shinyalert}} function to work.\cr\cr
#' You can call \code{useShinyalert()} from anywhere inside the UI.
#'
#' @param rmd Set this to \code{TRUE} if using \code{shinyalert}
#' inside an interactive R markdown document. The YAML of the Rmd file must have
#' \code{runtime: shiny}.
#' @return Scripts that \code{shinyalert} requires that are automatically
#' inserted to the app's \code{<head>} tag.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(shinyalert)
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
useShinyalert <- function(rmd = FALSE) {
  stopifnot(rmd == TRUE || rmd == FALSE)

  shiny::addResourcePath("resources",
                         system.file("www", package = "shinyalert"))
  insert_into_doc <- if (rmd) shiny::tagList else shiny::tags$head

  shiny::singleton(
    insert_into_doc(
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
        src = file.path("resources", "shared", "swalservice",
                        "swalservice.min.js")
      ),
      shiny::tags$script(
        src = file.path("resources", "srcjs", "shinyalert.js")
      ),
      shiny::tags$link(
        rel = "stylesheet",
        href = file.path("resources", "css", "shinyalert.css")
      )
    )
  )
}
