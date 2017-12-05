# Import essential libraries
library(httr)
library(jsonlite)
library(dplyr)
library(plotly)
library(shiny)

shinyUI(navbarPage('Dota 2 Data Visualization',
    tabPanel("Hero Win Rates", 
             sidebarLayout(
               sidebarPanel(
                 radioButtons("view.change", label = h3("2-D & 3-D View Changer"),
                                              choices = list("2D" = "2D", "3D" = "3D")) 
               ),
               mainPanel(plotlyOutput('heroStats'))
               )),
    tabPanel("Pro vs. All Win Rates", plotlyOutput('proStats')),
    tabPanel("Top 10 Teams", plotlyOutput('topTeams'))
))
