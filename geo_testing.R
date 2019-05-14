options(stringsAsFactors = F)

bet <- read.delim("/Users/clunch/Desktop/bet_all_records.csv", sep=",")

#devtools::install_github("NEONScience/NEON-geolocation/geoNEON")
library(geoNEON)

bet.loc <- def.extr.geo.os(bet)

all(bet$namedLocation==bet$namedLocation.fielddata, na.rm=T)


cfc <- read.delim("/Users/clunch/Desktop/filesToStack10026/stackedFiles/cfc_fieldData.csv", sep=",")
cfc.loc <- def.extr.geo.os(cfc)
