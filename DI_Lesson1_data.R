req <- GET("http://data.neonscience.org/api/v0/products/DP3.30006.001")
avail <- fromJSON(content(req, as="text"))
aop <- GET(avail$data$siteCodes$availableDataUrls[[1]])
aop.list <- fromJSON(content(aop, as="text"))
aop.list$data$files$name
download.file(aop.list$data$files$url[200], paste("/Users/clunch/Desktop/", 
                                                 aop.list$data$files$name[200], sep=""))
