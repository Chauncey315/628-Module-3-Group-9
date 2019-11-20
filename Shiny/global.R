rm(list = ls())

if(!require("jpeg")){
  install.packages("jpeg")
  require("jpeg")
}

# set working directory to source file location
torAsian = read.csv("data/asian_restaurant.csv")
attribute = read.csv("data/topuser100_attribute.csv")
userCuisineLabel = read.csv("data/label.csv")


torAsian$categories = tolower(torAsian[, "categories"])
# location = torAsian[, c("longitude", "latitude")]
location = torAsian[, c("longitude", "latitude", "stars", "name", "business_id", "review_count")]
centerTorAsian = apply(location[c("longitude", "latitude")], 2, mean)
centerTorAsian = as.vector(centerTorAsian)

pal = colorNumeric(palette = c("black", "red", "blue"), domain = location$stars)




cuisineSet = c("Chinese", "Japanese","Korean", "Thai", "Vietnamese")
attributeSet = c("Romantic", "Good for Group")
zoomCurrent = 10
centerCurrent = centerTorAsian

# chineseIcon = readJPEG("pic/chinese.jpg")
# str(attribute$attributes_Ambience[1])


districtSet = unique(torAsian$city)


starPrecision = 2

torAsian$cuisine = torAsian$new_category



findRestaurantByUser = function(userID){
  return(attribute[attribute$userid == userID, ])
}
# findRestaurantByUser("eEgeuz6Gg12HZkFZTfbb8A")

findUserByRestaurant = function(business_ID){
  return(attribute[attribute$business_id == business_ID, ])
}
# findUserByRestaurant("zA6gnF5aPBGoOm6uIbKt-A")






checkUserInCuisineCurrentSet = function(cuisineCurrentSet, userID){
  user = userCuisineLabel[userCuisineLabel$user_id == userID, ]
  userLabelSet = c()
  
  offset = 3
  counter = 1
  
  for(i in seq(1, 5)){
    if(user[, i+offset] == 1){
      # assume cuisineSet is of the same order as userCuisineLabel
      userLabelSet[counter] = tolower( cuisineSet[i] )
      counter = counter + 1
    }
  }
  
  checker = length(intersect(tolower(cuisineCurrentSet), tolower(userLabelSet))) != 0
  
  return(checker)
}

filterUser = function(cuisineCurrentSet){
  userSelector = sapply(userCuisineLabel$user_id, checkUserInCuisineCurrentSet, 
                        cuisineCurrentSet = cuisineCurrentSet)
  
  return(userCuisineLabel[userSelector, ])
  # return(userSelector)
}

filterLocation = function(cuisineCurrentSet, starCurrentRange, districtCurrentSet, searchKeywords){
  cuisineSelector = match(torAsian$cuisine, cuisineCurrentSet)
  cuisineSelector = !is.na(cuisineSelector)
  
  districtSelector = match(torAsian$city, districtCurrentSet)
  districtSelector = !is.na(districtSelector)
  
  starSelector = (torAsian$stars >= starCurrentRange[1]) & (torAsian$stars <= starCurrentRange[2])
  
  searchSelectorName = grepl(searchKeywords, location$name, ignore.case = TRUE)
  searchSelectorBusinessId = grepl(searchKeywords, location$business_id, ignore.case = FALSE)
  searchSelector = searchSelectorName | searchSelectorBusinessId
  
  aggregateSelector = cuisineSelector & starSelector & districtSelector & searchSelector
  return(location[aggregateSelector,])
}

match(torAsian$cuisine, cuisineSet)

mapLabel = lapply(seq(nrow(location)), function(i){
  paste0(location$name[i], "<br/>",
         "Star: ", location$stars[i], "<br/>",
         "Review Amout: ", location$review_count[i],
         sep = "")
})
mapLabel = lapply(mapLabel, htmltools::HTML)
location$mapLabel = mapLabel

getAttributeMeaning = function(attributeValue){
  if(is.na(attributeValue)){
    return("Missing Value")
  }else if(attributeValue == 0){
    return("No")
  }else if(attributeValue == 1){
    return("Yes")
  }else if(attributeValue == 2){
    return("Not Defined in Dataset")
  }else{
    return("Unknown Error")
  }
}

getPriceRangeMeaning = function(attributeValue){
  if(is.na(attributeValue)){
    return("Missing Value")
  }else if(attributeValue == 1){
    return("$")
  }else if(attributeValue == 2){
    return("$$")
  }else if(attributeValue == 3){
    return("$$$")
  }else{
    return("Unknown Error")
  }
}


  
attributeColumnRange = seq(3, 13)
attributeOffset = attributeColumnRange[1] - 1
restaurantAttribute = attribute[c(), attributeColumnRange]

torAsianColumnRange = seq(3, 7)
torAsianOffset = tail(attributeColumnRange, n = 1) - 
  attributeOffset + 1 - torAsianColumnRange[1]

restaurantAttribute$name = torAsian[c(), "name"]
restaurantAttribute$city = torAsian[c(), "city"]
restaurantAttribute$latitude = torAsian[c(), "latitude"]
restaurantAttribute$longitude = torAsian[c(), "longitude"]
restaurantAttribute$stars_float = torAsian[c(), "stars"]
# restaurantAttribute$label = location[c(), "mapLabel"]

restaurantUnique = unique(attribute$business_id)
for(i in seq(1, length(restaurantUnique))){
  restaurantAttribute[i, attributeColumnRange - attributeOffset] = 
    attribute[attribute$business_id == restaurantUnique[i], attributeColumnRange][1,]
  
  restaurantAttribute[i, torAsianColumnRange + torAsianOffset] = 
    torAsian[as.character(torAsian$business_id) == as.character(restaurantUnique[i]), torAsianColumnRange][1,]
}
# str(restaurantAttribute)

restaurantLabel = lapply(seq(nrow(restaurantAttribute)), function(i){
  userIDByRestaurant = as.vector(findUserByRestaurant(restaurantAttribute$business_id[i])$userid)
  userNameByRestaurant = !is.na( match(as.vector(userCuisineLabel$user_id), userIDByRestaurant) )
  userNameByRestaurant = as.vector( userCuisineLabel$user_name[userNameByRestaurant] )
  
  userHTML = c()
  for( i in seq(1, length(userNameByRestaurant)) ){
    userHTML = paste0(userHTML, "<br/>", userNameByRestaurant[i], sep = "")
  }
  
  paste0(restaurantAttribute$name[i], "<br/>",
         "Star: ", restaurantAttribute$stars_float[i], "<br/>",
         "Alcohal: ", getAttributeMeaning(restaurantAttribute$Alcohol[i]), "<br/>",
         "Good For Kids: ", getAttributeMeaning(restaurantAttribute$GoodForKids[i]), "<br/>",
         "TV: ", getAttributeMeaning(restaurantAttribute$HasTV[i]), "<br/>",
         "Outdoor Seating: ", getAttributeMeaning(restaurantAttribute$OutdoorSeating[i]), "<br/>",
         "Delivery: ", getAttributeMeaning(restaurantAttribute$RestaurantsDelivery[i]), "<br/>",
         "Price Range: ", getPriceRangeMeaning(restaurantAttribute$attributes_RestaurantsPriceRange2[i]), "<br/>",
         "Take Out: ", getAttributeMeaning(restaurantAttribute$RestaurantsTakeOut[i]), "<br/>",
         "Influential Users: ", 
         userHTML,
         sep = ""
  )
})
restaurantLabel = lapply(restaurantLabel, htmltools::HTML)
restaurantAttribute$restaurantLabel = restaurantLabel



filterLocationByUser = function(cuisineCurrentSet){
  currentUser = filterUser(cuisineCurrentSet)
  restaurantFlitered = c()
  for(i in seq(1, nrow(currentUser))){
    restTemp = as.vector(findRestaurantByUser(currentUser$user_id[i])$business_id)
    restaurantFlitered = c(restaurantFlitered, restTemp)
  }
  restaurantFlitered = unique(restaurantFlitered)
  
  restautantSelector = match(restaurantAttribute$business_id, restaurantFlitered)
  restautantSelector = !is.na(restautantSelector)
  
  
  
  return(restaurantAttribute[restautantSelector, ])
}

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
