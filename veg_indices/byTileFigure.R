library(neonUtilities)
options(stringsAsFactors = F)

veg <- loadByProduct(dpID="DP1.10098.001", site="SCBI")
vegmap <- geoNEON::def.calc.geo.os(veg$vst_mappingandtagging, "vst_mappingandtagging")
byTileAOP(dpID="DP3.30026.001", site="SCBI", year="2017", 
          easting=vegmap$adjEasting, northing=vegmap$adjNorthing, 
          savepath="/Users/clunch/Desktop")

files <- list.files("/Users/clunch/Desktop/DP3.30026.001/2017/FullSite/D02/2017_SCBI_2/L3/Spectrometer/VegIndices/NDVI/")

tileList <- list()
for(i in 1:length(files)) {
  tileList[[i]] <- raster::raster(paste0("/Users/clunch/Desktop/DP3.30026.001/2017/FullSite/D02/2017_SCBI_2/L3/Spectrometer/VegIndices/NDVI/", 
                                 files[i]))
}
SJERimg <- do.call(raster::merge, tileList)
raster::plot(SJERimg)

symbols(vegmap$adjEasting, vegmap$adjNorthing, 
        circles=vegmap$adjCoordinateUncertainty,
        fg="white", add=T, inches=F)

symbols(vegmap$adjEasting, vegmap$adjNorthing, 
        circles=rep(20, length(vegmap$adjEasting)),
        fg="black", add=T, inches=F)


