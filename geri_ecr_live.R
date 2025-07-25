library(neonUtilities)
library(neonOS)
library(terra)
library(ggplot2)

stackByTable('/Users/clunch/Downloads/NEON_temp-air-single.zip')

saat <- loadByProduct(dpID='DP1.00002.001', site=c('ONAQ','RMNP'),
                      startdate='2024-04', enddate='2024-06')
names(saat)
View(saat$SAAT_30min)

gg <- ggplot(saat$SAAT_30min, aes(endDateTime, tempSingleMean,
                                  group=verticalPosition,
                                  color=verticalPosition)) +
  geom_line() +
  facet_wrap(~siteID)
gg


veg <- loadByProduct(dpID='DP1.10098.001', site=c('ABBY','TEAK'),
                     check.size=F, include.provisional=T)
names(veg)
list2env(veg, .GlobalEnv)

gg <- ggplot(vst_apparentindividual, aes(siteID, height)) +
  geom_boxplot()
gg

vegmerge <- joinTableNEON(vst_mappingandtagging, vst_apparentindividual)

gg <- ggplot(vegmerge, aes(taxonID, height)) +
  geom_boxplot() +
  facet_wrap(~siteID) +
  theme(axis.text.x = element_text(angle=90))
gg


vegploteast <- vst_perplotperyear$easting[which(vst_perplotperyear$plotID=='TEAK_049')]
vegplotnorth <- vst_perplotperyear$northing[which(vst_perplotperyear$plotID=='TEAK_049')]

byTileAOP(dpID='DP3.30015.001', site='TEAK', year=2024,
          include.provisional = T, 
          easting=vegploteast,
          northing=vegplotnorth,
          savepath = '/Users/clunch/Downloads')

chm <- rast('/Users/clunch/Downloads/DP3.30015.001/neon-aop-provisional-products/2024/FullSite/D17/2024_TEAK_7/L3/DiscreteLidar/CanopyHeightModelGtif/NEON_D17_TEAK_DP3_321000_4096000_CHM.tif')
plot(chm)
