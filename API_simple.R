library(neonUtilities)
library(httr)
library(jsonlite)
library(downloader)

req.soil <- GET("http://data.neonscience.org/api/v0/products/DP1.00041.001")
avail.soil <- fromJSON(content(req.soil, as="text"), simplifyDataFrame=T, flatten=T)
temp.urls <- unlist(avail.soil$data$siteCodes$availableDataUrls)
tmp <- GET(temp.urls[grep("MOAB/2019-07", temp.urls)])
tmp.files <- fromJSON(content(tmp, as="text"))
tmp.files$data$files$name

download(tmp.files$data$files$url[grep("zip", tmp.files$data$files$name, fixed=T)[1]], 
         paste("/Users/clunch/Desktop", "test.zip", sep="/"), mode="wb")
