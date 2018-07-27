library(raster)
library(neonUtilities)
library(geoNEON)
library(sp)
library(rgdal)
options(stringsAsFactors = F)


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
chm <- raster("/Users/clunch/Desktop/2016/FullSite/D05/2016_UNDE_1/L3/DiscreteLidar/CanopyHeightModelGtif/2016_UNDE_1_304000_5122000_pit_free_CHM.tif")
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
vegmap <- read.delim("/Users/clunch/Desktop/struct/filesToStack10098/stackedFiles/vst_mappingandtagging.csv",
                  sep=",")
View(vegmap)
# mappingandtagging has distance & azimuth, apparentindividual has height,
# perplotperyear has coordinates
vegind <- read.delim("/Users/clunch/Desktop/struct/filesToStack10098/stackedFiles/vst_apparentindividual.csv",
                     sep=",")
View(vegind)
vegp <- read.delim("/Users/clunch/Desktop/struct/filesToStack10098/stackedFiles/vst_perplotperyear.csv",
                     sep=",")
View(vegp)
# vegmap <- geoCERT::def.extr.geo.os(vegmap)
# symbols(vegmap$api.easting, vegmap$api.northing, 
#         circles=rep(20, nrow(vegmap)), inches=F)

vegind <- geoCERT::def.extr.geo.os(vegind)
symbols(vegind$api.easting, vegind$api.northing, 
        circles=rep(20, nrow(vegind)), inches=F, add=T)
# need to merge individuals with mapping & tagging to get distance & azimuth,
# then make calc function

