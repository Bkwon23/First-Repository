library(shiny)

ui <- fluidPage(
  sliderInput(inputId = "num", 
              label = "Choose a number", 
              value = 25, min = 1, max = 100),
  textInput(inputId = "title", 
            label = "Write a title",
            value = "Histogram of Random Normal Values"),
 ## plotOutput("hist"),
 ## verbatimTextOutput("stats"),
  
  navlistPanel(              
    tabPanel(title = "Normal data",
             plotOutput("norm"),
             actionButton("renorm", "Resample")
    ),
    tabPanel(title = "Uniform data",
             plotOutput("unif"),
             actionButton("reunif", "Resample")
    ),
    tabPanel(title = "Chi Squared data",
             plotOutput("chisq"),
             actionButton("rechisq", "Resample")
    )
  )
)

server <- function(input, output) {
  rv <- reactiveValues(
    norm = rnorm(25), 
    unif = runif(25),
    chisq = rchisq(25, 2))
  
  observeEvent(input$renorm, { rv$norm <- rnorm(input$num) })
  observeEvent(input$reunif, { rv$unif <- runif(input$num) })
  observeEvent(input$rechisq, { rv$chisq <- rchisq(input$num, 2) })
  
  output$norm <- renderPlot({
    hist(rv$norm, breaks = 30, col = "grey", border = "white",
         main = input$title)
  })
  output$unif <- renderPlot({
    hist(rv$unif, breaks = 30, col = "grey", border = "white",
         main = input$title)
  })
  output$chisq <- renderPlot({
    hist(rv$chisq, breaks = 30, col = "grey", border = "white",
         main = input$title)
  })

}

shinyApp(ui = ui, server = server)
