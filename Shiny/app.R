# This is the Shiny app for STAT 628, Module 3, Group 9
rm(list = ls())

library(shiny)
library(leaflet)

source("global.R")

ui <- navbarPage(
    "Yelp Business Analysis", id = "nav",
    # theme = "superZip.css",
    
    
    tabPanel("Interactive Map",
             div(class="myouter",
                 theme = "superZip.css",
                 tags$head(#includeCSS("www/superZip.css")
                     tags$link(rel = "stylesheet", type = "text/css", href = "superZip.css")),
                 
                 # leaflet map ui
                 leafletOutput("map", width="100%", height="100%"),
                 
                 # floating interactive map selector panel
                 absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                               draggable = TRUE, top = 130, left = 10, bottom = "auto",
                               width = 330, height = "auto",style = "overflow-y:scroll; max-height: 600px",
                               # right = 20,
                               
                               h2("Restaurant Explorer"),
                               
                               # select restaurant by their name and id
                               textInput(inputId = "search", placeholder = "Search Restaurants by Name or Business ID",
                                         label = "Search"),
                               
                               # select restaurant by star range
                               sliderInput(inputId = "starRange", label = "Star", round = starPrecision,
                                           min = 0., max = 5., value = c(0., 5.), step = 0.1**starPrecision),
                               
                               # select restaurant by cuisine
                               checkboxGroupInput(inputId = "cuisineSet", label = "Cuisine",
                                                  choices = cuisineSet, selected = cuisineSet),
                               
                               # select restaurant by district
                               checkboxGroupInput(inputId = "districtSet", label = "District",
                                                  choices = districtSet, selected = districtSet),
                               
                               tags$hr(),
                               
                               h2("UDar"),
                               p("Search Influential Users by Cuisine & their Favorite Restaurants"),
                               
                               # select influential user by their favoraite or frequently-vist cuisine
                               checkboxGroupInput(inputId = "userCuisineSet", label = "Cuisine",
                                                  choices = cuisineSet, selected = NULL),
                               
                               # debug section
                               # tags$hr(),
                               # textOutput(outputId = "debug")
                               
                 ),
                 
                 # print out the selected influential users' name, which are uniquely assigned 
                 # by R according to their user id
                 absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                               draggable = TRUE, top = 310, left = "auto", bottom = "auto",
                               width = 220, height = "auto",style = "overflow-y:scroll; max-height: 550px",
                               right = 20,
                               
                               h3("Recommended Influencer"),
                               
                               verbatimTextOutput(outputId = "influentialUser",
                                                  placeholder = TRUE
                                                  # "Select Cuisine to Find out Corresponding Influential Users"
                                                  )
                               )
             )
    ),

    # tabPanel("Network Analysis"),
    

    
    tabPanel("Cuinalysis",
             div(class="container",
                 tags$head(
                     tags$link(rel = "stylesheet", type = "text/css", href = "grid.css")
                 ),
                 
                 # print out the analysis of a particular cuisine
                 absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                               draggable = TRUE, top = 81, left = "auto", bottom = "auto",
                               width = 600, height = "auto",style = "overflow-y:scroll; max-height: 750px",
                               right = 120,
                               uiOutput("cuisineAnalysis")
                 ),
                 
                 # display cuisine picture and their corresponding link bution
                 div(class = "gallery",
                     div(class = "thumbnail",
                         img(src='korean.jpg', class = "cards", alt=""),
                         actionLink( label = h3("Korean Restaurant"), inputId = "koreanAnalysis" )
                         ),
                     div(class = "thumbnail",
                         img(src='chinese.jpg', class = "cards", alt=""),
                         actionLink( label = h3("Chinese Restaurant"), inputId = "chineseAnalysis" )
                     )
                     
                 ),
                 
                 # display cuisine picture and their corresponding link bution
                 div(class = "gallery",
                     div(class = "thumbnail",
                         img(src='thai.jpg', class = "cards", alt=""),
                         actionLink( label = h3("Thai Restaurant"), inputId = "thaiAnalysis" )
                     ),
                     div(class = "thumbnail",
                         img(src='japanese.jpg', class = "cards", alt=""),
                         actionLink( label = h3("Japanese Restaurant"), inputId = "japaneseAnalysis" )
                     )
                 ),
                 
                 # display cuisine picture and their corresponding link bution
                 div(class = "gallery",
                     div(class = "thumbnail",
                         img(src='vietnamese.jpg', class = "cards", alt=""),
                         actionLink( label = h3("Vietnamese Restaurant"), inputId = "vietnameseAnalysis" )
                         )
                 )
             )
    )
)



# Define server logic required to draw a histogram
server <- function(input, output, session){
    # select restaurants by interactive map selector
    locFiltered = reactive(filterLocation( input$cuisineSet, input$starRange, input$districtSet,
                                           input$search))
    
    # select influential user by their favoraite cuisine
    userFiltered = reactive(filterUser(input$userCuisineSet))
    # find out selected influential user's favoraite restaurant
    locFilteredByUser = reactive(filterLocationByUser(input$userCuisineSet))
    
    # to avoid label = list(0) error
    circleLabel = reactive({
        if(length(locFiltered()$mapLabel) == 0){
            return(location$mapLabel)
        }else{
            return(locFiltered()$mapLabel)
        }
    })
    
    # to avoid label = list(0) error
    restaurantLabel = reactive({
        if(length(locFilteredByUser()$restaurantLabel) == 0){
            return(restaurantAttribute$restaurantLabel)
        }else{
            return(locFilteredByUser()$restaurantLabel)
        }
    })
    
    # plot leaflet map's initial state
    output$map = renderLeaflet({
        leaflet() %>% 
            addTiles() %>%
            setView(centerTorAsian[1], centerTorAsian[2],  zoom = 10) %>% 
            addCircles(location$longitude, location$latitude, weight = 3, radius=20, 
                       color=pal(location$stars), stroke = TRUE, fillOpacity = 0.8
                       ,label = location$mapLabel) %>% 
            addMarkers(location$longitude, location$latitude, clusterOptions = markerClusterOptions(),
                       clusterId = "cluster1") %>%
            addLegend("topright", pal = pal, values = location$stars, bins = 7,
                      title = "Star")
    })
    
    # observe leaflet map's further changes
    # hold map's current center, zoom level when the cuisine set in Udar section is changed
    observe({
        leafletProxy("map") %>%
            clearShapes() %>%
            clearMarkers() %>%
            clearMarkerClusters() %>%
            # setView(unlist(input$map_center)[1], unlist(input$map_center)[2],  zoom = input$map_zoom) %>%
            addCircles(locFilteredByUser()$longitude, locFilteredByUser()$latitude, weight = 3, radius=20,
                       color=pal(locFilteredByUser()$stars_float), stroke = TRUE, fillOpacity = 0.8
                       ,label = restaurantLabel()
            ) %>%
            
            # draw automatically generated cluster markers
            addMarkers(locFilteredByUser()$longitude, locFilteredByUser()$latitude, clusterOptions = markerClusterOptions(),
                       clusterId = "cluster1")
    })
    
    # observe leaflet map's further changes
    # hold map's current center, zoom level when the interactive map selector is updated
    observe({
        leafletProxy("map") %>%
            clearShapes() %>%
            clearMarkers() %>%
            clearMarkerClusters() %>%
            # setView(unlist(input$map_center)[1], unlist(input$map_center)[2],  zoom = input$map_zoom) %>%
            addCircles(locFiltered()$longitude, locFiltered()$latitude, weight = 3, radius=20,
                       color=pal(locFiltered()$stars), stroke = TRUE, fillOpacity = 0.8
                       ,label = circleLabel()) %>%
            
            # draw automatically generated cluster markers
            addMarkers(locFiltered()$longitude, locFiltered()$latitude, clusterOptions = markerClusterOptions(),
                       clusterId = "cluster1")
    })
    
    # cuisine anslysis panel's initial state
    cuiAnlyList = reactiveValues(cuisineAnalysis = HTML(includeHTML("analysis/empty.html")))
    
    # import korean analysis's html
    observeEvent(input$koreanAnalysis, {
        cuiAnlyList$cuisineAnalysis = HTML(includeHTML("analysis/korean.html"))
    })
    
    # import chinese analysis's html
    observeEvent(input$chineseAnalysis, {
        cuiAnlyList$cuisineAnalysis = HTML(includeHTML("analysis/chinese.html"))
    })
    
    # import thai analysis's html
    observeEvent(input$thaiAnalysis, {
        cuiAnlyList$cuisineAnalysis = HTML(includeHTML("analysis/thai.html"))
    })
    
    # import japanese analysis's html
    observeEvent(input$japaneseAnalysis, {
        cuiAnlyList$cuisineAnalysis = HTML(includeHTML("analysis/japanese.html"))
    })
    
    # import vietnamese analysis's html
    observeEvent(input$vietnameseAnalysis, {
        cuiAnlyList$cuisineAnalysis = HTML(includeHTML("analysis/vietnamese.html"))
    })
    
    # observe 5 button at the same time
    output$cuisineAnalysis <- renderUI({
        # if(is.null(cuiAnlyList$cuisineAnalysis)) return(HTML(""))
        cuiAnlyList$cuisineAnalysis
    })
    
    # print selected influential users' name
    output$influentialUser = renderText(as.character(userFiltered()$user_name), sep = "\n")
    
    # debug section
    # output$debug = renderText(length(restaurantLabel()))
}

# Run the application 
shinyApp(ui = ui, server = server)




