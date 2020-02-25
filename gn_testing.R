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
