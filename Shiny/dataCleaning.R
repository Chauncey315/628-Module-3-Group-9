rm(list = ls())

# set working directory to source file location
torAsian = read.csv("data/tor_asianrestaurant.csv")
location = torAsian[, c("longitude", "latitude")]

# left closed, right open, [,)
color = c("black", "purple", "blue", "orange", "red")
starSep = c(1., 2., 3., 4.)
# color_starSep = data.frame(color, starSep)

colorByColor = c()

for(i in seq(1, nrow(torAsian[]))){
  rank = tail( rank(c(starSep, torAsian[i, "stars"])), n=1)
  colorByColor[i] = color[rank]
}

location$color = colorByColor