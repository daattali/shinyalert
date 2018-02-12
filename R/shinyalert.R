#' Display a popup message (modal) in Shiny
#'
#' A modal can contain text, images, OK/Cancel buttons, an input to get a
#' response from the user, and many more customizable options. The value of the
#' modal can be retrieved in Shiny using \code{input$shinyalert} or using the
#' two callback parameters. See the
#' \href{https://daattali.com/shiny/shinyalert-demo/}{demo Shiny app}
#' online for examples.\cr\cr
#' \code{shinyalert} must be initialized with a call to
#' \code{\link[shinyalert]{useShinyalert}} in the app's UI.
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
#' will be shown. If \code{FALSE}, make sure to either use \code{timer},
#' \code{closeOnEsc}, or \code{closeOnClickOutside} to allow the user a way to
#' close the modal.
#' @param inputType When using \code{type="input"}, change the type of the input
#' field. The input type can be \code{"number"}, \code{"text"},
#' \code{"password"}, or any other valid HTML input type.
#' @param inputValue When using \code{type="input"}, specify a default
#' value that you want the input to show initially.
#' @param inputPlaceholder When using \code{type="input"}, specify a placeholder
#' text for the input.
#' @param confirmButtonText The text in the "OK" button.
#' @param confirmButtonCol The background colour of the "OK" button
#' (must be a HEX value).
#' @param cancelButtonText The text in the "Cancel" button.
#' @param timer The amount of time (in milliseconds) before the modal should
#' close automatically. Use \code{0} to not close the modal automatically
#' (default). If the modal closes automatically, no value is returned from the
#' modal. See the section 'Callbacks and return value' below.
#' @param animation If \code{FALSE}, the modal's animation will be disabled.
#' Possible values: \code{FALSE}, \code{TRUE}, \code{"slide-from-top"},
#' \code{"slide-from-bottom"}, \code{"pop"} (the default animation when
#' \code{animation=TRUE}).
#' @param imageUrl Add a custom icon to the modal.
#' @param imageWidth Width of the custom image icon, in pixels.
#' @param imageHeight Height of the custom image icon, in pixels.
#' @param className A custom CSS class name for the modal's container.
#' @param callbackR An R function to call when the modal exits. See the section
#' 'Callbacks and return value' below.
#' @param callbackJS A JavaScript function to call when the modal exits. See the
#' section 'Callbacks and return value' below.
#' @section Callbacks and return value:
#' Usually the purpose of a modal is simply informative, to show some
#' information to the user. However, the modal can also have a return value.
#' When there is an input field in the modal, the value of the modal is the
#' value the user entered. When there is no input field in the modal, the value
#' of the modal is \code{TRUE} if the user clicked the "OK" button, and
#' \code{FALSE} if the user clicked the "Cancel" button.
#'
#' When the user exits the modal using the Escape key or by clicking outside
#' of the modal, the return value is \code{FALSE}. If a timer is used to close
#' the modal, no value is returned from the modal.
#'
#' The return value of the modal can be accessed via \code{input$shinyalert}
#' in the Shiny server's code. The return value of the modal is also passed as
#' an argument to the \code{callbackR} and \code{callbackJS} functions if they
#' are provided. For example, using \code{callbackR=function(x) message(x)}
#' will print the return value of the modal to the R console as a message, and
#' \code{callbackJS='function(x) {alert(x);}'} will cause a native JavaScript
#' alert message to show the return value.
#' @seealso \code{\link[shinyalert]{useShinyalert}}
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   library(shinyalert)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyalert(),  # Set up shinyalert
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
#' @export
shinyalert <- function(
  title = "",
  text = "",
  type = "",
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
  timer = 0,
  animation = TRUE,
  imageUrl = NULL,
  imageWidth = 100,
  imageHeight = 100,
  className = "",
  callbackR = NULL,
  callbackJS = NULL
) {

  params <- as.list(environment())

  if (timer < 0) {
    stop("timer cannot be negative.", call. = FALSE)
  }
  if (!type %in% c("", "warning", "error", "success", "info", "input")) {
    stop("type=", type, " is not supported.", call. = FALSE)
  }
  if (!is.null(imageUrl) && imageUrl == "") {
    imageUrl <- NULL
  }

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
