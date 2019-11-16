# This is the Shiny app for STAT 628, Module 3, Group 9
rm(list = ls())

library(shiny)
library(leaflet)

source("global.R")

ui <- navbarPage(
    "Yelp Business Analysis", id = "nav",
    # theme = "superZip.css",
    
    tabPanel("Interactive map",
             div(class="outer",
                 tags$head(
                     includeCSS("www/superZip.css"),
                 ),
                 
                 # If not using custom CSS, set height of leafletOutput to a number instead of percent
                 leafletOutput("map", width="100%", height="100%"),
                 
                 absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                               draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                               width = 330, height = "auto",
                               
                               h2("Restaurant explorer"),
                               
                               textInput(inputId = "search", placeholder = "Search for something",
                                         label = "Search"),
                               
                               checkboxGroupInput(inputId = "cuisine", label = "Cuisine",
                                                  choices = cuisineSet, selected = cuisineSet ),
                               
                               sliderInput(inputId = "starRange", label = "Star", round = starPrecision,
                                           min = 0., max = 5., value = c(0, 5), step = 0.1**starPrecision)
                 ),
             ),
    )
)


# Define server logic required to draw a histogram
server <- function(input, output, session){
    locFiltered = reactive(filterLocation( input$cuisine, input$starRange))
    
    output$map = renderLeaflet({
        leaflet() %>% 
            addTiles() %>% 
            setView(-79.40229, 43.73350, 14) %>% 
            addCircles(locFiltered()$longitude, locFiltered()$latitude, weight = 3, radius=20, 
                       color=locFiltered()$color, stroke = TRUE, fillOpacity = 0.8) %>% 
            addMarkers(locFiltered()$longitude, locFiltered()$latitude, clusterOptions = markerClusterOptions(),
                       clusterId = "cluster1")
    })
    
    output$slider = renderText(str(input$starRange))
    output$cuisine = renderText(str(input$cuisine))
    
}

# Run the application 
shinyApp(ui = ui, server = server)
