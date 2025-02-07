library(devtools)
library(neonUtilities)
library(geoNEON)
setwd("/Users/clunch/GitHub/NEON-geolocation/geoNEON")
options(stringsAsFactors = F)
install('.')
check()
test()

loc <- getLocBySite('ARIK', type='AQU')
loc <- getLocBySite('SYCA', type='all', history=T, token=Sys.getenv('NEON_TOKEN'))
loc.is <- getLocBySite('ARIK', type='site', token='garbage')
loc.os <- getLocBySite('HARV', type='all')

loc <- getLocBySite('ABBY', type='TIS')

loc <- getLocBySite('BART', type='TOS')

loc <- getLocBySite('GUIL', type = "all", history = T)

# wtf people are using this below the site level
nogp <- geoNEON::getLocBySite("NOGP_037.mosquitoPoint.mos", token = Sys.getenv('NEON_TOKEN'))
nogp <- geoNEON::getLocBySite("NOGP_037.mosquitoPoint.mos", history=T, token = Sys.getenv('NEON_TOKEN'))

# spc
spc <- loadByProduct('DP1.10047.001', 
                     package='expanded', 
                     include.provisional = T, 
                     check.size=F)
sploc <- getLocTOS(spc$spc_perplot, 'spc_perplot', 
                   token=Sys.getenv('NEON_TOKEN'))

# no lat-long calculation
bird <- loadByProduct(dpID='DP1.10003.001', site='WREF', check.size=F)
perpoint.loc <- getLocByName(bird$brd_perpoint)
countdata.loc <- getLocTOS(bird$brd_countdata, 'brd_countdata', token=Sys.getenv('NEON_TOKEN'))

# lat-long calculation using Sarah's function
phe <- loadByProduct(dpID='DP1.10055.001', site='MOAB', check.size=F)
phe.loc <- getLocTOS(phe$phe_perindividual, 'phe_perindividual')
phe.name <- getLocByName(phe$phe_perindividual)

# lat-long calculation using my function
root <- loadByProduct(dpID='DP1.10067.001', site=c('TREE','TALL'), check.size=F)
root.loc <- getLocTOS(root$bbc_percore, 'bbc_percore')

sls <- loadByProduct(dpID='DP1.10086.001', site='UNDE', check.size=F)

bet <- loadByProduct(dpID='DP1.10022.001', site='TALL', check.size=F)

mos <- loadByProduct(dpID='DP1.10043.001', site='NIWO', check.size=F)

tick <- loadByProduct(dpID='DP1.10093.001', site=c('TALL','CLBJ'), check.size=F)


dhp <- loadByProduct(dpID='DP1.10017.001', check.size=F, token=Sys.getenv('NEON_TOKEN'))
dhp.loc <- getLocTOS(dhp$dhp_perimagefile, 'dhp_perimagefile', token=Sys.getenv('NEON_TOKEN'))

herb <- loadByProduct(dpID='DP1.10023.001', check.size=F, token=Sys.getenv('NEON_TOKEN'))
herb.loc <- getLocTOS(herb$hbp_perbout, 'hbp_perbout', token=Sys.getenv('NEON_TOKEN'))

herb.W <- loadByProduct(dpID='DP1.10023.001', site='WOOD', 
                        check.size=F, token=Sys.getenv('NEON_TOKEN'))
herb.W.loc <- getLocTOS(herb.W$hbp_perbout, 'hbp_perbout', token=Sys.getenv('NEON_TOKEN'))

cdw.tally <- loadByProduct(dpID='DP1.10010.001', check.size=F)
cdw.density <- loadByProduct(dpID='DP1.10014.001', check.size=F)

divJ <- loadByProduct(dpID='DP1.10058.001', site='JERC', 
                      check.size=F, token=Sys.getenv('NEON_TOKEN'))
divJ.loc <- getLocTOS(divJ$div_1m2Data, 'div_1m2Data', token=Sys.getenv('NEON_TOKEN'))

# testing subplot updates
vst <- loadByProduct(dpID='DP1.10098.001', site='ABBY', 
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))
vst.loc <- getLocTOS(vst$vst_mappingandtagging, 'vst_mappingandtagging', token=Sys.getenv('NEON_TOKEN'))
vst.shrub <- getLocTOS(vst$vst_shrubgroup, 'vst_shrubgroup', token=Sys.getenv('NEON_TOKEN'))
vst.nw <- getLocTOS(vst$`vst_non-woody`, 'vst_non-woody', token=Sys.getenv('NEON_TOKEN'))
vst.ind <- getLocTOS(vst$vst_apparentindividual, 'vst_apparentindividual', token=Sys.getenv('NEON_TOKEN'))

library(ggplot2)
gg <- ggplot(data=vst.ind, aes(x=adjEasting, y=adjNorthing, 
                               size=adjCoordinateUncertainty)) + # size is relative, not absolute
  geom_point(shape=0) +
  geom_point(data=vst.shrub, aes(x=adjEasting, y=adjNorthing), 
             shape=0, color='olivedrab') + 
  geom_point(data=vst.nw, aes(x=adjEasting, y=adjNorthing), 
             shape=0, color='darkblue') +
  geom_point(data=vst.loc, aes(x=adjEasting, y=adjNorthing), 
             shape='.', color='green')
gg

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

# megapit locations
mp <- loadByProduct(dpID='DP1.00096.001')
mpl <- getLocByName(mp$mgp_permegapit, locCol='pitNamedLocation', locOnly=T)


# #SOILAR100590 TOWER100594
# req <- httr::GET("http://data.neonscience.org/api/v0/locations/CFGLOC103160")
# loc <- jsonlite::fromJSON(httr::content(req, as='text', encoding='UTF-8'))

loc$data$locationChildrenUrls[which(substring(loc$data$locationChildren, 1, 4)!='SCBI')]



req <- httr::GET("http://data.neonscience.org/api/v0/locations/S2LOC111011?history=true")
loc <- jsonlite::fromJSON(httr::content(req, as='text', encoding='UTF-8'))

req <- httr::GET("http://data.neonscience.org/api/v0/locations/GWWELL112553?history=true")
loc <- jsonlite::fromJSON(httr::content(req, as='text', encoding='UTF-8'))

