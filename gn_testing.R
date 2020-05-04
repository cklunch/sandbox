library(devtools)
library(neonUtilities)
library(geoNEON)
setwd("/Users/clunch/GitHub/NEON-geolocation/geoNEON")
options(stringsAsFactors = F)
install('.')

loc <- getLocBySite('ARIK', type='AQU')
loc <- getLocBySite('SYCA', type='all', history=T)
loc.is <- getLocBySite('ARIK', type='IS')
loc.os <- getLocBySite('ARIK', type='OS')

bird <- loadByProduct(dpID='DP1.10003.001', site='WREF', check.size=F)
perpoint.loc <- getLocByName(bird$brd_perpoint)
countdata.loc <- getLocTOS(bird$brd_countdata, 'brd_countdata')

phe <- loadByProduct(dpID='DP1.10055.001', site='MOAB', check.size=F)
phe.loc <- getLocTOS(phe$phe_perindividual, 'phe_perindividual')

sls <- loadByProduct(dpID='DP1.10086.001', site='UNDE', check.size=F)

bet <- loadByProduct(dpID='DP1.10022.001', site='TALL', check.size=F)

mos <- loadByProduct(dpID='DP1.10043.001', site='NIWO', check.size=F)

tick <- loadByProduct(dpID='DP1.10093.001', site=c('TALL','CLBJ'), check.size=F)

root <- loadByProduct(dpID='DP1.10067.001', site=c('TREE','TALL'), check.size=F)
root.loc <- getLocTOS(root$bbc_percore, 'bbc_percore')

dhp <- loadByProduct(dpID='DP1.10017.001', site='SJER', check.size=F)

cdw.tally <- loadByProduct(dpID='DP1.10010.001', check.size=F)
cdw.density <- loadByProduct(dpID='DP1.10014.001', check.size=F)

vst <- loadByProduct(dpID='DP1.10098.001', site='STEI', check.size=F)
vst.loc <- getLocTOS(vst$vst_mappingandtagging, 'vst_mappingandtagging')
byTileAOP(dpID='DP3.30015.001', site='STEI', year=2017,
          easting=vst.loc$adjEasting, northing=vst.loc$adjNorthing,
          savepath='/Users/clunch/Desktop')

veg <- loadByProduct(dpID='DP1.10098.001', check.size=F)
veg.loc <- getLocTOS(veg$vst_mappingandtagging, 'vst_mappingandtagging')
badpoints <- veg.loc$points[which((!is.na(veg.loc$pointID)) & is.na(veg.loc$adjEasting) & 
                                    (!is.na(veg.loc$stemDistance)) & (!is.na(veg.loc$stemAzimuth)))]
badpoints <- unique(badpoints)
write.table(badpoints, '/Users/clunch/Desktop/vegpoints.csv', sep=',', quote=F, row.names=F)

req <- httr::GET("http://data.neonscience.org/api/v0/locations/SCBI")
req <- httr::GET("http://data.neonscience.org/api/v0/locations/ARIK")
loc <- jsonlite::fromJSON(httr::content(req, as='text', encoding='UTF-8'))

req <- httr::GET("http://data.neonscience.org/api/v0/locations/S2LOC100103")


# #SOILAR100590 TOWER100594
# req <- httr::GET("http://data.neonscience.org/api/v0/locations/CFGLOC103160")
# loc <- jsonlite::fromJSON(httr::content(req, as='text', encoding='UTF-8'))

loc$data$locationChildrenUrls[which(substring(loc$data$locationChildren, 1, 4)!='SCBI')]



req <- httr::GET("http://data.neonscience.org/api/v0/locations/S2LOC111011?history=true")
loc <- jsonlite::fromJSON(httr::content(req, as='text', encoding='UTF-8'))

req <- httr::GET("http://data.neonscience.org/api/v0/locations/GWWELL112553?history=true")
loc <- jsonlite::fromJSON(httr::content(req, as='text', encoding='UTF-8'))

