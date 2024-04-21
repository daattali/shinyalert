getSession <- function() {
  session <- shiny::getDefaultReactiveDomain()

  if (is.null(session)) {
    stop("Could not find a Shiny session object", call. = FALSE)
  }

  session
}

getDependencies <- function() {
  list(
    htmltools::htmlDependency(
      name = "sweetalert-js",
      version = "1.0.1",
      package = "shinyalert",
      src = "assets/lib/sweetalert-1.0.1",
      script = "js/sweetalert.min.js",
      stylesheet = "css/sweetalert.min.css"
    ),
    htmltools::htmlDependency(
      name = "swalservice-js",
      version = "1.0.0",
      package = "shinyalert",
      src = "assets/lib/swalservice",
      script = "swalservice.js"
    ),
    htmltools::htmlDependency(
      name = "shinyalert-binding",
      version = as.character(utils::packageVersion("shinyalert")),
      package = "shinyalert",
      src = "assets/shinyalert",
      script = "shinyalert.js",
      stylesheet = "shinyalert.css"
    )
  )
}
