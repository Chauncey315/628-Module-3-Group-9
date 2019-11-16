rm(list = ls())

# set working directory to source file location
torAsian = read.csv("data/tor_asianrestaurant.csv")
torAsian$categories = tolower(torAsian[, "categories"])
location = torAsian[, c("longitude", "latitude")]

# left closed, right open, [,)
color = c("black", "purple", "blue", "orange", "red")
starSep = c(1., 2., 3., 4.)
# color_starSep = data.frame(color, starSep)

colorByColor = c()

for(i in seq(1, nrow(torAsian))){
  rank = ceiling(tail( rank(c(starSep, torAsian[i, "stars"])), n=1) )
  colorByColor[i] = color[rank]
}

location$color = colorByColor

cuisineSet = c("Chinese", "Korean", "Japanese", "Thai", "Vietnam")

starRange = c()

for(i in seq(1, length(starSep)+1)){
  if(i == 1){
    starRange[i] = paste("[", "0", ",", starSep[1], ")", sep = "")
  }else if(i == length(starSep)+1){
    starRange[i] = paste("[", starSep[i-1], ",", "5", "]", sep = "")
  }else{
    starRange[i] = paste("[", starSep[i-1], ",", starSep[i], ")", sep = "")
  }
}

starPrecision = 2

cuisine = c()
for(i in seq(1, nrow(torAsian))){
  
}
torAsian[1, c("name", "categories")]
match( torAsian[1, "categories"], cuisineSet )

str(torAsian$categories[1])

length(torAsian$categories[1])
