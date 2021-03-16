library(shiny)
library(shinythemes)
library(tidyverse)
library(dplyr)
library(DT)
library(ggrepel)
library(fivethirtyeight)

###############
# import data #
###############
nflsuspensions <- fivethirtyeight::nfl_suspensions

###################################################
# define choice values and labels for user inputs #
###################################################
# define vectors for choice values and labels 
# can then refer to them in server as well (not just in defining widgets)
# for selectInput, 'choices' object should be a NAMED LIST
hist_choice_values <- c("category", "year", "team")
hist_choice_names <- c("Category", "Year", "Team")
names(hist_choice_values) <- hist_choice_names


############
#    ui    #
############
ui <- navbarPage(
  
  title="NFL Suspensions",
  
  tabPanel(
    title = "Bar Chart",
    sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "histvar"
                    , label = "Choose a variable of interest to plot:"
                    , choices = hist_choice_values
                    , selected = "category")
      ),
      mainPanel(
        plotOutput(outputId = "hist")
      )
    )
  )
)

############
# server   #
############
server <- function(input,output){
  
  # TAB 1: HISTOGRAM
  data_for_hist <- reactive({
    data <- filter(nflsuspensions)
  })
  
  output$hist <- renderPlot({
    ggplot(data = data_for_hist(), aes_string(x = input$histvar)) +
      geom_histogram(color = "#2c7fb8", fill = "#7fcdbb", alpha = 0.7, breaks = 5,
                     stat = "count") +
      labs(x = hist_choice_names[hist_choice_values == input$histvar]
           , y = "Total Number of NFL Suspensions") + 
    theme(axis.text.x = element_text(angle = 90))
  })
}

####################
# call to shinyApp #
####################
shinyApp(ui = ui, server = server)