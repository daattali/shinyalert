getSession <- function() {
  session <- shiny::getDefaultReactiveDomain()

  if (is.null(session)) {
    stop("Could not find a Shiny session object", call. = FALSE)
  }

  session
}
