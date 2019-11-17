# This is the Shiny app for STAT 628, Module 3, Group 9
rm(list = ls())

library(shiny)
library(leaflet)

source("global.R")

ui <- navbarPage(
    "Yelp Business Analysis", id = "nav",
    # theme = "superZip.css",
    # tags$style("#text1{font-family: Arial, Helvetica, sans-serif;}")
    
    
    tabPanel("Interactive Map",
             div(class="outer",
                 tags$head(
                     includeCSS("www/superZip.css"),
                 ),
                 
                 # If not using custom CSS, set height of leafletOutput to a number instead of percent
                 leafletOutput("map", width="100%", height="100%"),
                 
                 absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                               draggable = TRUE, top = 130, left = 10, bottom = "auto",
                               width = 330, height = "auto",
                               # right = 20,
                               
                               h2("Restaurant Explorer"),
                               
                               textInput(inputId = "search", placeholder = "Search Restaurant by Name",
                                         label = "Search"),
                               
                               sliderInput(inputId = "starRange", label = "Star", round = starPrecision,
                                           min = 0., max = 5., value = c(0., 5.), step = 0.1**starPrecision),
                               
                               checkboxGroupInput(inputId = "cuisineSet", label = "Cuisine",
                                                  choices = cuisineSet, selected = cuisineSet),
                               
                               checkboxGroupInput(inputId = "districtSet", label = "District",
                                                  choices = districtSet, selected = districtSet)
                 ),
             ),
    ),
    
    tabPanel("Network Analysis")
)


# Define server logic required to draw a histogram
server <- function(input, output, session){
    locFiltered = reactive(filterLocation( input$cuisineSet, input$starRange, input$districtSet,
                                           input$search))
    
    
    
    output$map = renderLeaflet({
        leaflet() %>% 
            addTiles() %>% 
            setView(-79.40229, 43.73350, 10) %>% 
            addCircles(locFiltered()$longitude, locFiltered()$latitude, weight = 3, radius=20, 
                       color=pal(locFiltered()$stars), stroke = TRUE, fillOpacity = 0.8) %>% 
            addMarkers(locFiltered()$longitude, locFiltered()$latitude, clusterOptions = markerClusterOptions(),
                       clusterId = "cluster1") %>%
            addLegend("topright", pal = pal, values = location$stars, bins = 7,
                      title = "Star")
    })
    
    output$starRangeslider = renderText(str(input$starRange))
    output$cuisineSetCheckbox = renderText(str(input$cuisineSet))
    
}

# Run the application 
shinyApp(ui = ui, server = server)
