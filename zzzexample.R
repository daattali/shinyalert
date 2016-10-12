library(shiny)
library(shinyjs)
library(shinyalert)

ui <- fluidPage(
  shinyjs::useShinyjs(),
  useShinyalert(),
  textInput("expr", label = "Enter an R expression",
            value = "shinyalert('hello',callbackJS='alert', callbackR=message, type='input')",width="600px"),
  actionButton("run", "Run", class = "btn-success"),
  shinyjs::hidden(
    div(
      id = "error",
      style = "color: red; font-weight: bold;",
      div("Oops, that resulted in an error! Try again."),
      div("Error: ", br(),
          span(id = "errorMsg", style = "margin-left: 10px;"))
    )
  )
)

server <- function(input, output, session) {
  shinyEnv <- environment()
  ggg<-5

  observeEvent(input$run, {
    shinyjs::hide("error")

    tryCatch(
      isolate(
        eval(parse(text = input$expr), envir = shinyEnv)
      ),
      error = function(err) {
        shinyjs::html("errorMsg", as.character(shiny::tags$i(err$message)))
        shinyjs::show(id = "error", anim = TRUE, animType = "fade")
      }
    )
  })

  ccc <- function(aa) {
    cat("IM HERE")
    cat(aa)
    cat('a')
  }

}

shinyApp(ui = ui, server = server)
