library(devtools)
library(neonUtilities)
library(geoNEON)
options(stringsAsFactors = F)

zipsByProduct(dpID="DP1.10055.001", site="MOAB", savepath="/Users/clunch/Desktop")
stackByTable("/Users/clunch/Desktop/filesToStack10055", folder=T)
phe <- read.delim("/Users/clunch/Desktop/filesToStack10055/stackedFiles/phe_perindividual.csv", sep=",")
phe.loc <- def.calc.geo.os(data=phe, dataProd="phe_perindividual")
phe.raw <- def.extr.geo.os(data=phe)

symbols(phe.raw$api.easting, phe.raw$api.northing, 
        squares=rep(200,length(phe.raw$api.northing)), inches=F, xlim=c(640600,641100), 
        ylim=c(4234100,4234950), xlab="easting", ylab="northing", tck=0.01)
symbols(phe.loc$easting, phe.loc$northing, 
        circles=phe.loc$adjCoordinateUncertainty, inches=F, add=T)

write.table(phe.loc, "/Users/clunch/Desktop/phe_perindividual_MOAB_locations.csv", sep=",", row.names=F)
