library(raster)
library(neonUtilities)
library(geoNEON)
library(sp)
library(rgdal)

# NDNI
ndni <- raster("/Users/clunch/Downloads/2017 4/FullSite/D06/2017_KONZ_2/L3/Spectrometer/VegIndices/NEON_D06_KONZ_DP3_708000_4327000_NDNI.tif")
summary(ndni)
plot(ndni)
image(ndni)
nlayers(ndni)
xmin(ndni)
projection(ndni)
extent(ndni)


# CHM
chm <- raster("/Users/clunch/Desktop/2017 UNDE/FullSite/D05/2017_UNDE_2/L3/DiscreteLidar/CanopyHeightModelGtif/NEON_D05_UNDE_DP3_309000_5120000_CHM.tif")
summary(chm)
plot(chm, col=topo.colors(6))
contour(chm)
projection(chm)



# canopy N
zipsByProduct(dpID="DP1.10026.001", site="KONZ", package="expanded", 
              savepath="/Users/clunch/Desktop/Nitrogen")
stackByTable("/Users/clunch/Desktop/Nitrogen/filesToStack10026/", folder=T)
fol <- read.delim("/Users/clunch/Desktop/Nitrogen/filesToStack10026/stackedFiles/cfc_carbonNitrogen.csv",
                  sep=",")
fol <- def.extr.geo.os(fol)
View(fol)


# veg structure
zipsByProduct(dpID="DP1.10098.001", site="UNDE", package="expanded", 
              savepath="/Users/clunch/Desktop/struct")
stackByTable("/Users/clunch/Desktop/struct/filesToStack10098/", folder=T)
veg <- read.delim("/Users/clunch/Desktop/struct/filesToStack10098/stackedFiles/vst_mappingandtagging.csv",
                  sep=",")
View(veg)
# mappingandtagging has distance & azimuth, apparentindividual has height


