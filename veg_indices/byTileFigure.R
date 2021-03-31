library(neonUtilities)
options(stringsAsFactors = F)

byFileAOP(dpID="DP3.30026.001", site="SCBI", year="2017", 
          savepath="/Users/clunch/Desktop", token=Sys.getenv('NEON_TOKEN'))
files <- list.files("/Users/clunch/Desktop/DP3.30026.001/2017/FullSite/D02/2017_SCBI_2/L3/Spectrometer/VegIndices/", full.names = T)
for(i in 1:length(files)) {
  unzip(files[i])
}
files <- list.files("/Users/clunch/Desktop/DP3.30026.001/2017/FullSite/D02/2017_SCBI_2/L3/Spectrometer/VegIndices/", pattern='NDVI.tif', full.names = T)
tileList <- list()
for(i in 1:length(files)) {
  tileList[[i]] <- raster::raster(files[i])
}
SCBIimg <- do.call(raster::merge, tileList)
raster::plot(SCBIimg)

veg <- loadByProduct(dpID="DP1.10098.001", site="SCBI")
vegmap <- geoNEON::def.calc.geo.os(veg$vst_mappingandtagging, "vst_mappingandtagging")

symbols(vegmap$adjEasting, vegmap$adjNorthing, 
        circles=rep(20, length(vegmap$adjEasting)),
        fg="black", add=T, inches=F)

byTileAOP(dpID="DP3.30026.001", site="SCBI", year="2017", 
          easting=vegmap$adjEasting, northing=vegmap$adjNorthing, 
          savepath="/Users/clunch/Desktop/SCBI_Tiles/")

files <- list.files("/Users/clunch/Desktop/SCBI_Tiles/DP3.30026.001/2017/FullSite/D02/2017_SCBI_2/L3/Spectrometer/VegIndices/", pattern="NDVI.tif", full.names = T, recursive = T)

tileList <- list()
for(i in 1:length(files)) {
  tileList[[i]] <- raster::raster(files[i])
}
SCBIimg <- do.call(raster::merge, tileList)
raster::plot(SCBIimg)

symbols(vegmap$adjEasting, vegmap$adjNorthing, 
        circles=vegmap$adjCoordinateUncertainty,
        fg="white", add=T, inches=F)

symbols(vegmap$adjEasting, vegmap$adjNorthing, 
        circles=rep(20, length(vegmap$adjEasting)),
        fg="black", add=T, inches=F)


