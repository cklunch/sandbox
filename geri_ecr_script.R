# Download & Explore, adapted for GERI ECR

# SAY:
# THIS IS AN ADAPTED VERSION OF DOWNLOAD & EXPLORE!
# THIS FUNCTIONALITY IS ALSO AVAILABLE IN PYTHON!

# go to portal, download air temperature DP1.00002.001
# ONAQ & RMNP 2024 Apr-June
# exclude & basic
# show files but don't dig in

library(neonUtilities)
library(neonOS)
library(ggplot2)
library(terra)

stackByTable('/Users/clunch/Downloads/NEON_temp-air-single.zip')

# show files but don't dig in

# here's how we get the same thing directly in R
# basic package is the default
# expanded gets you more data quality details
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

# THINGS TO NOTE:
# one more vertical position at RMNP than ONAQ
# heating near the ground at ONAQ
# to get physical locations, use sensor_positions file

View(saat$sensor_positions_00002)

# OBSERVATIONAL DATA
# VEGETATION STRUCTURE

# download data
# note check size and provisional options, and omission of dates

veg <- loadByProduct(dpID='DP1.10098.001', site=c('ABBY','TEAK'),
                     check.size=F, include.provisional=T)
names(veg)
list2env(veg, .GlobalEnv)

# height range at each site
gg <- ggplot(vst_apparentindividual, aes(siteID, height)) +
  geom_boxplot()
gg

# to get height by species, need to join
# https://data.neonscience.org/data-products/DP1.10098.001
vegmerge <- joinTableNEON(vst_mappingandtagging, vst_apparentindividual)

gg <- ggplot(vegmerge, aes(taxonID, height)) +
  geom_boxplot() +
  facet_wrap(~siteID) +
  theme(axis.text.x = element_text(angle = 90))
gg

# stretch figure to see names
# note ABBY is a managed forest, planted in Doug fir

# canopy height data from AOP
# get plot location from veg structure data
View(vst_perplotperyear)
vegploteast <- vst_perplotperyear$easting[which(vst_perplotperyear$plotID=='TEAK_049')]
vegplotnorth <- vst_perplotperyear$northing[which(vst_perplotperyear$plotID=='TEAK_049')]

byTileAOP(dpID='DP3.30015.001', site='TEAK', year=2024, 
          include.provisional=T, easting=vegploteast, northing=vegplotnorth,
          savepath='/Users/clunch/Downloads')
chm <- rast('/Users/clunch/Downloads/DP3.30015.001/neon-aop-provisional-products/2024/FullSite/D17/2024_TEAK_7/L3/DiscreteLidar/CanopyHeightModelGtif/NEON_D17_TEAK_DP3_321000_4096000_CHM.tif')
plot(chm)

# if enough time: DTM/DSM
byTileAOP(dpID='DP3.30024.001', site='TEAK', year=2024, 
          include.provisional=T, easting=vegploteast, northing=vegplotnorth,
          savepath='/Users/clunch/Downloads')
# note this downloaded 2 tiles
dtm <- rast('/Users/clunch/Downloads/DP3.30024.001/neon-aop-provisional-products/2024/FullSite/D17/2024_TEAK_7/L3/DiscreteLidar/DTMGtif/NEON_D17_TEAK_DP3_321000_4096000_DTM.tif')
plot(dtm)

dsm <- rast('/Users/clunch/Downloads/DP3.30024.001/neon-aop-provisional-products/2024/FullSite/D17/2024_TEAK_7/L3/DiscreteLidar/DSMGtif/NEON_D17_TEAK_DP3_321000_4096000_DSM.tif')
plot(dsm)

# to connect height data between CHM & veg at the exact locations of specific trees:
# https://www.neonscience.org/resources/learning-hub/tutorials/tree-heights-veg-structure-chm



