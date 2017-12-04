# Import essential libraries
library(httr)
library(jsonlite)
library(dplyr)
library(plotly)
library(shiny)

shinyUI(fluidPage(
  mainPanel(
    plotlyOutput('heroStats')
  )
))
