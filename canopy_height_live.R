# compare Lidar-derived canopy height to tree height measured from the ground

install.packages('devtools')
devtools::install_github('NEONScience/NEON-geolocation/geoNEON')

library(sp)
library(raster)
library(neonUtilities)
library(geoNEON)

# download vegetation structure data
veglist <- loadByProduct(dpID='DP1.10098.001', site='WREF', package='basic')
View(veglist$vst_mappingandtagging)
View(veglist$vst_apparentindividual)

# get tree locations
vegmap <- getLocTOS(veglist$vst_mappingandtagging, 'vst_mappingandtagging')
View(vegmap)

# merge tree locations with the diameter & height measurements
veg <- merge(veglist$vst_apparentindividual, vegmap,
             by=c('individualID','namedLocation',
                  'domainID','siteID','plotID'))

# plot stems
symbols(veg$adjEasting[which(veg$plotID=='WREF_075')],
        veg$adjNorthing[which(veg$plotID=='WREF_075')],
        circles=veg$stemDiameter[which(veg$plotID=='WREF_075')]/100,
        inches=F, xlab='Easting', ylab='Northing')

# download CHM data
byTileAOP(dpID='DP3.30015.001', site='WREF', year='2017',
          easting=veg$adjEasting[which(veg$plotID=='WREF_075')],
          northing=veg$adjNorthing[which(veg$plotID=='WREF_075')],
          savepath='/Users/clunch/Desktop')
chm <- raster('/Users/clunch/Desktop/DP3.30015.001/2017/FullSite/D16/2017_WREF_1/L3/DiscreteLidar/CanopyHeightModelGtif/NEON_D16_WREF_DP3_580000_5075000_CHM.tif')
plot(chm, col=topo.colors(5))

# compare!
vegsub <- veg[which(veg$adjEasting >= extent(chm)[1] &
                      veg$adjEasting <= extent(chm)[2] &
                      veg$adjNorthing >= extent(chm)[3] &
                      veg$adjNorthing <= extent(chm)[4]),]

bufferCHM <- extract(chm, cbind(vegsub$adjEasting,
                                vegsub$adjNorthing),
                     buffer=vegsub$adjCoordinateUncertainty,
                     fun=max)

plot(bufferCHM~vegsub$height, pch=20, xlab='Height',
     ylab='Canopy height model')
lines(c(0,50), c(0,50), col='grey')


vegna <- veglist$vst_mappingandtagging[which(is.na(veglist$vst_mappingandtagging$pointID)),]
vegna.map <- getLocTOS(vegna, 'vst_mappingandtagging')

