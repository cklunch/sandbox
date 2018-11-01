library(devtools)
install_github("NEONScience/NEON-geolocation/geoNEON")
library(geoNEON)

options(stringsAsFactors = F)

sls <- read.delim("/Users/clunch/Desktop/sls_soilCoreCollection_pub_INPUT_THAT_GIVES_WEIRD_ELEVATIONS.csv", sep=",")
sls <- def.calc.geo.os(sls, "sls_soilCoreCollection")

data <- sls
dataProd <- "sls_soilCoreCollection"
# run lines of def.calc.geo.os() by hand
unique(cbind(plot.loc$plotID, plot.loc$elevation, plot.loc$api.elevation))
unique(cbind(plot.return$namedLocation, plot.return$adjElevation))
unique(cbind(all.return$namedLocation, all.return$elevation, all.return$adjElevation))

bird <- read.delim("/Users/clunch/Desktop/filesToStack10003/stackedFiles/brd_perpoint.csv", sep=",")
bird <- def.calc.geo.os(bird, "brd_perpoint")
unique(cbind(bird$namedLocation, bird$points, bird$elevation, bird$adjElevation))

