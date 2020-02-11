library(devtools)
library(neonUtilities)
library(geoNEON)
setwd("~/GitHub/NEON-geolocation/geoNEON")
options(stringsAsFactors = F)

bird <- loadByProduct(dpID='DP1.10003.001', site='WREF', check.size=F)
bird$brd_perpoint <- getLocByName(bird$brd_perpoint)
