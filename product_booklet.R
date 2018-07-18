library(httr)
library(jsonlite)
library(dplyr, quietly=T)
library(devtools)
req <- GET("http://data.neonscience.org/api/v0/products")
prod.list <- fromJSON(content(req, as="text"), simplifyDataFrame=T, flatten=T)
prod.frm <- prod.list[[1]]
