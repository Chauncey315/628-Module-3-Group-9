# This is the Shiny app for STAT 628, Module 3, Group 9
rm(list = ls())

library(shiny)
library(leaflet)

source("dataCleaning.R")

ui <- fluidPage(
    theme = "flatly.css",
    titlePanel("Yelp Business Analysis"),
    
    tags$hr(),
    
    inputPanel(textInput(inputId = "search", placeholder = "Search for something",
                         label = "Search"),
               # selectInput(inputId = "city", label = "City", choices = c("Toronto")),
               checkboxGroupInput(inputId = "cuisine", label = "Cuisine",
                                  choices = cuisineSet, selected = cuisineSet ),
               sliderInput(inputId = "starRange", label = "Star", round = starPrecision,
                           min = 0., max = 5., value = c(0, 5), step = 0.1**starPrecision)
               ),
    
    tags$hr(),
    
    verbatimTextOutput("slider"),
    verbatimTextOutput("cuisine"),
    leafletOutput("map", height = 800, width = 1200),
)

# Define server logic required to draw a histogram
server <- function(input, output, session){
    # locFiltered = reactive(filterLocation(cuisine, star))
    
    output$map = renderLeaflet({
        leaflet() %>% 
        addTiles() %>% 
        setView(-79.40229, 43.73350, 14) %>% 
        addCircles(location$longitude, location$latitude, weight = 3, radius=20, 
                 color=location$color, stroke = TRUE, fillOpacity = 0.8) %>% 
        addMarkers(location$longitude, location$latitude, clusterOptions = markerClusterOptions(),
                   clusterId = "cluster1")
    })
    
    output$slider = renderText(str(input$starRange))
    output$cuisine = renderText(str(input$cuisine))
    
}

# Run the application 
shinyApp(ui = ui, server = server)
