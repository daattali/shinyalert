#' @export
#' @param title The title of the modal.
#' @param text The modal's text.
#' @param type The type of the modal. There are 4 built-in types which will show
#' a corresponding icon: \code{"warning"}, \code{"error"}, \code{"success"} and
#' \code{"info"}. You can also set it to \code{"input"} to get a prompt in the
#' modal where the user can enter a response. By default, the modal has no type.
#' @param closeOnEsc If \code{TRUE} (default), the user can dismiss the modal by
#' pressing the Escape key.
#' @param closeOnClickOutside If \code{TRUE}, the user can dismiss the modal by
#' clicking outside it.
#' @param html If \code{TRUE}, the content of the title and text will not be
#' escaped. By default, the content in the title and text are escaped so any
#' HTML tags will not render as HTML.
#' @param showCancelButton If \code{TRUE}, a "Cancel" button will be shown,
#' which the user can click on to dismiss the modal.
#' @param showConfirmButton If \code{TRUE} (default), a "OK" button will be
#' shown. Make sure to either use \code{timer}, \code{closeOnEsc}, or
#' \code{closeOnClickOutside} to allow the user a way to close the modal.
shinyalert <- function(
  title = "",
  text = "",
  type = c("", "warning", "error", "success", "info", "input"),
  closeOnEsc = TRUE,
  closeOnClickOutside = FALSE,
  html = FALSE,
  showCancelButton = FALSE,
  showConfirmButton = TRUE,



  className = "",
  confirmButtonText = "OK",
  confirmButtonCol = "#AEDEF4",
  cancelButtonText = "Cancel",
  imageUrl = NULL,
  imageWidth = 100,
  imageHeight = 100,
  animation = TRUE,
  inputType = "text",
  inputPlaceholder = "",
  inputValue = "",
  callbackR = NULL,
  callbackJS = NULL
) {

  type <- match.arg(type)
  params <- as.list(environment())

  # Rename some parameters that shinyalert tries to use more sensible names for
  params['customClass'] <- params['className']
  params['allowEscapeKey'] <- params['closeOnEsc']
  params['allowOutsideClick'] <- params['closeOnClickOutside']
  params['confirmButtonColor'] <- params['confirmButtonCol']
  params['imageSize'] <- paste0(params['imageWidth'], "x", params['imageHeight'])
  params['closeOnEsc'] <- NULL
  params['className'] <- NULL
  params['closeOnClickOutside'] <- NULL
  params['confirmButtonCol'] <- NULL
  params['imageWidth'] <- NULL
  params['imageHeight'] <- NULL

  session <- getSession()

  if (!is.null(callbackR)) {
    cbid <- sprintf("shinyalert-%s-%s",
                    digest::digest(params),
                    as.integer(stats::runif(1, 0, 1e9)))
    params['cbid'] <- cbid
    shiny::observeEvent(session$input[[cbid]], {
      if (length(formals(callbackR)) == 0) {
        callbackR()
      } else {
        callbackR(session$input[[cbid]])
      }
    }, once = TRUE)
    params[['callbackR']] <- NULL
  }

  session$sendCustomMessage(type = "shinyalert", message = params)

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
