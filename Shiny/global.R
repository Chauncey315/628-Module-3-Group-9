rm(list = ls())

if(!require("png")){
  install.packages("png")
  require("png")
}

# set working directory to source file location

# torAsian contains information about asian restaurants in Toronto
torAsian = read.csv("data/asian_restaurant.csv")

# attribute contains information about popular restaurants' attribute
attribute = read.csv("data/topuser100_attribute.csv")

# userCuisineLabel contains information about influential users' favorite
userCuisineLabel = read.csv("data/label.csv")


torAsian$categories = tolower(torAsian[, "categories"])

# location is a subset of torAsian for future data manipulation
location = torAsian[, c("longitude", "latitude", "stars", "name", "business_id", "review_count")]

# get the center of all asian restaurants in Toronto
# as the leaflet map's initial view center
centerTorAsian = apply(location[c("longitude", "latitude")], 2, mean)
centerTorAsian = as.vector(centerTorAsian)

# build a function between color and restaurants' star
# so that restaurants' star can be represented by color in leaflet map
pal = colorNumeric(palette = c("black", "red", "blue"), domain = location$stars)



# the cuisine set we will consider
cuisineSet = c("Chinese", "Japanese","Korean", "Thai", "Vietnamese")

# get the names of Great Totonto's 7 district
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





# check whether a particular user is in the currently selected cuisine set
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

# find out the details about users who are in the currently selected cuisine set
filterUser = function(cuisineCurrentSet){
  userSelector = sapply(userCuisineLabel$user_id, checkUserInCuisineCurrentSet, 
                        cuisineCurrentSet = cuisineCurrentSet)
  
  return(userCuisineLabel[userSelector, ])
  # return(userSelector)
}

# filter restaurant by interative map selector
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

# we defined popular restaurants as influential users' favorite restaurants

# produce a suitable html string for popular restaurant's pop-up label 
mapLabel = lapply(seq(nrow(location)), function(i){
  paste0(location$name[i], "<br/>",
         "Star: ", location$stars[i], "<br/>",
         "Review Amout: ", location$review_count[i],
         sep = "")
})
mapLabel = lapply(mapLabel, htmltools::HTML)
location$mapLabel = mapLabel

# translate numeric attribute value to string value
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

# translate price range's numeric attribute value to string value
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


# create a dataframe of details about popular restaurant
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

# produce a suitable html string for popular restaurant's pop-up label 
restaurantLabel = lapply(seq(nrow(restaurantAttribute)), function(i){
  userIDByRestaurant = as.vector(findUserByRestaurant(restaurantAttribute$business_id[i])$userid)
  userNameByRestaurant = !is.na( match(as.vector(userCuisineLabel$user_id), userIDByRestaurant) )
  userNameByRestaurant = as.vector( userCuisineLabel$user_name[userNameByRestaurant] )
  
  # produce a html string for restaurants' frequent visitor or patronizer
  userHTML = c()
  for( i in seq(1, length(userNameByRestaurant)) ){
    userHTML = paste0(userHTML, "<br/>", userNameByRestaurant[i], sep = "")
  }
  
  # produce a html string for restaurants' detail
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


# produce a dataframe of the currently selected popular restaurants'
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




