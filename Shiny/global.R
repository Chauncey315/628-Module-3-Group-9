rm(list = ls())

# set working directory to source file location
torAsian = read.csv("data/asian_restaurant.csv")
torAsian$categories = tolower(torAsian[, "categories"])
# location = torAsian[, c("longitude", "latitude")]
location = torAsian[, c("longitude", "latitude", "stars", "name", "business_id")]




centerTorAsian = apply(location[c("longitude", "latitude")], 2, mean)
pal = colorNumeric(palette = c("black", "red", "blue"), domain = location$stars)




cuisineSet = c("Chinese", "Korean", "Japanese", "Vietnamese", "Thai")

districtSet = unique(torAsian$city)


starPrecision = 2

torAsian$cuisine = torAsian$new_category

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

location$mapLabel = paste(location$name, ", Star: ", location$stars, sep = "")




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
