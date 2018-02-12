% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/useShinyalert.R
\name{useShinyalert}
\alias{useShinyalert}
\title{Set up a Shiny app to use shinyalert}
\usage{
useShinyalert()
}
\value{
Scripts that \code{shinyalert} requires that are automatically
inserted to the app's \code{<head>} tag.
}
\description{
This function must be called from a Shiny app's UI in order for the
\code{\link[shinyalert]{shinyalert}} function to work.\cr\cr
You can call \code{useShinyalert()} from anywhere inside the UI.
}
\examples{
if (interactive()) {
  library(shiny)
  library(shinyalert)

  shinyApp(
    ui = fluidPage(
      useShinyalert(),  # Set up shinyalert
      actionButton("btn", "Click me")
    ),
    server = function(input, output) {
      observeEvent(input$btn, {
        # Show a simple modal
        shinyalert(title = "You did it!", type = "success")
      })
    }
  )
}
}
\seealso{
\code{\link[shinyalert]{shinyalert}}
}