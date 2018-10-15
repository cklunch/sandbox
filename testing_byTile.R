veg <- read.delim("/Users/clunch/Desktop/filesToStack10098/stackedFiles/vst_mappingandtagging.csv", sep=",")
veg.loc <- def.calc.geo.os(veg, "vst_mappingandtagging")
# veg.tiles <- cbind(veg.loc$adjEasting, veg.loc$adjNorthing)
# colnames(veg.tiles) <- c("easting", "northing")
# veg.tiles <- data.frame(veg.tiles)
# veg.tiles <- veg.tiles[which(!is.na(veg.tiles$easting)),]
# veg.tiles <- unique(veg.tiles)
east <- veg.loc$adjEasting
north <- veg.loc$adjNorthing

byTileAOP(dpID="DP3.30026.001", site="SJER", year="2017", 
          easting=east, northing=north, savepath="/Users/clunch/Desktop")
