# TODO: support function callbacks
#' @export
shinyalert <- function(
  title = "",
  text = "",
  type = c("", "warning", "error", "success", "info", "input"),
  allowEscapeKey = TRUE,
  customClass = "",
  allowOutsideClick = FALSE,
  showCancelButton = FALSE,
  showConfirmButton = TRUE,
  confirmButtonText = "OK",
  confirmButtonColor = "#AEDEF4",
  cancelButtonText = "Cancel",
  closeOnConfirm = TRUE,
  closeOnCancel = TRUE,
  imageUrl = NULL,
  imageSize = "80x80",
  timer = NULL,
  html = FALSE,
  animation = TRUE,
  inputType = "text",
  inputPlaceholder = "",
  inputValue = "",
  showLoaderOnConfirm = FALSE,
  callback = NULL,
  callbackR = NULL
) {

  type <- match.arg(type)
  params <- as.list(environment())

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
    })
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
