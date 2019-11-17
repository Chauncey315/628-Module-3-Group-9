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
                               width = 330, height = "auto",style = "overflow-y:scroll; max-height: 600px",
                               # right = 20,
                               
                               h2("Restaurant Explorer"),
                               
                               textInput(inputId = "search", placeholder = "Search Restaurants by Name or Business ID",
                                         label = "Search"),
                               
                               sliderInput(inputId = "starRange", label = "Star", round = starPrecision,
                                           min = 0., max = 5., value = c(0., 5.), step = 0.1**starPrecision),
                               
                               
                               # dropdownButton(label = "Select Cuisine", status = "default", width = 80,
                               #                checkboxGroupInput(inputId = "cuisineSet", label = "Cuisine",
                               #                                   choices = cuisineSet, selected = cuisineSet)),
                               # dropdownButton(label = "Select District", status = "default", width = 80,
                               #                checkboxGroupInput(inputId = "districtSet", label = "District",
                               #                                   choices = districtSet, selected = districtSet)),

                               checkboxGroupInput(inputId = "cuisineSet", label = "Cuisine",
                                                  choices = cuisineSet, selected = cuisineSet),
                               checkboxGroupInput(inputId = "districtSet", label = "District",
                                                  choices = districtSet, selected = districtSet),
                               
                               
                               
                               h2("UDar"),
                               p("Search Influential Users & Their Favorite Restaurants"),
                               
                               checkboxGroupInput(inputId = "attributeSet", label = "Attribute",
                                                  choices = attributeSet, selected = attributeSet),
                               
                               textOutput(outputId = "debug")
                               
                 ),
             ),
    ),

    tabPanel("Network Analysis"),
    tabPanel("Resaurant Suggestion")
)


# Define server logic required to draw a histogram
server <- function(input, output, session){
    locFiltered = reactive(filterLocation( input$cuisineSet, input$starRange, input$districtSet,
                                           input$search))
    
    circleLabel = reactive({
        if(length(locFiltered()$mapLabel) == 0){
            return(location$mapLabel)
        }else{
            return(locFiltered()$mapLabel)
        }
    })
    
    
    
    output$map = renderLeaflet({
        leaflet() %>% 
            addTiles() %>% 
            setView(centerTorAsian[1], centerTorAsian[2],  zoom = 10) %>% 
            addCircles(locFiltered()$longitude, locFiltered()$latitude, weight = 3, radius=20, 
                       color=pal(locFiltered()$stars), stroke = TRUE, fillOpacity = 0.8
                       ,label = circleLabel()
                       ) %>% 
            addMarkers(locFiltered()$longitude, locFiltered()$latitude, clusterOptions = markerClusterOptions(),
                       clusterId = "cluster1") %>%
            addLegend("topright", pal = pal, values = location$stars, bins = 7,
                      title = "Star")
    })
    
    # output$starRangeslider = renderText(str(input$starRange))
    # output$cuisineSetCheckbox = renderText(str(input$cuisineSet))
    
    output$debug = renderText(length(locFiltered()$mapLabel))
    
}

# Run the application 
shinyApp(ui = ui, server = server)
