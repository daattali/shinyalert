library(shiny)

share <- list(
  title = "shinyalert package",
  url = "https://daattali.com/shiny/shinyalert-demo/",
  image = "https://daattali.com/shiny/img/shinyalert.png",
  description = "Easily create pretty popup messages (modals) in Shiny",
  twitter_user = "daattali"
)

fluidPage(
  shinydisconnect::disconnectMessage2(),
  title = paste0("shinyalert package ", as.character(packageVersion("shinyalert"))),
  tags$head(
    includeCSS(file.path('www', 'style.css')),
    # Favicon
    tags$link(rel = "shortcut icon", type="image/x-icon", href="https://daattali.com/shiny/img/favicon.ico"),
    # Facebook OpenGraph tags
    tags$meta(property = "og:title", content = share$title),
    tags$meta(property = "og:type", content = "website"),
    tags$meta(property = "og:url", content = share$url),
    tags$meta(property = "og:image", content = share$image),
    tags$meta(property = "og:description", content = share$description),

    # Twitter summary cards
    tags$meta(name = "twitter:card", content = "summary"),
    tags$meta(name = "twitter:site", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:creator", content = paste0("@", share$twitter_user)),
    tags$meta(name = "twitter:title", content = share$title),
    tags$meta(name = "twitter:description", content = share$description),
    tags$meta(name = "twitter:image", content = share$image)
  ),
  tags$a(
    href="https://github.com/daattali/shinyalert",
    tags$img(style="position: absolute; top: 0; right: 0; border: 0;",
             src="github-green-right.png",
             alt="Fork me on GitHub")
  ),
  shinyalert::useShinyalert(),

  div(id = "header",
      div(id = "pagetitle",
          "shinyalert package"
      ),
      div(id = "subtitle",
          "Easily create pretty popup messages (modals) in Shiny"),
      div(id = "subsubtitle",
          "Created by",
          tags$a(href = "https://deanattali.com/", "Dean Attali"),
          HTML("&bull;"),
          "Available",
          tags$a(href = "https://github.com/daattali/shinyalert", "on GitHub"),
          HTML("&bull;"),
          tags$a(href = "https://daattali.com/shiny/", "More apps"), "by Dean"
      )
  ),

  fluidRow(column(
    width = 6, offset = 3,
    div(
      id = "main-row",
      actionButton("show", "Preview", icon("play"), class = "btn-success"),
      br(), br()
    )
  )),
  fluidRow(
    column(
      3,
      textInput("title", "Title", "Hello"),
      textInput("text", "Text", "This is a modal"),
      checkboxInput("closeOnEsc", "Close on Escape", TRUE),
      checkboxInput("closeOnClickOutside", "Close on click outside", FALSE),
      checkboxInput("html", "Allow HTML", FALSE)
    ),
    column(
      3,
      selectInput("size", "Size", c("xs", "s", "m", "l"), "s"),
      selectInput("type", "Type",
                  choices = c("<none>", "input", "warning", "error", "success", "info"),
                  selected = "success"),
      conditionalPanel(
        "input.type == 'input'",
        selectInput("inputType", "Input type",
                    choices = c("text", "number", "password", "color", "date")),
        textInput("inputValue", "Input value", ""),
        textInput("inputPlaceholder", "Input placeholder", "")
      )
    ),
    column(
      3,
      checkboxInput("showConfirmButton", "Show confirm button", TRUE),
      checkboxInput("showCancelButton", "Show cancel button", FALSE),
      conditionalPanel(
        "input.showConfirmButton",
        textInput("confirmButtonText", "Confirm button text", "OK"),
        colourpicker::colourInput("confirmButtonCol", "Confirm button colour", "#AEDEF4")
      ),
      conditionalPanel(
        "input.showCancelButton",
        textInput("cancelButtonText", "Cancel button text", "Cancel")
      )
    ),
    column(
      3,
      numericInput("timer", HTML("Timer (milliseconds; 0&nbsp;=&nbsp;no&nbsp;timer)"), 0),
      textInput("imageUrl", "Image URL", ""),
      conditionalPanel(
        "input.imageUrl != ''",
        numericInput("imageWidth", "Image width (pixels)", 100),
        numericInput("imageHeight", "Image height (pixels)", 100)
      ),
      checkboxInput("animation", "Animation", TRUE)
    )
  ),
  fluidRow(
    column(
      12,
      strong("Modal return value (useful when Type is \"input\"):"),
      textOutput("return", inline = TRUE)
    )
  ),
  fluidRow(
    column(
      12, h3("Generated code"), verbatimTextOutput("code")
    )
  )
)
