options(stringsAsFactors = F)
dhp.plot <- read.delim("/Users/clunch/Desktop/dhp_leaf_area_index_prod/dhp_leaf_area_index_prod.csv", sep=",")
dhp.img <- read.delim("/Users/clunch/Desktop/dhp_leaf_area_index_prod/dhp_leaf_area_index_prod_dhp_per_image.csv", sep=",")

min(dhp.plot$created_at)
dhp.plot[which(dhp.plot$created_at<="2016-05-24 23:59:59 UTC"),]

min(dhp.img$created_at)
nrow(dhp.img[which(dhp.img$created_at<="2016-05-24 23:59:59 UTC"),])

dust <- read.delim("/Users/clunch/Desktop/tis_dust_particulate_mass_collect/tis_dust_particulate_mass_collect.csv", sep=",")
min(dust$created_at)
dust[which(dust$created_at<="2017-10-04 23:59:59 UTC"),]
dust[which(dust$created_at<="2017-10-05 23:59:59 UTC"),]

#######

div <- read.delim("/Users/clunch/GitHub/organismalIPT/scienceDev/FulcrumPDR_DBComparisons/DP0.10004.001_outputDF.csv", sep=",")
div <- div[which(div$ingest=="div_1m2Data_in" | div$ingest=="div_10m2Data100m2Data_in"),]
div.noF <- div[grep("No Fulcrum record",div$parentID),]
nrow(div.noF[which(div.noF$ingest=="div_1m2Data_in"),])
nrow(div.noF[which(div.noF$ingest=="div_10m2Data100m2Data_in"),])

levels(as.factor(div$fieldWithDifferentData))

diff.fields.1m <- strsplit(div$fieldWithDifferentData[which(div$ingest=="div_1m2Data_in")], split="; ", fixed=T)
diff.fields.1m <- unlist(diff.fields.1m)
table(diff.fields.1m)

diff.fields.100m <- strsplit(div$fieldWithDifferentData[which(div$ingest=="div_10m2Data100m2Data_in")], split="; ", fixed=T)
diff.fields.100m <- unlist(diff.fields.100m)
table(diff.fields.100m)

#####

library(neonUtilities)
devtools::install_github('NEONScience/NEON-geolocation/geoNEON')
library(geoNEON)

phe <- loadByProduct(dpID="DP1.10055.001", site="NOGP")
phe.loc <- def.calc.geo.os(phe$phe_perindividual, "phe_perindividual")
setdiff(names(phe$phe_perindividual), names(phe.loc))
setdiff(names(phe.loc), names(phe$phe_perindividual))
symbols(phe.loc$easting, phe.loc$northing, circles=phe.loc$adjCoordinateUncertainty, inches=F)

ltr <- loadByProduct(dpID="DP1.10033.001", site="BART")
ltr.loc <- def.calc.geo.os(ltr$ltr_pertrap, "ltr_pertrap")
setdiff(names(ltr$ltr_pertrap), names(ltr.loc))
setdiff(names(ltr.loc), names(ltr$ltr_pertrap))
symbols(ltr.loc$easting, ltr.loc$northing, circles=ltr.loc$adjCoordinateUncertainty, inches=F)

herb <- loadByProduct(dpID="DP1.10023.001", site="STER")
herb.loc <- def.calc.geo.os(herb$hbp_perbout, "hbp_perbout")
setdiff(names(herb$hbp_perbout), names(herb.loc))
setdiff(names(herb.loc), names(herb$hbp_perbout))
symbols(herb.loc$easting, herb.loc$northing, circles=herb.loc$adjCoordinateUncertainty, inches=F)

cfc <- loadByProduct(dpID="DP1.10026.001", site="STER")
cfc.loc <- def.calc.geo.os(cfc$cfc_fieldData, "cfc_fieldData")
setdiff(names(cfc$cfc_fieldData), names(cfc.loc))
setdiff(names(cfc.loc), names(cfc$cfc_fieldData))
symbols(cfc.loc$easting, cfc.loc$northing, circles=cfc.loc$adjCoordinateUncertainty, inches=F)

sls <- loadByProduct(dpID="DP1.10086.001", site="HARV")
sls.loc <- def.calc.geo.os(sls$sls_soilCoreCollection, "sls_soilCoreCollection")
setdiff(names(sls$sls_soilCoreCollection), names(sls.loc))
setdiff(names(sls.loc), names(sls$sls_soilCoreCollection))
symbols(sls.loc$easting, sls.loc$northing, circles=sls.loc$adjCoordinateUncertainty, inches=F)
# overwrites original location columns

bird <- loadByProduct(dpID="DP1.10003.001", site="ABBY")
brd.loc <- def.calc.geo.os(bird$brd_perpoint, "brd_perpoint")
setdiff(names(bird$brd_perpoint), names(brd.loc))
setdiff(names(brd.loc), names(bird$brd_perpoint))
symbols(brd.loc$api.easting, brd.loc$api.northing, circles=brd.loc$adjCoordinateUncertainty, inches=F)
# changed to just 'easting' and 'northing' to match; will break API tutorial

mam <- loadByProduct(dpID="DP1.10072.001", site="HARV")
mam.loc <- def.calc.geo.os(mam$mam_pertrapnight, "mam_pertrapnight")
setdiff(names(mam$mam_pertrapnight), names(mam.loc))
setdiff(names(mam.loc), names(mam$mam_pertrapnight))
symbols(mam.loc$adjEasting, mam.loc$adjNorthing, circles=mam.loc$adjCoordinateUncertainty, inches=F)
# changed to just 'easting' and 'northing' to match

# next up: plant div



