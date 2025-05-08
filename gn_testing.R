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

locA <- getLocBySite('ABBY', type='TIS')

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

sppl <- getLocByName(spc$spc_perplot, token=Sys.getenv('NEON_TOKEN'))
sppl$eastMin <- as.numeric(sppl$easting) - 
  as.numeric(substring(sppl$plotDimensions, 1, 2))/2
sppl$eastMax <- as.numeric(sppl$easting) + 
  as.numeric(substring(sppl$plotDimensions, 1, 2))/2
sppl$northMin <- as.numeric(sppl$northing) - 
  as.numeric(substring(sppl$plotDimensions, 1, 2))/2
sppl$northMax <- as.numeric(sppl$northing) + 
  as.numeric(substring(sppl$plotDimensions, 1, 2))/2

which(sploc$adjEasting > sppl$eastMax | sploc$adjEasting < sppl$eastMin)
length(which(sploc$adjEasting > sppl$eastMax | sploc$adjEasting < sppl$eastMin))
sz <- as.numeric(substring(sppl$plotDimensions, 1, 2))/2

symbols(sppl$easting[which(sppl$plotID=='BART_062')], 
        sppl$northing[which(sppl$plotID=='BART_062')], 
        squares=sz[which(sppl$plotID=='BART_062')], 
        inches=F, xlim=c(315290,315320), ylim=c(4880810,4880845))
symbols(sploc$adjEasting[which(sploc$plotID=='BART_062')],
        sploc$adjNorthing[which(sploc$plotID=='BART_062')],
        circles=0.1, inches=F, add=T)

symbols(sppl$easting[which(sppl$plotID=='SCBI_017')], 
        sppl$northing[which(sppl$plotID=='SCBI_017')], 
        squares=sz[which(sppl$plotID=='SCBI_017')], 
        inches=F, xlim=c(748480,748510), ylim=c(4307280,4307310))
symbols(sploc$adjEasting[which(sploc$plotID=='SCBI_017')],
        sploc$adjNorthing[which(sploc$plotID=='SCBI_017')],
        circles=0.1, inches=F, add=T)


sim <- loadByProduct('DP1.10111.001', site='HARV', 
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))



# no lat-long calculation
bird <- loadByProduct(dpID='DP1.10003.001', site='WREF', check.size=F)
perpoint.loc <- getLocByName(bird$brd_perpoint)
countdata.loc <- getLocTOS(bird$brd_countdata, 'brd_countdata', token=Sys.getenv('NEON_TOKEN'))

# lat-long calculation using Sarah's function
phe <- loadByProduct(dpID='DP1.10055.001', site='OSBS', check.size=F)
phe.loc <- getLocTOS(phe$phe_perindividual, 'phe_perindividual')
phe.name <- getLocByName(phe$phe_perindividual)

# lat-long calculation using my function
root <- loadByProduct(dpID='DP1.10067.001', site=c('TREE','TALL'), check.size=F)
root.loc <- getLocTOS(root$bbc_percore, 'bbc_percore')

sls <- loadByProduct(dpID='DP1.10086.001', site='JERC', check.size=F)
sls.loc <- getLocTOS(sls$sls_soilCoreCollection, dataProd='sls_soilCoreCollection', 
                     token=Sys.getenv('NEON_TOKEN'))

bet <- loadByProduct(dpID='DP1.10022.001', site='JERC', check.size=F)
bet.loc <- getLocTOS(bet$bet_fielddata, dataProd='bet_fielddata', 
                     token=Sys.getenv('NEON_TOKEN'))

mos <- loadByProduct(dpID='DP1.10043.001', site='NIWO', check.size=F)

tick <- loadByProduct(dpID='DP1.10093.001', site=c('TALL','CLBJ'), check.size=F)


dhp <- loadByProduct(dpID='DP1.10017.001', site=c('OSBS','JERC'), 
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))
dhp.loc <- getLocTOS(dhp$dhp_perimagefile, 'dhp_perimagefile', token=Sys.getenv('NEON_TOKEN'))

herb <- loadByProduct(dpID='DP1.10023.001', check.size=F, token=Sys.getenv('NEON_TOKEN'))
herb.loc <- getLocTOS(herb$hbp_perbout, 'hbp_perbout', token=Sys.getenv('NEON_TOKEN'))

herb <- loadByProduct(dpID='DP1.10023.001', site=c('BART','GRSM'), 
                        check.size=F, token=Sys.getenv('NEON_TOKEN'))
herb.loc <- getLocTOS(herb$hbp_perbout, 'hbp_perbout', token=Sys.getenv('NEON_TOKEN'))

herb.K <- loadByProduct(dpID='DP1.10023.001', site='KONA', 
                        check.size=F, token=Sys.getenv('NEON_TOKEN'))
herb.K.loc <- getLocTOS(herb.K$hbp_perbout, 'hbp_perbout', token=Sys.getenv('NEON_TOKEN'))

plot(herb.K.loc$adjNorthing~herb.K.loc$adjEasting, pch=0)

cdw.tally <- loadByProduct(dpID='DP1.10010.001', check.size=F)
cdw.loc <- getLocTOS(cdw.tally$cdw_fieldtally, 'cdw_fieldtally', token=Sys.getenv('NEON_TOKEN'))

cdw.density <- loadByProduct(dpID='DP1.10014.001', check.size=F)

divJ <- loadByProduct(dpID='DP1.10058.001', site='JERC', 
                      check.size=F, token=Sys.getenv('NEON_TOKEN'))
divJ.loc <- getLocTOS(divJ$div_1m2Data, 'div_1m2Data', token=Sys.getenv('NEON_TOKEN'))

div <- loadByProduct(dpID='DP1.10058.001', site='OSBS', 
                      check.size=F, token=Sys.getenv('NEON_TOKEN'))
div.loc <- getLocTOS(div$div_1m2Data, 'div_1m2Data', token=Sys.getenv('NEON_TOKEN'))
div.100 <- getLocTOS(div$div_10m2Data100m2Data, 'div_10m2Data100m2Data', token=Sys.getenv('NEON_TOKEN'))

# testing subplot updates
vst <- loadByProduct(dpID='DP1.10098.001', site='ABBY', 
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))
vst.loc <- getLocTOS(vst$vst_mappingandtagging, 'vst_mappingandtagging', token=Sys.getenv('NEON_TOKEN'))
vst.shrub <- getLocTOS(vst$vst_shrubgroup, 'vst_shrubgroup', token=Sys.getenv('NEON_TOKEN'))
vst.nw <- getLocTOS(vst$`vst_non-woody`, 'vst_non-woody', token=Sys.getenv('NEON_TOKEN'))
vst.ind <- getLocTOS(vst$vst_apparentindividual, 'vst_apparentindividual', token=Sys.getenv('NEON_TOKEN'))

# testing location histories
vst <- loadByProduct(dpID='DP1.10098.001', site='DSNY', 
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


site <- 'SYCA'
token <- Sys.getenv('NEON_TOKEN')
source("~/GitHub/NEON-geolocation/geoNEON/R/getAPI.R")
source("~/GitHub/NEON-geolocation/geoNEON/R/getLocValues.R")
source("~/GitHub/NEON-geolocation/geoNEON/R/getLocProperties.R")
source("~/GitHub/NEON-geolocation/geoNEON/R/findDateMatch.R")


###### HISTORY (TOS)

# TOS locations with histories
pts <- read.csv('/Users/clunch/Downloads/All_NEON_TOS_Plots_V11/TOS_versionedPoints.csv')
sbplts <- read.csv('/Users/clunch/Downloads/All_NEON_TOS_Plots_V11/TOS_versionedSubplots.csv')


# subplots with history
cfc <- loadByProduct('DP1.10026.001', site='DSNY', check.size=F, token=Sys.getenv('NEON_TOKEN'))
cfc.nm <- getLocByName(cfc$cfc_fieldData, history=T, locOnly=F, token=Sys.getenv('NEON_TOKEN'))
cfc.loc <- getLocTOS(cfc$cfc_fieldData, dataProd='cfc_fieldData', token=Sys.getenv('NEON_TOKEN'))

cfc <- loadByProduct('DP1.10026.001', site='DSNY', check.size=F, token=Sys.getenv('NEON_TOKEN'))
cfc.loc <- getLocTOS(cfc$cfc_fieldData, dataProd='cfc_fieldData', token=Sys.getenv('NEON_TOKEN'))

ltr <- loadByProduct('DP1.10033.001', site='OSBS', check.size=F, token=Sys.getenv('NEON_TOKEN'))

ltr <- loadByProduct('DP1.10033.001', site=c('DSNY', 'GRSM'), 
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))
ltr.loc <- getLocTOS(ltr$ltr_pertrap, dataProd='ltr_pertrap', token=Sys.getenv('NEON_TOKEN'))

herb <- loadByProduct('DP1.10023.001', site='OSBS', check.size=F, token=Sys.getenv('NEON_TOKEN'))
herb.loc <- getLocTOS(herb$hbp_perbout, dataProd='hbp_perbout', token=Sys.getenv('NEON_TOKEN'))
View(herb.loc[which(herb.loc$plotID=='OSBS_020'),])
# it's on the list (TOS plots V11) but doesn't have a history in the database

root <- loadByProduct('DP1.10067.001', site='JERC', check.size=F, token=Sys.getenv('NEON_TOKEN'))
root.loc <- getLocTOS(root$bbc_percore, dataProd='bbc_percore', token=Sys.getenv('NEON_TOKEN'))

# next steps:
# create a mock json with a history for testing
# include option to exclude history in getLocTOS()

intersect(cfc$cfc_fieldData$plotID, intersect(ltr$ltr_pertrap$plotID, 
                                              intersect(herb$hbp_perbout$plotID, 
                                                        root$bbc_percore$plotID)))
# [1] "OSBS_027" "OSBS_026" "OSBS_031" "OSBS_028"

# points with history
bird <- loadByProduct('DP1.10003.001', site='SCBI', 
                      check.size=F, token=Sys.getenv('NEON_TOKEN'))
bird.loc <- getLocTOS(bird$brd_perpoint, 'brd_perpoint', token=Sys.getenv('NEON_TOKEN'))

mampt <- pts[grep('mam',pts$applicableModules),]
mam <- loadByProduct('DP1.10072.001', site='HEAL', check.size=F, token=Sys.getenv('NEON_TOKEN'))
unique(mam$mam_perplotnight$plotID[which(mam$mam_perplotnight$plotID %in% mampt$plotID)])
mam.loc <- getLocTOS(mam$mam_pertrapnight, 'mam_pertrapnight', token=Sys.getenv('NEON_TOKEN'))
mam32 <- mam.loc[which(mam.loc$plotID=='HEAL_032'),]
mam32[which(mam32$collectDate==as.POSIXct("2015-08-18", format='%Y-%m-%d', tz='GMT') & 
                        mam32$trapCoordinate=='B7'),]
mam32[which(mam32$collectDate==as.POSIXct("2023-08-18", format='%Y-%m-%d', tz='GMT') & 
                        mam32$trapCoordinate=='B7'),]

mam <- loadByProduct('DP1.10072.001', site='BART', startdate='2021-01', 
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))
mam.loc <- getLocTOS(mam$mam_pertrapnight, 'mam_pertrapnight', token=Sys.getenv('NEON_TOKEN'))
mam01 <- mam.loc[which(mam.loc$plotID=='BART_001'),]
