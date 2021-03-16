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

nflsuspensions1 <- fivethirtyeight::nfl_suspensions %>%
  group_by(year) %>%
  count(year)

#############################################################
# define choice values and labels for widgets (user inputs) #
#############################################################
# define vectors for choice values and labels 
# can then refer to them in server as well (not just in defining widgets)

# for TAB 1 (HISTOGRAM) widgets: 
hist_choice_values <- c("category", "year", "team", "description")
hist_choice_names <- c("Category", "Year", "Team", "Description")
names(hist_choice_values) <- hist_choice_names

# for TAB 2 (SCATTERPLOT) widgets: 
size_choice_values <- c("year")
size_choice_names <- c("Year")
names(size_choice_values) <- size_choice_names

# for TAB 3 (TABLE) widgets: 
team_choices <- unique(nflsuspensions$team)

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
  ),
  
  tabPanel(
    title = "Scatterplot",
    
    sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "id_name"
                    , label = "Choose variable of interest:"
                    , choices = size_choice_values
                    , selected = "year")
      ),
      mainPanel(
        plotOutput(outputId = "scatter")
      )
    )
  ),
  
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
  
# TAB 2: INTERACTIVE SCATTERPLOT 
output$scatter <- renderPlot({
  nflsuspensions1 %>%
    ggplot(aes_string(x="year",  y= "n")) +
    geom_point(color = "#2c7fb8") +
    labs(x = "Year", y = "Number of NFL Players Suspended"
         , title = "NFL Players' Suspensions by Year")
})
  
  # TAB 3: TABLE
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

# Your turn.  Copy this code as a template into a new app.R file (WITHIN A FOLDER
# named something different than your other Shiny app folders).  Then, either 
# (1) update this template to still explore the skateboards dataset, but with
#     different app functionality (e.g. different widgets, variables, layout, theme...); 
#   OR
# (2) use this as a template to create a Shiny app for a different dataset 
#     from the fivethirtyeight package:
#     either candy_rankings (candy characteristics and popularity)
#            hate_crimes (hate crimes in US states, 2010-2015)
#            mad_men (tv performers and their post-show career), 
#            ncaa_w_bball_tourney (women's NCAA div 1 basketball tournament, 1982-2018), 
#         or nfl_suspensions (NFL suspensions, 1946-2014)
#      these five datasets are part of the fivethirtyeight package
#      and their variable definitions are included in pdfs posted to the Moodle course page
