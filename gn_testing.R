library(devtools)
library(neonUtilities)
library(geoNEON)
setwd("/Users/clunch/GitHub/NEON-geolocation/geoNEON")
options(stringsAsFactors = F)
install('.')

bird <- loadByProduct(dpID='DP1.10003.001', site='WREF', check.size=F)
perpoint.loc <- getLocByName(bird$brd_perpoint)
countdata.loc <- getLocTOS(bird$brd_countdata, 'brd_countdata')

phe <- loadByProduct(dpID='DP1.10055.001', site='MOAB', check.size=F)
phe.loc <- getLocTOS(phe$phe_perindividual, 'phe_perindividual')

vst <- loadByProduct(dpID='DP1.10098.001', site='STEI', check.size=F,
                     package='expanded')
vst.loc <- getLocTOS(vst$vst_mappingandtagging[which(!is.na(vst$vst_mappingandtagging$pointID)),], 
                     'vst_mappingandtagging')

req <- httr::GET("http://data.neonscience.org/api/v0/locations/SCBI")
loc <- jsonlite::fromJSON(httr::content(req, as='text', encoding='UTF-8'))

#SOILAR100590 TOWER100594
req <- httr::GET("http://data.neonscience.org/api/v0/locations/CFGLOC103160")
loc <- jsonlite::fromJSON(httr::content(req, as='text', encoding='UTF-8'))

loc$data$locationChildrenUrls[which(substring(loc$data$locationChildren, 1, 4)!='SCBI')]
