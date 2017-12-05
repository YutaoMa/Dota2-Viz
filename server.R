# Import essential libraries
library(httr)
library(jsonlite)
library(dplyr)
library(plotly)
library(shiny)

# Get request: heroStats
heroStats.url <- 'https://api.opendota.com/api/heroStats'
heroStats.response <- GET(heroStats.url)
heroStats.body <- content(heroStats.response, "text")
heroStats.results <- fromJSON(heroStats.body)
heroStats.results$NaN_win_rate <- heroStats.results$NaN_win / heroStats.results$NaN_pick

attr.colors <- c("green", "blue", "red")

heroStats.results$pro_win_rate <- heroStats.results$pro_win / heroStats.results$pro_pick

shinyServer(function(input, output) {
  output$heroStats <- renderPlotly({
    p <- plot_ly(data = heroStats.results, x = ~NaN_pick, y = ~NaN_win_rate,
                 color = ~primary_attr, colors = attr.colors,
                 text = ~localized_name) %>% 
         layout(title = 'Dota 2 Heroes Win Rates vs. Picks', yaxis = list(title = "Win Rate"), xaxis = list(title = "Pick"))
    return(p)
  })
  
  output$proStats <- renderPlotly({
    p <- plot_ly(data = heroStats.results,
                 x = ~localized_name, y = ~pro_win_rate,
                 name = "Pro Win Rates",
                 type = "bar") %>% 
          add_trace(y = ~NaN_win_rate, name = "All Win Rates") %>% 
          layout(yaxis = list(title = "Win Rate"), barmode = "group")
    return(p)
  })
})
  
  
