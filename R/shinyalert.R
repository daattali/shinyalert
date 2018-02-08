#' shinyalert
#'
#' shinyalert
#'
#' @param title The title of the modal.
#' @param text The modal's text.
#' @param type The type of the modal. There are 4 built-in types which will show
#' a corresponding icon: \code{"warning"}, \code{"error"}, \code{"success"} and
#' \code{"info"}. You can also set \code{type="input"} to get a prompt
#' in the modal where the user can enter a response. By default, the modal has
#' no type.
#' @param closeOnEsc If \code{TRUE}, the user can dismiss the modal by
#' pressing the Escape key.
#' @param closeOnClickOutside If \code{TRUE}, the user can dismiss the modal by
#' clicking outside it.
#' @param html If \code{TRUE}, the content of the title and text will not be
#' escaped. By default, the content in the title and text are escaped, so any
#' HTML tags will not render as HTML.
#' @param showCancelButton If \code{TRUE}, a "Cancel" button will be shown,
#' which the user can click on to dismiss the modal.
#' @param showConfirmButton If \code{TRUE}, a "OK" button
#' will be shown. Make sure to either use \code{timer}, \code{closeOnEsc}, or
#' \code{closeOnClickOutside} to allow the user a way to close the modal.
#' @param inputType When using \code{type="input"}, change the type of the input
#' field. The input type can be \code{"number"}, \code{"text"},
#' \code{"password"}, or any other valid HTML input type.
#' @param inputValue When using \code{type="input"}, specify a default
#' value that you want the input to show initially.
#' @param inputPlaceholder When using \code{type="input"}, specify a placeholder
#' text in the input.
#' @param confirmButtonText The text in the "OK" button.
#' @param confirmButtonCol The background colour of the "OK" button
#' (must be a HEX value).
#' @param cancelButtonText The text in the "Cancel" button.
#' @param animation If \code{FALSE}, the modal's animation will be disabled.
#' Possible values: \code{FALSE}, \code{TRUE}, \code{"slide-from-top"},
#' \code{"slide-from-bottom"}, \code{"pop"} (the default animation when
#' \code{animation=TRUE}).
#' @param imageUrl Add a custom icon to the modal.
#' @param imageWidth Width of the custom image icon, in pixels.
#' @param imageHeight Height of the custom image icon, in pixels.
#' @param className A custom CSS class name for the modal's container.
#' @param callbackR An R function to call when the modal exits. The value of the
#' modal is passed to this function as an argument. When there is no input field
#' in the modal, the value of the modal is either \code{TRUE} or \code{FALSE}
#' depending if the user clicked "OK" or exited/canceled the modal. When there
#' is an input field, the value of the modal is the value the user entered.
#' @param callbackJS A JavaScript function to call when the modal exits. The
#' value of the modal is passed to this function as an argument. See the
#' \code{callbackR} arugment for more information on the value of the modal.
#'
#' You can retrieve the value of the modal with \code{input$shinyalert}.
#' @export
shinyalert <- function(
  title = "",
  text = "",
  type = c("", "warning", "error", "success", "info", "input"),
  closeOnEsc = TRUE,
  closeOnClickOutside = FALSE,
  html = FALSE,
  showCancelButton = FALSE,
  showConfirmButton = TRUE,
  inputType = "text",
  inputValue = "",
  inputPlaceholder = "",
  confirmButtonText = "OK",
  confirmButtonCol = "#AEDEF4",
  cancelButtonText = "Cancel",
  animation = TRUE,
  imageUrl = NULL,
  imageWidth = 100,
  imageHeight = 100,
  className = "",
  callbackR = NULL,
  callbackJS = NULL
) {

  type <- match.arg(type)
  params <- as.list(environment())

  # Rename some parameters that shinyalert tries to use more sensible names for
  params[['customClass']] <- params[['className']]
  params[['allowEscapeKey']] <- params[['closeOnEsc']]
  params[['allowOutsideClick']] <- params[['closeOnClickOutside']]
  params[['confirmButtonColor']] <- params[['confirmButtonCol']]
  params[['imageSize']] <- paste0(params[['imageWidth']], "x", params[['imageHeight']])
  params[['closeOnEsc']] <- NULL
  params[['className']] <- NULL
  params[['closeOnClickOutside']] <- NULL
  params[['confirmButtonCol']] <- NULL
  params[['imageWidth']] <- NULL
  params[['imageHeight']] <- NULL

  session <- getSession()

  # If an R callback function is provided, create an observer for it
  if (!is.null(callbackR)) {
    cbid <- sprintf("shinyalert-%s-%s",
                    digest::digest(params),
                    as.integer(stats::runif(1, 0, 1e9)))
    params[['cbid']] <- session$ns(cbid)
    shiny::observeEvent(session$input[[cbid]], {
      if (length(formals(callbackR)) == 0) {
        callbackR()
      } else {
        callbackR(session$input[[cbid]])
      }
    }, once = TRUE)
    params[['callbackR']] <- NULL
  }

  params[["returnId"]] <- session$ns("shinyalert")
  session$sendCustomMessage(type = "shinyalert.show", message = params)

  invisible(NULL)
}

#' The callback functions are not called when the modal is forced to close.
#' @export
close_alert <- function() {
  session <- getSession()
  session$sendCustomMessage(type = "shinyalert.close", message = "")
  invisible(NULL)
}

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
