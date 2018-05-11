library(httr)
library(jsonlite)
library(dplyr)
library(googlesheets)

# get availability list
req <- GET("http://data.neonscience.org/api/v0/products")
ls <- fromJSON(content(req, as="text"))

# get site list
s.req <- GET("http://data.neonscience.org/api/v0/sites")
sites <- fromJSON(content(s.req, as="text"))

# set up data frame
current <- data.frame(matrix(0, nrow=180, ncol=83))
colnames(current)[1:2] <- c("DPID","DPName")
colnames(current)[3:83] <- sites[[1]]$siteCode
current$DPID <- ls[[1]]$productCode
current$DPName <- ls[[1]]$productName

# populate with 1 for availability, 0 for no
for(i in 1:nrow(current)) {
  dp.sites <- ls[[1]]$siteCodes[[i]]$siteCode
  current[i,which(colnames(current) %in% dp.sites)] <- 1
}

# next up: include NAs for sites that won't ever have product

# for latency: import transition wait times google sheet

