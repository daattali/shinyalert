% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/useShinyalert.R
\name{useShinyalert}
\alias{useShinyalert}
\title{Set up a Shiny app to use shinyalert}
\usage{
useShinyalert(rmd, force = FALSE)
}
\arguments{
\item{rmd}{Deprecated, do not use this parameter.}

\item{force}{Set to \code{TRUE} to load the {shinyalert} scripts. If \code{FALSE} (default),
you will get a warning saying this function is not required.}
}
\value{
Scripts that \code{shinyalert} requires that are automatically
inserted to the app's \code{<head>} tag.
}
\description{
\strong{This function is no longer required.}\cr\cr
The first time a {shinyalert} message is shown, the required scripts are
automatically inserted to the Shiny app. In real browsers (Chrome/Firefox/etc)
this is not an issue, but in some contexts, such as inside RStudio's Viewer
on some operating systems, this can sometimes cause the modal to appear glitchy
for a brief moment until the scripts load.\cr\cr
If you notice this behaviour and prefer to pre-load the scripts when the Shiny
app initializes, you can call \code{useShinyalert(force=TRUE)} anywhere in the UI.
}
\examples{
if (interactive()) {
  library(shiny)
  library(shinyalert)

  shinyApp(
    ui = fluidPage(
      useShinyalert(force = TRUE),  # Set up shinyalert
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
