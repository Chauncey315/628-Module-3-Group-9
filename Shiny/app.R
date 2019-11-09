# This is the Shiny app for STAT 628, Module 3, Group 9
rm(list = ls())

library(shiny)
library(leaflet)

source("dataCleaning.R")

ui <- fluidPage(
    theme = "darkly",
    fluidRow(
        column(3, "Project Name"),
        column(2,
               selectInput(inputId = "city", label = "City", 
                           choices = c("Toronto"))),
    ),
    
    tags$hr(),
    
    fluidRow(
        column(7, 
               textInput(inputId = "search", value = "Enter Text ...",
                         label = "Search")),
        column(1,
               selectInput(inputId = "slt1", label = "Input1", 
                           choices = c(1,2,3))),
        column(1,
               selectInput(inputId = "slt2", label = "Input2", 
                           choices = c(1,2,3))),
        column(1,
               selectInput(inputId = "slt3", label = "Input3", 
                           choices = c(1,2,3))),
        column(1,
               selectInput(inputId = "slt4", label = "Input4", 
                           choices = c(1,2,3))),
        column(1,
               actionButton(inputId = "mrFlt", label = "More Filters"))
    ),
    verbatimTextOutput("zoom"),
    leafletOutput("map", height = 800, width = 1200),
)

# Define server logic required to draw a histogram
server <- function(input, output, session){
    
    output$map = renderLeaflet({
        leaflet() %>% 
        addTiles() %>% 
        setView(-79.40229, 43.73350, 14) %>% 
        addCircles(data = location, weight = 3, radius=20, 
                 color=location$color, stroke = TRUE, fillOpacity = 0.8) %>% 
        addMarkers(data = location, clusterOptions = markerClusterOptions(),
                   clusterId = "cluster1")
    })
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
