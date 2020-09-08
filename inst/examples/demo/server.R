library(shiny)
library(shinyalert)

function(input, output, session) {
  output$return <- renderText({
    input$shinyalert
  })

  code <- reactive({
    type <- input$type
    if (type == "<none>") type <- ""

    code <- paste0(
      'shinyalert(\n',
      '  title = "', input$title, '",\n',
      '  text = "', input$text, '",\n',
      '  size = "', input$size, '", \n',
      '  closeOnEsc = ', input$closeOnEsc, ',\n',
      '  closeOnClickOutside = ', input$closeOnClickOutside, ',\n',
      '  html = ', input$html, ',\n',
      '  type = "', type, '",\n'
    )

    if (type == "input") {
      code <- paste0(
        code,
        '  inputType = "', input$inputType, '",\n',
        '  inputValue = "', input$inputValue, '",\n',
        '  inputPlaceholder = "', input$inputPlaceholder, '",\n'
      )
    }

    code <- paste0(
      code,
      '  showConfirmButton = ', input$showConfirmButton, ',\n',
      '  showCancelButton = ', input$showCancelButton, ',\n'
    )

    if (input$showConfirmButton) {
      code <- paste0(
        code,
        '  confirmButtonText = "', input$confirmButtonText, '",\n',
        '  confirmButtonCol = "', input$confirmButtonCol, '",\n'
      )
    }
    if (input$showCancelButton) {
      code <- paste0(
        code,
        '  cancelButtonText = "', input$cancelButtonText, '",\n'
      )
    }

    code <- paste0(
      code,
      '  timer = ', input$timer, ',\n',
      '  imageUrl = "', input$imageUrl, '",\n'
    )
    if (input$imageUrl != "") {
      code <- paste0(
        code,
        '  imageWidth = ', input$imageWidth, ',\n',
        '  imageHeight = ', input$imageHeight, ',\n'
      )
    }

    code <- paste0(
      code,
      '  animation = ', input$animation, '\n'
    )

    code <- paste0(code, ")")
    code
  })

  observeEvent(input$show, {
    if (input$html && input$type == "input") {
      shinyalert::shinyalert(text = "Cannot use 'input' type and HTML together (because when using HTML, you're able to provide custom shiny inputs/outputs).", type = "error")
      return()
    }

    eval(parse(text = code()))
  })

  output$code <- renderText({
    paste0(
      "library(shiny)\nlibrary(shinyalert)\n\n",
      "ui <- fluidPage(\n  useShinyalert()\n)\n\n",
      "server <- function(input, output) {\n  ",
      gsub("\n", "\n  ", code()),
      "\n}\n\nshinyApp(ui, server)"
    )
  })
}
