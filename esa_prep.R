library(raster)
library(neonUtilities)
#library(geoNEON)
library(geoCERT)
options(stringsAsFactors = F)


#############

# NDNI
ndni <- raster("/Users/clunch/Downloads/2017 4/FullSite/D06/2017_KONZ_2/L3/Spectrometer/VegIndices/NEON_D06_KONZ_DP3_708000_4327000_NDNI.tif")
summary(ndni)
plot(ndni)
image(ndni)
nlayers(ndni)
xmin(ndni)
projection(ndni)
extent(ndni)

# canopy N
zipsByProduct(dpID="DP1.10026.001", site="KONZ", package="expanded", 
              savepath="/Users/clunch/Desktop/Nitrogen")
stackByTable("/Users/clunch/Desktop/Nitrogen/filesToStack10026/", folder=T)
fol <- read.delim("/Users/clunch/Desktop/Nitrogen/filesToStack10026/stackedFiles/cfc_carbonNitrogen.csv",
                  sep=",")
fol <- def.extr.geo.os(fol)
View(fol)


#############

# CHM
chm <- raster("/Users/clunch/Desktop/2016/FullSite/D05/2016_UNDE_1/L3/DiscreteLidar/CanopyHeightModelGtif/2016_UNDE_1_304000_5122000_pit_free_CHM.tif")
summary(chm)
plot(chm, col=topo.colors(6))
contour(chm)
projection(chm)

chm <- raster("/Users/clunch/Desktop/2017/FullSite/D05/2017_UNDE_2/L3/DiscreteLidar/CanopyHeightModelGtif/NEON_D05_UNDE_DP3_304000_5122000_CHM.tif")
summary(chm)
plot(chm, col=topo.colors(6))




# veg structure
zipsByProduct(dpID="DP1.10098.001", site="UNDE", package="expanded", 
              savepath="/Users/clunch/Desktop/struct2")
stackByTable("/Users/clunch/Desktop/struct2/filesToStack10098/", folder=T)
vegmap <- read.delim("/Users/clunch/Desktop/struct2/filesToStack10098/stackedFiles/vst_mappingandtagging.csv",
                  sep=",")
vegmap <- geoCERT::def.calc.geo.os(vegmap, "vst_mappingandtagging")
# mappingandtagging has distance & azimuth, apparentindividual has height,
# perplotperyear has plot coordinates
vegind <- read.delim("/Users/clunch/Desktop/struct/filesToStack10098/stackedFiles/vst_apparentindividual.csv",
                     sep=",")
View(vegind)
# vegp <- read.delim("/Users/clunch/Desktop/struct/filesToStack10098/stackedFiles/vst_perplotperyear.csv",
#                      sep=",")
# View(vegp)
# # vegmap <- geoCERT::def.extr.geo.os(vegmap)
# # symbols(vegmap$api.easting, vegmap$api.northing, 
# #         circles=rep(20, nrow(vegmap)), inches=F)
# 
# vegind <- geoCERT::def.extr.geo.os(vegind)
# symbols(vegind$api.easting, vegind$api.northing, 
#         circles=rep(20, nrow(vegind)), inches=F, add=T)

# need to merge individuals with mapping & tagging to get distance & azimuth,
# then make calc function
veg <- merge(vegind, vegmap, by=c("individualID","namedLocation",
                                  "domainID","siteID","plotID"))


symbols(veg$adjEasting[which(veg$plotID=="UNDE_044")], 
        veg$adjNorthing[which(veg$plotID=="UNDE_044")], 
        circles=veg$stemDiameter[which(veg$plotID=="UNDE_044")]/100, 
        inches=F)
symbols(veg$adjEasting[which(veg$plotID=="UNDE_044")], 
        veg$adjNorthing[which(veg$plotID=="UNDE_044")], 
        circles=veg$adjCoordinateUncertainty[which(veg$plotID=="UNDE_044")], 
        inches=F, add=T, fg="lightblue")


dat <- strptime(veg$date.x, format="%Y-%m-%d")
vegsub <- veg[which(dat >= strptime("2017-01-01", format="%Y-%m-%d") & 
                      veg$adjEasting >= extent(chm)[1] &
                      veg$adjEasting <= extent(chm)[2] &
                      veg$adjNorthing >= extent(chm)[3] & 
                      veg$adjNorthing <= extent(chm)[4]),]

plot(chm, col=topo.colors(6))
symbols(vegsub$adjEasting, 
        vegsub$adjNorthing, 
        circles=vegsub$stemDiameter/100, 
        inches=F, add=T)

simpleCHM <- extract(chm, cbind(vegsub$adjEasting, vegsub$adjNorthing))
plot(simpleCHM~vegsub$height, pch=20)

bilCHM <- extract(chm, cbind(vegsub$adjEasting, vegsub$adjNorthing), 
                    method="bilinear")
plot(bilCHM~vegsub$height, pch=20)

bufferCHMlist <- extract(chm, cbind(vegsub$adjEasting, vegsub$adjNorthing),
                     buffer=vegsub$adjCoordinateUncertainty)
bufferCHM <- unlist(lapply(bufferCHMlist, base::max))
plot(bufferCHM~vegsub$height, pch=20)
lines(c(0,25), c(0,25), col="grey")

# put trees in 1x1m boxes
m.easting <- floor(vegsub$adjEasting)
m.northing <- floor(vegsub$adjNorthing)
vegsub <- cbind(vegsub, m.easting, m.northing)
vegbin <- stats::aggregate(vegsub, by=list(vegsub$m.easting, vegsub$m.northing), FUN=max)
binCHMlist <- extract(chm, cbind(vegbin$m.easting, vegbin$m.northing),
                         buffer=vegbin$adjCoordinateUncertainty)
binCHM <- unlist(lapply(binCHMlist, base::max))
plot(binCHM~vegbin$height, pch=20)
lines(c(0,25), c(0,25), col="grey")


##
resid <- bufferCHM - vegsub$height
symbols(vegsub$adjEasting[which(vegsub$plotID=="UNDE_044")], 
        vegsub$adjNorthing[which(vegsub$plotID=="UNDE_044")], 
        circles=abs(resid[which(vegsub$plotID=="UNDE_044")])/10, 
        inches=F, add=T, fg="lightblue")


## better to use SJER?
zipsByProduct(dpID="DP1.10098.001", site="SJER", package="expanded", 
              savepath="/Users/clunch/Desktop/structSJER")
stackByTable("/Users/clunch/Desktop/structSJER/filesToStack10098", folder=T)
vegmap <- read.delim("/Users/clunch/Desktop/structSJER/filesToStack10098/stackedFiles/vst_mappingandtagging.csv",
                     sep=",")
vegmap <- geoCERT::def.calc.geo.os(vegmap, "vst_mappingandtagging")
vegind <- read.delim("/Users/clunch/Desktop/structSJER/filesToStack10098/stackedFiles/vst_apparentindividual.csv",
                     sep=",")
veg <- merge(vegind, vegmap, by=c("individualID","namedLocation",
                                  "domainID","siteID","plotID"))
dat <- strptime(veg$date.x, format="%Y-%m-%d")
symbols(veg$adjEasting, 
        veg$adjNorthing, 
        circles=veg$stemDiameter/100, 
        inches=F, xlim=c(256000,257000), ylim=c(4110000,4111000))


chm <- raster("/Users/clunch/Desktop/2017 SJER/FullSite/D17/2017_SJER_2/L3/DiscreteLidar/CanopyHeightModelGtif/2017_SJER_2_256000_4110000_pit_free_CHM.tif")
summary(chm)
plot(chm, col=topo.colors(6))

vegsub <- veg[which(dat >= strptime("2016-01-01", format="%Y-%m-%d") & 
                      veg$adjEasting >= extent(chm)[1] &
                      veg$adjEasting <= extent(chm)[2] &
                      veg$adjNorthing >= extent(chm)[3] & 
                      veg$adjNorthing <= extent(chm)[4]),]

bufferCHMlist <- extract(chm, cbind(vegsub$adjEasting, vegsub$adjNorthing),
                         buffer=vegsub$adjCoordinateUncertainty)
bufferCHM <- unlist(lapply(bufferCHMlist, base::max))
plot(bufferCHM~vegsub$height, pch=20)
lines(c(0,25), c(0,25), col="grey")

vegtree <- veg[which(veg$plotID %in% c("SJER_053", "SJER_057", "SJER_063")),]
symbols(vegtree$adjEasting, 
        vegtree$adjNorthing, 
        circles=vegtree$stemDiameter/100, 
        inches=F)
treeCHMlist <- extract(chm, cbind(vegtree$adjEasting, vegtree$adjNorthing),
                         buffer=vegtree$adjCoordinateUncertainty)
treeCHM <- unlist(lapply(treeCHMlist, base::max))
plot(treeCHM~vegtree$height, pch=20)
lines(c(0,25), c(0,25), col="grey")




## candidates: STEI (weird UTM situation), GRSM (redacted spp), 
#     ABBY (small #s), WREF (no canopyPosition)
zipsByProduct(dpID="DP1.10098.001", site="BONA", package="expanded", 
              savepath="/Users/clunch/Desktop/structBONA")
stackByTable("/Users/clunch/Desktop/structBONA/filesToStack10098", folder=T)
vegmap <- read.delim("/Users/clunch/Desktop/structBONA/filesToStack10098/stackedFiles/vst_mappingandtagging.csv",
                     sep=",")
vegmap <- geoCERT::def.calc.geo.os(vegmap, "vst_mappingandtagging")
vegind <- read.delim("/Users/clunch/Desktop/structBONA/filesToStack10098/stackedFiles/vst_apparentindividual.csv",
                     sep=",")
veg <- merge(vegind, vegmap, by=c("individualID","namedLocation",
                                  "domainID","siteID","plotID"))
dat <- strptime(veg$date.x, format="%Y-%m-%d")
symbols(veg$adjEasting[which(veg$canopyPosition!="")], 
        veg$adjNorthing[which(veg$canopyPosition!="")], 
        circles=veg$stemDiameter[which(veg$canopyPosition!="")]/100, 
        inches=F, xlim=c(474000,475000), ylim=c(7225000,7226000))


chm <- raster("/Users/clunch/Desktop/2017 ONAQ/FullSite/D15/2017_ONAQ_1/L3/DiscreteLidar/CanopyHeightModelGtif/NEON_D15_ONAQ_DP3_369000_4449000_CHM.tif")
summary(chm)
plot(chm, col=topo.colors(6))

vegsub <- veg[which(dat >= strptime("2017-01-01", format="%Y-%m-%d") & 
                      veg$adjEasting >= extent(chm)[1] &
                      veg$adjEasting <= extent(chm)[2] &
                      veg$adjNorthing >= extent(chm)[3] & 
                      veg$adjNorthing <= extent(chm)[4]),]

bufferCHMlist <- extract(chm, cbind(vegsub$adjEasting, vegsub$adjNorthing),
                         buffer=vegsub$adjCoordinateUncertainty)
bufferCHM <- unlist(lapply(bufferCHMlist, base::max))
plot(bufferCHM~vegsub$height, pch=20)
lines(c(0,25), c(0,25), col="grey")


