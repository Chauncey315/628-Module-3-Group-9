# This is the Shiny app for STAT 628, Module 3, Group 9
rm(list = ls())

library(shiny)
library(leaflet)
library(knitr)
library(markdown)

source("global.R")

ui <- navbarPage(
    "Yelp Business Analysis", id = "nav",
    # theme = "superZip.css",
    
    
    
    tabPanel("Interactive Map",
             div(class="myouter",
                 theme = "superZip.css",
                 tags$head(#includeCSS("www/superZip.css")
                     tags$link(rel = "stylesheet", type = "text/css", href = "superZip.css")),
                 
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

                               checkboxGroupInput(inputId = "cuisineSet", label = "Cuisine",
                                                  choices = cuisineSet, selected = cuisineSet),
                               checkboxGroupInput(inputId = "districtSet", label = "District",
                                                  choices = districtSet, selected = districtSet),
                               
                               tags$hr(),
                               
                               h2("UDar"),
                               p("Search Influential Users by Cuisine & their Favorite Restaurants"),
                               
                               checkboxGroupInput(inputId = "userCuisineSet", label = "Cuisine",
                                                  choices = cuisineSet, selected = NULL),
                               
                               
                               # tags$hr(),
                               # textOutput(outputId = "debug")
                               
                 ),
                 
                 absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                               draggable = TRUE, top = 310, left = "auto", bottom = "auto",
                               width = 220, height = "auto",style = "overflow-y:scroll; max-height: 550px",
                               right = 20,
                               
                               h3("Influential Users"),
                               
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
                 
                 absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                               draggable = TRUE, top = 130, left = "auto", bottom = "auto",
                               width = 600, height = "auto",style = "overflow-y:scroll; max-height: 600px",
                               right = 120,
                               uiOutput("cuisineAnalysis"),
                               # imageOutput(outputId = "restStarDist")
                 ),
                 
                 div(class = "gallery",
                     div(class = "thumbnail",
                         img(src='pic/korean.jpg', class = "cards",
                             width="4000", alt=""),
                         actionLink( label = h3("Korean Restaurant"), inputId = "koreanAnalysis" )
                         # div("Know More", class = "button", inputId = "ka")
                         ),
                     div(class = "thumbnail",
                         img(src='pic/chinese.jpg', class = "cards",
                             width="4000", alt=""),
                         actionLink( label = h3("Chinese Restaurant"), inputId = "chineseAnalysis" )
                     )
                     
                 ),

                 div(class = "gallery",
                     div(class = "thumbnail",
                         img(src='pic/thai.jpg', class = "cards",
                             width="4000", alt=""),
                         actionLink( label = h3("Thai Restaurant"), inputId = "thaiAnalysis" )
                     ),
                     div(class = "thumbnail",
                         img(src='pic/japanese.jpg', class = "cards",
                             width="4000", alt=""),
                         actionLink( label = h3("Japanese Restaurant"), inputId = "japaneseAnalysis" )
                     )
                 ),
                 
                 div(class = "gallery",
                     div(class = "thumbnail",
                         img(src='pic/vietnamese.jpg', class = "cards",
                             width="4000", alt=""),
                         actionLink( label = h3("Vietnamese Restaurant"), inputId = "vietnameseAnalysis" )
                         )
                 )
             )
    )
)



# Define server logic required to draw a histogram
server <- function(input, output, session){
    locFiltered = reactive(filterLocation( input$cuisineSet, input$starRange, input$districtSet,
                                           input$search))
    
    userFiltered = reactive(filterUser(input$userCuisineSet))
    locFilteredByUser = reactive(filterLocationByUser(input$userCuisineSet))
    
    circleLabel = reactive({
        if(length(locFiltered()$mapLabel) == 0){
            return(location$mapLabel)
        }else{
            return(locFiltered()$mapLabel)
        }
    })
    
    restaurantLabel = reactive({
        if(length(locFilteredByUser()$restaurantLabel) == 0){
            return(restaurantAttribute$restaurantLabel)
        }else{
            return(locFilteredByUser()$restaurantLabel)
        }
    })
    
    output$map = renderLeaflet({
        leaflet() %>% 
            addTiles() %>%
            setView(centerTorAsian[1], centerTorAsian[2],  zoom = 10) %>% 
            addCircles(location$longitude, location$latitude, weight = 3, radius=20, 
                       color=pal(location$stars), stroke = TRUE, fillOpacity = 0.8
                       ,label = circleLabel()) %>% 
            addMarkers(location$longitude, location$latitude, clusterOptions = markerClusterOptions(),
                       clusterId = "cluster1") %>%
            addLegend("topright", pal = pal, values = location$stars, bins = 7,
                      title = "Star")
    })
    
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
            addMarkers(locFilteredByUser()$longitude, locFilteredByUser()$latitude, clusterOptions = markerClusterOptions(),
                       clusterId = "cluster1")
    })
    
    observe({
        leafletProxy("map") %>%
            clearShapes() %>%
            clearMarkers() %>%
            clearMarkerClusters() %>%
            # setView(unlist(input$map_center)[1], unlist(input$map_center)[2],  zoom = input$map_zoom) %>%
            addCircles(locFiltered()$longitude, locFiltered()$latitude, weight = 3, radius=20,
                       color=pal(locFiltered()$stars), stroke = TRUE, fillOpacity = 0.8
                       ,label = circleLabel()) %>%
            addMarkers(locFiltered()$longitude, locFiltered()$latitude, clusterOptions = markerClusterOptions(),
                       clusterId = "cluster1")
    })
    
    
    cuiAnlyList = reactiveValues(cuisineAnalysis = HTML(includeHTML("analysis/empty.html")))
    
    observeEvent(input$koreanAnalysis, {
        cuiAnlyList$cuisineAnalysis = HTML(includeHTML("analysis/korean.html"))
    })
    
    observeEvent(input$chineseAnalysis, {
        cuiAnlyList$cuisineAnalysis = HTML(includeHTML("analysis/chinese.html"))
    })
    
    observeEvent(input$thaiAnalysis, {
        cuiAnlyList$cuisineAnalysis = HTML(includeHTML("analysis/thai.html"))
    })
    
    observeEvent(input$japaneseAnalysis, {
        cuiAnlyList$cuisineAnalysis = HTML(includeHTML("analysis/japanese.html"))
    })
    
    observeEvent(input$vietnameseAnalysis, {
        cuiAnlyList$cuisineAnalysis = HTML(includeHTML("analysis/vietnamese.html"))
    })
    
    output$cuisineAnalysis <- renderUI({
        # if(is.null(cuiAnlyList$cuisineAnalysis)) return(HTML(""))
        output$restStarDist = renderImage({
            return(list(
                src = "cn_restaurant_star.png",
                contentType = "image/png",
                alt = "Chinese Restaurant Star Distribution"
            ))
        }, deleteFile = FALSE)
        cuiAnlyList$cuisineAnalysis
    }
    
    )
    
    # output$debug = renderText(length(restaurantLabel()))
    output$influentialUser = renderText(as.character(userFiltered()$user_name), sep = "\n")
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)

# dropdownButton(label = "Select Cuisine", status = "default", width = 80,
#                checkboxGroupInput(inputId = "cuisineSet", label = "Cuisine",
#                                   choices = cuisineSet, selected = cuisineSet)),
# dropdownButton(label = "Select District", status = "default", width = 80,
#                checkboxGroupInput(inputId = "districtSet", label = "District",
#                                   choices = districtSet, selected = districtSet)),

# tabPanel("Cuinalysis",
#          # div(class="jumbotron",
#          #     # theme="flatly.css",
#          #     # tags$head(
#          #     #     tags$link(rel = "stylesheet", type = "text/css", href = "flatly.css")
#          #     ),
#              
#              h1("Cuisine Analysis", class = "display-3"),
#              hr(class = "my-4"),
#              p("Get insights for your business, if you are a business owner of")
#          ),
#          
#          div(class = "card border-primary mb-3", style="max-width: 20rem;",
#              div(class="card-header", "Header"),
#              div(class = "card-body", 
#                  h4("Primary Card Title", class = "card-title")),
#              img(src='pic/chinese.jpg', height = 100),
#              p("Some quick example text to build on the card title 
#                and make up the bulk of the card's content", class="card-text")
#              )
#              
#          
# ),


# output$map = renderLeaflet({
#     leaflet() %>% 
#         addTiles() %>% 
#         setView(centerTorAsian[1], centerTorAsian[2],  zoom = 10) %>% 
#         addCircles(locFiltered()$longitude, locFiltered()$latitude, weight = 3, radius=20, 
#                    color=pal(locFiltered()$stars), stroke = TRUE, fillOpacity = 0.8
#                    ,label = circleLabel()
#         ) %>% 
#         addMarkers(locFiltered()$longitude, locFiltered()$latitude, clusterOptions = markerClusterOptions(),
#                    clusterId = "cluster1") %>%
#         addLegend("topright", pal = pal, values = location$stars, bins = 7,
#                   title = "Star")
#     
# })

