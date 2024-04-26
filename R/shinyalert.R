#' Display a popup message (modal) in Shiny
#'
#' Modals can contain text, images, OK/Cancel buttons, Shiny inputs, and Shiny outputs
#' (such as plots and tables). A modal can also have a timer to close automatically,
#' and you can specify custom code to run when a modal closes. See the
#' \href{https://daattali.com/shiny/shinyalert-demo/}{demo Shiny app}
#' online for examples or read the
#' \href{https://github.com/daattali/shinyalert#readme}{full README}.
#'
#' @param title The title of the modal.
#' @param text The modal's text. Can either be simple text, or Shiny tags (including
#' Shiny inputs and outputs). If using Shiny tags, then you must also set `html=TRUE`.
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
#' close automatically. Use \code{0} to not close the modal automatically (default).
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
#' @param size The size (width) of the modal. One of `"xs"` for extra small, `"s"`
#' for small (default), `"m"` for medium, or `"l"` for large.
#' @param immediate If `TRUE`, close any previously opened alerts and display
#' the current one immediately.
#' @param session Shiny session object (only for advanced users).
#'
#' @return An ID that can be used by \code{\link{closeAlert}} to close this
#' specific alert.
#'
#' @section Simple input modals:
#' Usually the purpose of a modal is simply informative, to show some information
#' to the user. However, the modal can also be used to retrieve an input from the
#' user by setting the `type = "input"` parameter.
#'
#' When using a `type="input"` modal, only a single input can be used. By default,
#' the input will be a text input, but you can use other input types by specifying
#' the `inputType` parameter (for example `inputType = "number"` will expose a
#' numeric input).
#'
#' @section Shiny inputs/outputs in modals:
#' While simple input modals are useful for retrieving input from the user, they
#' aren't very flexible - they only allow one input. You can include any Shiny UI
#' code in a modal, including Shiny inputs and outputs (such as plots), by
#' providing Shiny tags in the `text` parameter and setting `html=TRUE`. For
#' example, the following code would produce a modal with two inputs:
#'
#' \preformatted{
#'   shinyalert(html = TRUE, text = tagList(
#'     textInput("name", "What's your name?", "Dean"),
#'     numericInput("age", "How old are you?", 30),
#'   ))
#' }
#'
#' @section Modal return value:
#' Modals created with \{shinyalert\} have a return value when they exit.
#'
#' When using a simple input modal (`type="input"`), the value of the modal is
#' the value the user entered. Otherwise, the value of the modal is `TRUE` if
#' the user clicked the "OK" button, and `FALSE` if the user dismissed the modal
#' (either by clicking the "Cancel" button, using the Escape key, clicking outside
#' the modal, or letting the `timer` run out).
#'
#' The return value of the modal can be accessed via `input$shinyalert` (or using
#' a different input ID if you specify the `inputId` parameter), as if it were a
#' regular Shiny input. The return value can also be accessed using the
#' *modal callbacks* (see below).
#'
#' @section Callbacks:
#' The return value of the modal is passed as an argument to the `callbackR`
#' and `callbackJS` functions (if a `callbackR` or `callbackJS` arguments
#' are provided). These functions get called (in R and in JavaScript, respectively)
#' when the modal exits.
#'
#' For example, using the following \{shinyalert\} code will result in a modal with
#' an input field. After the user clicks "OK", a hello message will be printed
#' to both the R console and in a native JavaScript alert box. You don't need to
#' provide both callback functions, but in this example both are used for
#' demonstration.
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
#' \code{FALSE}, the callback functions can be modified to not print anything in
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
#' # Example 2: Simple input modal calling another modal in its callback
#' if (interactive()) {
#'   library(shiny)
#'   library(shinyalert)
#'
#'   shinyApp(
#'     ui = fluidPage(
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
#'
#' # Example 3: Modal with Shiny tags (input and output)
#' if (interactive()) {
#'   library(shiny)
#'   library(shinyalert)
#'
#'   shinyApp(
#'     ui = fluidPage(
#'       actionButton("btn", "Go")
#'     ),
#'     server = function(input, output) {
#'       observeEvent(input$btn, {
#'         shinyalert(
#'           html = TRUE,
#'           text = tagList(
#'             numericInput("num", "Number", 10),
#'             "The square of the number is",
#'             textOutput("square", inline = TRUE)
#'           )
#'         )
#'       })
#'
#'       output$square <- renderText({ input$num*input$num })
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
  inputId = "shinyalert",
  size = "s",
  immediate = FALSE,
  session = getSession()
) {

  params <- as.list(environment())

  if (timer < 0) {
    stop("timer cannot be negative.", call. = FALSE)
  }
  if (!type %in% c("", "warning", "error", "success", "info", "input")) {
    stop("type=", type, " is not supported.", call. = FALSE)
  }
  if (!size %in% c("xs", "s", "m", "l")) {
    stop("size=", size, " is not supported.", call. = FALSE)
  }
  if (!is.null(imageUrl) && imageUrl == "") {
    imageUrl <- NULL
  }

  # Rename some parameters that shinyalert tries to use more sensible names for
  params[['customClass']] <- paste0(params[['className']], " alert-size-", size)
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

  # Remove parameters that shouldn't be passed to JavaScript
  params[['session']] <- NULL

  if (is.null(session$userData$.shinyalert_added) || !session$userData$.shinyalert_added) {
    shiny::insertUI("head", "beforeEnd", immediate = TRUE, ui = getDependencies())
    session$userData$.shinyalert_added <- TRUE
  }

  if (immediate) {
    closeAlert()
  }

  # If an R callback function is provided, create an observer for it
  cbid <- paste0("__shinyalert-", gsub("-", "", uuid::UUIDgenerate()))
  params[['cbid']] <- session$ns(cbid)
  if (is.null(callbackR)) {
    params[['callbackR']] <- FALSE
  } else {
    shiny::observeEvent(session$input[[cbid]], {
      if (length(formals(callbackR)) == 0) {
        callbackR()
      } else {
        callbackR(session$input[[cbid]])
      }
    }, once = TRUE)
    params[['callbackR']] <- TRUE
  }

  if (html && !is.null(params[["text"]]) && (length(params[["text"]]) > 1 || nzchar(as.character(params[["text"]])))) {
    if (type == "input") {
      stop("Cannot use 'input' type and HTML together. You must supply your own Shiny inputs when using HTML.", call. = FALSE)
    }

    shiny::insertUI("head", "beforeEnd", immediate = FALSE, ui = htmltools::findDependencies(params[["text"]]))
    params[["text"]] <- as.character(params[["text"]])
  }

  params[["inputId"]] <- session$ns(params[["inputId"]])
  session$sendCustomMessage(type = "shinyalert.show", message = params)

  invisible(params[["cbid"]])
}

#' Close a shinyalert popup message
#' @param num Number of popup messages to close. If set to 0 (default) then all
#' messages are closed. This is only useful if you have multiple popups queued up.
#' @param id To close a specific popup, use the ID returned by \code{\link{shinyalert}}.
#' Note that if `id` is specified, then `num` is ignored.
#' @export
closeAlert <- function(num = 0, id = NULL) {
  session <- getSession()
  session$sendCustomMessage(type = "shinyalert.closeAlert",
                            message = list(count = num, cbid = id))
}
