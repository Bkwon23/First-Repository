library(shiny)
library(shinythemes)
library(tidyverse)
library(DT)
library(ggrepel)
library(fivethirtyeight)

###############
# import data #
###############
nflsuspensions1 <- fivethirtyeight::nfl_suspensions %>%
  group_by(year) %>%
  count(year)
###################################################
# define choice values and labels for user inputs #
###################################################
# define vectors for choice values and labels 
# can then refer to them in server as well (not just in defining widgets)

# for radio button, can be separate 
# (have choiceValues and choiceNames options, rather than just choices)
size_choice_values <- c("year")
size_choice_names <- c("Year")
names(size_choice_values) <- size_choice_names


############
#    ui    #
############
ui <- navbarPage(
  
  title="NFL Suspensions",
  
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
  )
)

############
# server   #
############
server <- function(input,output){
  
  # TAB 2: INTERACTIVE SCATTERPLOT 
  output$scatter <- renderPlot({
    nflsuspensions1 %>%
      ggplot(aes_string(x="year",  y= "n")) +
      geom_point(color = "#2c7fb8") +
      labs(x = "Year", y = "Number of NFL Players Suspended"
           , title = "NFL Players' Suspensions by Year")
  })
}

####################
# call to shinyApp #
####################
shinyApp(ui = ui, server = server)