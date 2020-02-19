library(devtools)
library(neonUtilities)
library(geoNEON)
setwd("/Users/clunch/GitHub/NEON-geolocation/geoNEON")
options(stringsAsFactors = F)
install('.')

bird <- loadByProduct(dpID='DP1.10003.001', site='WREF', check.size=F)
bird$brd_perpoint <- getLocByName(bird$brd_perpoint)
bird$brd_countdata <- getLocTOS(bird$brd_countdata, 'brd_countdata')

