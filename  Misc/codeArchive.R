
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


# str(filterLocationByUser(cuisineSet))
# length(unique(attribute$business_id))

# attributeLabel = lapply(seq(nrow(attribute)), function(i){
#   paste0(attribute$name[i], "<br/>",
#          "Star: ", attribute$stars[i], "<br/>",
#          "Review Amout: ", attribute$review_count[i],
#          sep = "")
# })
# mapLabel = lapply(mapLabel, htmltools::HTML)
# location$mapLabel = mapLabel

# dropdownButton = function(label = "", status = c("default", "primary", "success", "info", "warning", "danger"), ..., width = NULL) {
#   
#   status = match.arg(status)
#   # dropdown button content
#   html_ul = list(
#     class = "dropdown-menu",
#     style = if (!is.null(width)) 
#       paste0("width: ", validateCssUnit(width), ";"),
#     lapply(X = list(...), FUN = tags$li, style = "margin-left: 10px; margin-right: 10px;")
#   )
#   # dropdown button apparence
#   html_button = list(
#     class = paste0("btn btn-", status," dropdown-toggle"),
#     type = "button", 
#     `data-toggle` = "dropdown"
#   )
#   html_button = c(html_button, list(label))
#   html_button = c(html_button, list(tags$span(class = "caret")))
#   # final result
#   tags$div(
#     class = "dropdown",
#     do.call(tags$button, html_button),
#     do.call(tags$ul, html_ul),
#     tags$script(
#       "$('.dropdown-menu').click(function(e) {
#       e.stopPropagation();
# });")
#   )
# }

# left closed, right open, [,)
# colorSet = c("black", "purple", "blue", "orange", "red")
# starSep = c(1., 2., 3., 4.)
# colorByColor = c()
# for(i in seq(1, nrow(torAsian))){
#   rank = ceiling(tail( rank(c(starSep, torAsian[i, "stars"])), n=1) )
#   colorByColor[i] = colorSet[rank]
# }
# location$color = colorByColor
# 
# starRange = c()
# 
# for(i in seq(1, length(starSep)+1)){
#   if(i == 1){
#     starRange[i] = paste("[", "0", ",", starSep[1], ")", sep = "")
#   }else if(i == length(starSep)+1){
#     starRange[i] = paste("[", starSep[i-1], ",", "5", "]", sep = "")
#   }else{
#     starRange[i] = paste("[", starSep[i-1], ",", starSep[i], ")", sep = "")
#   }
# }

# cuisine = c()
# for(i in seq(1, nrow(torAsian))){
#   ctgTemp = torAsian[i, c("name", "categories")]
#   ctgTemp = gsub(" ", "", ctgTemp, fixed = TRUE)
#   ctgTemp = unlist(strsplit(ctgTemp, ","))
#   
#   slctTemp = !is.na(match(tolower(cuisineSet), ctgTemp))
#   
#   if(sum(slctTemp) == 0){
#     cuisine[i] = "UndefinedCategory"
#   }else if(sum(slctTemp) == 1){
#     cuisine[i] = cuisineSet[ match(TRUE, slctTemp) ]
#   }else if(sum(slctTemp) >= 2 & sum(slctTemp) <=5){
#     cuisine[i] = 'MultipleCategory'
#   }else{
#     cuisine[i] = 'UnkownError'
#   }
# }
# torAsian$cuisine = cuisine
