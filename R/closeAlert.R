#' Close any open shinyalert modals
#'
#' Close any shinyalert modals that are currently open. The callback functions
#' of the modal are not called when the modal is closed this way.
#' @export
closeAlert <- function() {
  session <- getSession()
  session$sendCustomMessage(type = "shinyalert.close", message = "")
  invisible(NULL)
}
