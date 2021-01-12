getSession <- function() {
  session <- shiny::getDefaultReactiveDomain()

  if (is.null(session)) {
    stop("Could not find a Shiny session object", call. = FALSE)
  }

  session
}

getDependencies <- function() {
  shiny::addResourcePath("shinyalert-assets",
                         system.file("www", package = "shinyalert"))

  runtime <- knitr::opts_knit$get("rmarkdown.runtime")
  if (!is.null(runtime) && runtime == "shiny") {
    # we're inside an Rmd document
    insert_into_doc <- shiny::tagList
  } else {
    # we're in a shiny app
    insert_into_doc <- shiny::tags$head
  }

  shiny::singleton(
    insert_into_doc(
      shiny::tags$script(
        src = file.path("shinyalert-assets", "shared", "sweetalert-1.0.1",
                        "js", "sweetalert.min.js")
      ),
      shiny::tags$link(
        rel = "stylesheet",
        href = file.path("shinyalert-assets", "shared", "sweetalert-1.0.1",
                         "css", "sweetalert.min.css")
      ),
      shiny::tags$script(
        src = file.path("shinyalert-assets", "shared", "swalservice",
                        "swalservice.min.js")
      ),
      shiny::tags$script(
        src = file.path("shinyalert-assets", "srcjs", "shinyalert.js")
      ),
      shiny::tags$link(
        rel = "stylesheet",
        href = file.path("shinyalert-assets", "css", "shinyalert.css")
      )
    )
  )
}
