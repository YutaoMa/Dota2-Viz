# Import essential libraries
library(httr)
library(jsonlite)
library(dplyr)
library(plotly)
library(shiny)

shinyUI(navbarPage('Dota 2 Data Visualization',
    tabPanel("Hero Win Rates", plotlyOutput('heroStats')),
    tabPanel("Pro vs. All Win Rates", plotlyOutput('proStats'))
))
