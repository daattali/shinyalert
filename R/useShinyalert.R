#' Set up a Shiny app to use shinyalert
#'
#' **This function is no longer required.**\cr\cr
#' The first time a {shinyalert} message is shown, the required scripts are
#' automatically inserted to the Shiny app. In real browsers (Chrome/Firefox/etc)
#' this is not an issue, but in some contexts, such as inside RStudio's Viewer
#' on some operating systems, this can sometimes cause the modal to appear glitchy
#' for a brief moment until the scripts load.\cr\cr
#' If you notice this behaviour and prefer to pre-load the scripts when the Shiny
#' app initializes, you can call `useShinyalert(force=TRUE)` anywhere in the UI.
#'
#' @param rmd Deprecated, do not use this parameter.
#' @param force Set to `TRUE` to load the {shinyalert} scripts. If `FALSE` (default),
#' you will get a warning saying this function is not required.
#' @return Scripts that \code{shinyalert} requires that are automatically
#' inserted to the app's \code{<head>} tag.
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(shinyalert)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyalert(force = TRUE),  # Set up shinyalert
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
useShinyalert <- function(rmd, force = FALSE) {
  if (!missing(rmd)) {
    stop(
      "The `rmd` parameter of `useShinyalert()` is no longer needed. Please remove it from your code.\n",
      call. = FALSE
    )
  }
  if (force) {
    return(getDependencies())
  } else {
    warning(
      "Good news!\nYou don't need to call `useShinyalert()` anymore. Please remove this line from your code.\n",
      "If you really want to pre-load {shinyalert} to the UI for performance reasons, use:\n",
      "\t`useShinyalert(force = TRUE)`",
      call. = FALSE,
      immediate. = TRUE
    )
    invisible(NULL)
  }
}
