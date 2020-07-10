#' Display a popup message (modal) in Shiny
#'
#' A modal can contain text, images, OK/Cancel buttons, an input to get a
#' response from the user, and many more customizable options. The value of the
#' modal can be retrieved in Shiny using \code{input$shinyalert} or using the
#' two callback parameters. See the
#' \href{https://daattali.com/shiny/shinyalert-demo/}{demo Shiny app}
#' online for examples or read the
#' \href{https://github.com/daattali/shinyalert#readme}{full README}.\cr\cr
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
#' modal. See the 'Modal return value' section below.
#' @param animation If \code{FALSE}, the modal's animation will be disabled.
#' Possible values: \code{FALSE}, \code{TRUE}, \code{"slide-from-top"},
#' \code{"slide-from-bottom"}, \code{"pop"} (the default animation when
#' \code{animation=TRUE}).
#' @param imageUrl Add a custom icon to the modal.
#' @param imageWidth Width of the custom image icon, in pixels.
#' @param imageHeight Height of the custom image icon, in pixels.
#' @param className A custom CSS class name for the modal's container.
#' @param callbackR An R function to call when the modal exits. See the
#' 'Modal return value' and 'Callbacks' sections below.
#' @param callbackJS A JavaScript function to call when the modal exits. See the
#' 'Modal return value' and 'Callbacks' sections below.
#' @param inputId The input ID that will be used to retrieve the value of this
#' modal (defualt: \code{"shinyalert"}). You can access the value of the modal
#' with \code{input$<inputId>}.
#' @section Input modals:
#' Usually the purpose of a modal is simply informative, to show some
#' information to the user. However, the modal can also be used to retrieve an
#' input from the user by setting the \code{type = "input"} parameter.
#'
#' Only a single input can be used inside a modal. By default, the input will be
#' a text input, but you can use other HTML input types by specifying the
#' \code{inputType} parameter. For example, \code{inputType = "number"} will
#' provide the user with a numeric input in the modal.
#'
#' See the 'Modal return value' and 'Callbacks' sections below for information
#' on how to access the value entered by the user.
#'
#' @section Modal return value:
#' Modals created with \code{shinyalert} have a return value when they exit.
#'
#' When there is an input field in the modal (\code{type="input"}), the value of
#' the modal is the value the user entered. When there is no input field in the
#' modal, the value of the modal is \code{TRUE} if the user clicked the "OK"
#' button, and \code{FALSE} if the user clicked the "Cancel" button.
#'
#' When the user exits the modal using the Escape key or by clicking outside of
#' the modal, the return value is \code{FALSE} (as if the "Cancel" button was
#' clicked). If the \code{timer} parameter is used and the modal closes
#' automatically as a result of the timer, no value is returned from the modal.
#'
#' The return value of the modal can be accessed via \code{input$shinyalert}
#' (or using a different input ID if you specify the \code{inputId} parameter)
#' in the Shiny server's code, as if it were a regular Shiny input. The return
#' value can also be accessed using the modal callbacks (see below).
#'
#' @section Callbacks:
#' The return value of the modal is passed as an argument to the \code{callbackR}
#' and \code{callbackJS} functions (if a \code{callbackR} or \code{callbackJS}
#' arguments are provided). These are functions that get called, either in R or
#' in JavaScript, when the modal exits.
#'
#' For example, using the following \code{shinyalert} code will result in a
#' modal with an input field. After the user clicks "OK", a hello message will
#' be printed to both the R console and in a native JavaScript alert box. You
#' don't need to provide both callback functions, but in this example both are
#' used for demonstration.
#'
#' \preformatted{
#'   shinyalert(
#'     "Enter your name", type = "input",
#'     callbackR = function(x) { message("Hello ", x) },
#'     callbackJS = "function(x) { alert('Hello ' + x); }"
#'   )
#' }
#' Notice that the \code{callbackR} function accepts R code, while the
#' \code{callbackJS} function uses JavaScript code.
#'
#' Since closing the modal with the Escape key results in a return value of
#' \code{FALSE}, the callback functions can be modified to not print hello in
#' that case.
#'
#' \preformatted{
#'   shinyalert(
#'     "Enter your name", type = "input",
#'     callbackR = function(x) { if(x != FALSE) message("Hello ", x) },
#'     callbackJS = "function(x) { if (x !== false) { alert('Hello ' + x); } }"
#'   )
#' }
#'
#' @section Chaining modals:
#' It's possible to chain modals (call multiple modals one after another) by
#' making a \code{shinyalert()} call inside a shinyalert callback or using the
#' return value of a previous modal. For example:
#'
#' \preformatted{
#'   shinyalert(
#'     title = "What is your name?", type = "input",
#'     callbackR = function(value) { shinyalert(paste("Welcome", value)) }
#'   )
#' }
#' @seealso \code{\link[shinyalert]{useShinyalert}}
#' @examples
#'
#' # Example 1: Simple modal
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
#'
#' # Example 2: Input modal calling another modal in its callback
#' if (interactive()) {
#'   library(shiny)
#'   library(shinyalert)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       useShinyalert(),  # Set up shinyalert
#'       actionButton("btn", "Greet")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$btn, {
#'         shinyalert(
#'           title = "What is your name?", type = "input",
#'           callbackR = function(value) { shinyalert(paste("Welcome", value)) }
#'         )
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
  callbackJS = NULL,
  inputId = "shinyalert"
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
    cbid <- paste0("__shinyalert-", gsub("-", "", uuid::UUIDgenerate()))
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

  params[["inputId"]] <- session$ns(params[["inputId"]])
  session$sendCustomMessage(type = "shinyalert.show", message = params)

  invisible(NULL)
}
