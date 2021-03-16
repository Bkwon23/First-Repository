library(shiny)
library(shinythemes)
library(tidyverse)
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

# for selectizeInput choices for company name, pull directly from data
team_choices <- unique(nflsuspensions$team)

############
#    ui    #
############
ui <- navbarPage(
  
  title="NFL Suspensions",
  
  tabPanel(
    title = "Table",
    
    sidebarLayout(
      sidebarPanel(
        selectizeInput(inputId = "team"
                       , label = "Choose one or more teams:"
                       , choices = team_choices
                       , selected = "CIN"
                       , multiple = TRUE)
      ),
      mainPanel(
        DT::dataTableOutput(outputId = "table")
      )
    )
  )
)

############
# server   #
############
server <- function(input,output){
  
  # TAB 3: TABLE
  data_for_table <- reactive({
    data <- filter(nflsuspensions, team %in% input$team)
  })
  
  output$table <- DT::renderDataTable({ 
    data_for_table()
  })
  
}

####################
# call to shinyApp #
####################
shinyApp(ui = ui, server = server)