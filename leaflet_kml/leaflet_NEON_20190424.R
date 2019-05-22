# trying leaflet

library(leaflet)
library(rgdal)
library(magrittr)
library(rmapshaper)
library(mapview)
library(Rcpp)

#memory.limit(size=20000)

setwd("/Users/clunch/Dropbox/data/NEON data/AOP/kmls/")

### prepping AOP kmls ####


#####################################
######## read in clean kmls ######### 

files <- list.files(".")
n <- length(files)

test <- readOGR(files[1])
x <- as.numeric(coordinates(test)[1,1])
y <- as.numeric(coordinates(test)[1,2])

labels <- sprintf(as.character(test$Name)) %>% lapply(htmltools::HTML)

m <- leaflet() %>%
  addProviderTiles("Esri.WorldImagery") %>%
  setView(lng = x, lat = y, zoom = 10) %>%
  addPolygons(data = test, color = "yellow", weight = 1, 
              smoothFactor = 1, opacity = 1, fillOpacity = 0.3,
              highlight = highlightOptions(weight = 5,
                                           color = "#666",
                                           fillOpacity = 0.7,
                                           bringToFront = TRUE),
              label = labels,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto")
              )

m

