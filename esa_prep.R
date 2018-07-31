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
zipsByProduct(dpID="DP1.10098.001", site="WREF", package="expanded", 
              savepath="/Users/clunch/Desktop/structWREF")
stackByTable("/Users/clunch/Desktop/structWREF/filesToStack10098", folder=T)
vegmap <- read.delim("/Users/clunch/Desktop/structWREF/filesToStack10098/stackedFiles/vst_mappingandtagging.csv",
                     sep=",")
vegmap <- geoCERT::def.calc.geo.os(vegmap, "vst_mappingandtagging")
vegind <- read.delim("/Users/clunch/Desktop/structWREF/filesToStack10098/stackedFiles/vst_apparentindividual.csv",
                     sep=",")
veg <- merge(vegind, vegmap, by=c("individualID","namedLocation",
                                  "domainID","siteID","plotID"))
dat <- strptime(veg$date.x, format="%Y-%m-%d")
symbols(veg$adjEasting[which(veg$height > 10)], 
        veg$adjNorthing[which(veg$height > 10)], 
        circles=veg$stemDiameter[which(veg$height > 10)], 
        #inches=F, xlim=c(550000,552000), ylim=c(5068000,5070000))
        inches=F)

symbols(veg$adjEasting, 
        veg$adjNorthing, 
        circles=veg$stemDiameter/100, 
        inches=F)
grid()

chm <- raster("/Users/clunch/Desktop/2017 WREF/FullSite/D16/2017_WREF_1/L3/DiscreteLidar/CanopyHeightModelGtif/NEON_D16_WREF_DP3_580000_5075000_CHM.tif")
summary(chm)
plot(chm, col=topo.colors(6))
symbols(veg$adjEasting, veg$adjNorthing,
        circles=rep(20, nrow(veg)), inches=F, add=T)

vegsub <- veg[which(veg$adjEasting >= extent(chm)[1] &
                      veg$adjEasting <= extent(chm)[2] &
                      veg$adjNorthing >= extent(chm)[3] & 
                      veg$adjNorthing <= extent(chm)[4]),]

bufferCHMlist <- extract(chm, cbind(vegsub$adjEasting, vegsub$adjNorthing),
                         buffer=vegsub$adjCoordinateUncertainty)
bufferCHM <- unlist(lapply(bufferCHMlist, base::max))
plot(bufferCHM~vegsub$height, pch=20)
lines(c(0,50), c(0,50), col="grey")

cor(x=bufferCHM, y=vegsub$height, use="pairwise.complete.obs")

# put trees in 1x1m boxes
m.easting <- floor(vegsub$adjEasting)
m.northing <- floor(vegsub$adjNorthing)
vegsub <- cbind(vegsub, m.easting, m.northing)
vegbin <- stats::aggregate(vegsub, by=list(vegsub$m.easting, vegsub$m.northing), FUN=max)
binCHMlist <- extract(chm, cbind(vegbin$m.easting, vegbin$m.northing),
                      buffer=vegbin$adjCoordinateUncertainty)
binCHM <- unlist(lapply(binCHMlist, base::max))
plot(binCHM~vegbin$height, pch=20)
lines(c(0,50), c(0,50), col="grey")

cor(x=binCHM, y=vegbin$height, use="pairwise.complete.obs")

symbols(vegsub$adjEasting[which(vegsub$plotID=="WREF_085")], 
        vegsub$adjNorthing[which(vegsub$plotID=="WREF_085")], 
        circles=vegsub$stemDiameter[which(vegsub$plotID=="WREF_085")]/100, 
        inches=F)

# 10-meter boxes
easting10 <- round(vegsub$adjEasting, digits=-1)
northing10 <- round(vegsub$adjNorthing, digits=-1)
vegsub <- cbind(vegsub, easting10, northing10)
vegbin <- stats::aggregate(vegsub, by=list(vegsub$easting10, vegsub$northing10), FUN=max)
binCHM <- extract(chm, cbind(vegbin$easting10, vegbin$northing10), buffer=7, fun=max)
plot(binCHM~vegbin$height, pch=20)
lines(c(0,50), c(0,50), col="grey")

cor(x=binCHM, y=vegbin$height, use="pairwise.complete.obs")

# lots of broken trees - only live?
vegtree <- vegsub[which(vegsub$plantStatus=="Live"),]
treeCHMlist <- extract(chm, cbind(vegtree$adjEasting, vegtree$adjNorthing),
                       buffer=vegtree$adjCoordinateUncertainty)
treeCHM <- unlist(lapply(treeCHMlist, base::max))
plot(treeCHM~vegtree$height, pch=20)
lines(c(0,50), c(0,50), col="grey")

cor(x=treeCHM, y=vegtree$height, use="pairwise.complete.obs")




# DEJU
zipsByProduct(dpID="DP1.10098.001", site="DEJU", package="expanded", 
              savepath="/Users/clunch/Desktop/structDEJU")
stackByTable("/Users/clunch/Desktop/structDEJU/filesToStack10098", folder=T)
vegmap <- read.delim("/Users/clunch/Desktop/structDEJU/filesToStack10098/stackedFiles/vst_mappingandtagging.csv",
                     sep=",")
vegmap <- geoCERT::def.calc.geo.os(vegmap, "vst_mappingandtagging")
vegind <- read.delim("/Users/clunch/Desktop/structDEJU/filesToStack10098/stackedFiles/vst_apparentindividual.csv",
                     sep=",")
veg <- merge(vegind, vegmap, by=c("individualID","namedLocation",
                                  "domainID","siteID","plotID"))

vegcan <- veg[which(veg$plotID %in% c("DEJU_010","DEJU_003","DEJU_023",
                                      "DEJU_004","DEJU_008","DEJU_005",
                                      "DEJU_019","DEJU_001","DEJU_007",
                                      "DEJU_015","DEJU_017","DEJU_006",
                                      "DEJU_014","DEJU_021","DEJU_002",
                                      "DEJU_024","DEJU_016","DEJU_009",
                                      "DEJU_018","DEJU_020") & 
                      veg$growthForm %in% c("single bole tree", "multi-bole tree")),]

symbols(vegcan$adjEasting, 
        vegcan$adjNorthing, 
        circles=vegcan$stemDiameter/100, 
        #inches=F)
        inches=F, xlim=c(561000,562000), ylim=c(7079000,7080000))
grid()

chm <- raster("/Users/clunch/Desktop/2017 DEJU/FullSite/D19/2017_DEJU_1/L3/DiscreteLidar/CanopyHeightModelGtif/NEON_D19_DEJU_DP3_561000_7079000_CHM.tif")
summary(chm)
plot(chm, col=topo.colors(6))

dat <- strptime(veg$date.x, format="%Y-%m-%d")
vegsub <- veg[which(veg$adjEasting >= extent(chm)[1] &
                      veg$adjEasting <= extent(chm)[2] &
                      veg$adjNorthing >= extent(chm)[3] & 
                      veg$adjNorthing <= extent(chm)[4]),]


bufferCHMlist <- extract(chm, cbind(vegsub$adjEasting, vegsub$adjNorthing),
                         buffer=vegsub$adjCoordinateUncertainty)
bufferCHM <- unlist(lapply(bufferCHMlist, base::max))
plot(bufferCHM~vegsub$height, pch=20)
lines(c(0,50), c(0,50), col="grey")



# ABBY
zipsByProduct(dpID="DP1.10098.001", site="ABBY", package="expanded", 
              savepath="/Users/clunch/Desktop/structABBY")
stackByTable("/Users/clunch/Desktop/structABBY/filesToStack10098", folder=T)
vegmap <- read.delim("/Users/clunch/Desktop/structABBY/filesToStack10098/stackedFiles/vst_mappingandtagging.csv",
                     sep=",")
vegmap <- geoCERT::def.calc.geo.os(vegmap, "vst_mappingandtagging")
vegind <- read.delim("/Users/clunch/Desktop/structABBY/filesToStack10098/stackedFiles/vst_apparentindividual.csv",
                     sep=",")
veg <- merge(vegind, vegmap, by=c("individualID","namedLocation",
                                  "domainID","siteID","plotID"))

symbols(veg$adjEasting, 
        veg$adjNorthing, 
        circles=veg$stemDiameter/100, 
        inches=F)
grid()

vegcan <- veg[which(veg$plotID %in% c("ABBY_007","ABBY_004","ABBY_009",
                                      "ABBY_011","ABBY_023","ABBY_013",
                                      "ABBY_010","ABBY_003","ABBY_018",
                                      "ABBY_005","ABBY_012","ABBY_008",
                                      "ABBY_016","ABBY_017","ABBY_014",
                                      "ABBY_019","ABBY_001","ABBY_006",
                                      "ABBY_002","ABBY_025") & 
                      veg$growthForm %in% c("single bole tree", "multi-bole tree")),]

symbols(vegcan$adjEasting, 
        vegcan$adjNorthing, 
        circles=vegcan$stemDiameter/100, 
        inches=F)
        #inches=F, xlim=c(561000,562000), ylim=c(7079000,7080000))
grid()

chm <- raster("/Users/clunch/Desktop/2017 ABBY/FullSite/D16/2017_ABBY_1/L3/DiscreteLidar/CanopyHeightModelGtif/NEON_D16_ABBY_DP3_548000_5067000_CHM.tif")
summary(chm)
plot(chm, col=topo.colors(6))
symbols(veg$adjEasting, veg$adjNorthing,
        circles=rep(20, nrow(veg)), inches=F, add=T)




# GRSM
zipsByProduct(dpID="DP1.10098.001", site="GRSM", package="expanded", 
              savepath="/Users/clunch/Desktop/structGRSM")
stackByTable("/Users/clunch/Desktop/structGRSM/filesToStack10098", folder=T)
vegmap <- read.delim("/Users/clunch/Desktop/structGRSM/filesToStack10098/stackedFiles/vst_mappingandtagging.csv",
                     sep=",")
vegmap <- geoCERT::def.calc.geo.os(vegmap, "vst_mappingandtagging")
vegind <- read.delim("/Users/clunch/Desktop/structGRSM/filesToStack10098/stackedFiles/vst_apparentindividual.csv",
                     sep=",")
veg <- merge(vegind, vegmap, by=c("individualID","namedLocation",
                                  "domainID","siteID","plotID"))

symbols(veg$adjEasting, 
        veg$adjNorthing, 
        circles=veg$stemDiameter/100, 
        inches=F)
grid()

vegcan <- veg[which(veg$plotID %in% c("GRSM_007","GRSM_004","GRSM_009",
                                      "GRSM_011","GRSM_015","GRSM_013",
                                      "GRSM_010","GRSM_003","GRSM_018",
                                      "GRSM_005","GRSM_012","GRSM_008",
                                      "GRSM_016","GRSM_017","GRSM_014",
                                      "GRSM_019","GRSM_001","GRSM_006",
                                      "GRSM_002","GRSM_025") & 
                      veg$growthForm %in% c("single bole tree", "multi-bole tree")),]

symbols(vegcan$adjEasting, 
        vegcan$adjNorthing, 
        circles=vegcan$stemDiameter/100, 
        #inches=F)
        inches=F, xlim=c(260000,261000), ylim=c(3951000,3952000))

symbols(vegcan$adjEasting, 
        vegcan$adjNorthing, 
        circles=vegcan$stemDiameter/100, 
        #inches=F)
        inches=F, xlim=c(271000,272000), ylim=c(3950000,3951000))

chm <- raster("/Users/clunch/Desktop/2016 GRSM/FullSite/D07/2016_GRSM_2/L3/DiscreteLidar/CanopyHeightModelGtif/2016_GRSM_2_260000_3951000_pit_free_CHM.tif")
summary(chm)
plot(chm, col=topo.colors(6))
symbols(veg$adjEasting, veg$adjNorthing,
        circles=rep(20, nrow(veg)), inches=F, add=T)

vegsub <- veg[which(veg$adjEasting >= extent(chm)[1] &
                      veg$adjEasting <= extent(chm)[2] &
                      veg$adjNorthing >= extent(chm)[3] & 
                      veg$adjNorthing <= extent(chm)[4]),]

bufferCHMlist <- extract(chm, cbind(vegsub$adjEasting, vegsub$adjNorthing),
                         buffer=vegsub$adjCoordinateUncertainty)
bufferCHM <- unlist(lapply(bufferCHMlist, base::max))
plot(bufferCHM~vegsub$height, pch=20)
lines(c(0,50), c(0,50), col="grey")

vegtree <- vegsub[which(vegsub$canopyPosition %in% c("Full sun","Open grown")),]
treeCHMlist <- extract(chm, cbind(vegtree$adjEasting, vegtree$adjNorthing),
                       buffer=vegtree$adjCoordinateUncertainty)
treeCHM <- unlist(lapply(treeCHMlist, base::max))
plot(treeCHM~vegtree$height, pch=20)
lines(c(0,25), c(0,25), col="grey")


# get all veg structure data
zipsByProduct(dpID="DP1.10098.001", site="all", package="basic", 
              savepath="/Users/clunch/Desktop")
stackByTable("/Users/clunch/Desktop/filesToStack10098", folder=T)
vegmap <- read.delim("/Users/clunch/Desktop/filesToStack10098/stackedFiles/vst_mappingandtagging.csv",
                     sep=",")
vegmap <- geoCERT::def.calc.geo.os(vegmap, "vst_mappingandtagging")
write.table(vegmap, 
            "/Users/clunch/Desktop/filesToStack10098/stackedFiles/vst_mappingandtagging_geo.csv",
            sep=",", row.names=F)



