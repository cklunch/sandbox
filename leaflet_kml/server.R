library(shiny)
library(leaflet)
library(rgdal)
library(magrittr)
library(rmapshaper)
library(mapview)
library(Rcpp)
setwd("/Users/clunch/Dropbox/data/NEON data/AOP/kmls/")

server <- function(input, output, session) {
  
  files <- list.files(".")
  
  site.inp <- eventReactive(input$site, {

    test <- readOGR(files[grep(input$site, files)])
    x <- as.numeric(coordinates(test)[1,1])
    y <- as.numeric(coordinates(test)[1,2])
    
    labels <- sprintf(as.character(test$Name)) %>% lapply(htmltools::HTML)
    
    out <- list(test=test, x=x, y=y, labels=labels)
    return(out)
    
  })
  
  output$m <- renderLeaflet(
    leaflet() %>%
      addProviderTiles("Esri.WorldImagery") %>%
      setView(lng = site.inp()$x, lat = site.inp()$y, zoom = 10) %>%
      addPolygons(data = site.inp()$test, color = "yellow", weight = 1, 
                  smoothFactor = 1, opacity = 1, fillOpacity = 0.3,
                  highlight = highlightOptions(weight = 5,
                                               color = "#666",
                                               fillOpacity = 0.7,
                                               bringToFront = TRUE),
                  label = site.inp()$labels,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")
      )
  )

}