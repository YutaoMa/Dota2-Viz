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

teams.url <- 'https://api.opendota.com/api/teams'
teams.response <- GET(teams.url)
teams.body <- content(teams.response, "text")
teams.results <- fromJSON(teams.body)
teams.tops.results <- teams.results[1:10,]

shinyServer(function(input, output) {
  output$heroStats <- renderPlotly({
    if(input$view.change == "2D") {
    p <- plot_ly(data = heroStats.results, x = ~NaN_pick, y = ~NaN_win_rate,
                 color = ~primary_attr, colors = attr.colors,
                 text = ~localized_name) %>% 
         layout(title = 'Dota 2 Heroes Win Rates vs. Picks', yaxis = list(title = "Win Rate"), xaxis = list(title = "Pick"))
    } else {
      p <- plot_ly(data = heroStats.results, x = ~NaN_pick, z = ~NaN_win_rate, y = ~primary_attr,
                   color = ~primary_attr, colors = attr.colors,
                   text = ~localized_name) %>% 
        add_markers() %>%
        layout(scene = list(xaxis = list(title = 'Picks'),
                            zaxis = list(title = 'Wins'),
                            yaxis = list(title = "Attribute")))
    }
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
  
  output$topTeams <- renderPlotly({
    p <- plot_ly(data = teams.tops.results,
                 name = "Tops 10 Teams",
                 type = "bar") %>% 
                add_trace(x = ~tag, y = ~rating, name = "Team Rating") %>% 
                layout(yaxis = list(title = "Rating"))
    return(p)
  })
})
  
  
