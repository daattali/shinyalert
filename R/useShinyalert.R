#' Set up a Shiny app to use shinyalert
#'
#' **This function is no longer required.**\cr\cr
#' The first time a \{shinyalert\} message is shown, the required scripts are
#' *automatically* inserted to the Shiny app. Usually this is not an issue, but
#' in some unique cases this can sometimes cause the modal to appear glitchy
#' (such as inside RStudio's Viewer, on some old browsers, or if the modal contains
#' certain Shiny inputs).\cr\cr
#' If you notice issues with the UI of the modal, you may want to try to pre-load
#' the scripts when the Shiny app initializes by calling `useShinyalert(force=TRUE)`
#' anywhere in the UI.
#'
#' @param rmd Deprecated, do not use this parameter.
#' @param force Set to `TRUE` to force pre-loading the \{shinyalert\} scripts. If
#' `FALSE` (default), you will get a warning saying this function is not required.
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
      "If you really want to pre-load {shinyalert} to the UI for any reason, use:\n",
      "\t`useShinyalert(force = TRUE)`",
      call. = FALSE,
      immediate. = TRUE
    )
    invisible(NULL)
  }
}
