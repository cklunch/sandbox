# prototypes for WiDS

library(neonUtilities)
options(stringsAsFactors=F)

zipsByProduct("DP1.10093.001", site="TALL", package="expanded", 
                      savepath="/Users/clunch/sandbox/WiDS/")
stackByTable("/Users/clunch/sandbox/WiDS//filesToStack10093", folder=T)

zipsByProduct("DP1.10092.001", site="TALL", package="expanded", 
                      savepath="/Users/clunch/sandbox/WiDS/")
stackByTable("/Users/clunch/sandbox/WiDS//filesToStack10092", folder=T)

tickField <- read.delim("/Users/clunch/sandbox/WiDS/filesToStack10093/stackedFiles/tck_fielddata.csv",
                        sep=",")
tickTax <- read.delim("/Users/clunch/sandbox/WiDS/filesToStack10093/stackedFiles/tck_taxonomyProcessed.csv",
                      sep=",")
tickPath <- read.delim("/Users/clunch/sandbox/WiDS/filesToStack10092/stackedFiles/tck_pathogen.csv",
                       sep=",")

tickTaxSub <- tickTax[,-which(colnames(tickTax) %in% c("domainID","siteID","namedLocation",
                                                       "plotID","plotType","nlcdClass",
                                                       "decimalLatitude","decimalLongitude",
                                                       "geodeticDatum","coordinateUncertainty",
                                                       "elevation","elevationUncertainty",
                                                       "collectDate"))]
colnames(tickTaxSub)[which(colnames(tickTaxSub)=="eventID")] <- "sampleID"

tickColl <- merge(tickField, tickTaxSub, by=c("sampleID"), all=T)
tickColl <- tickColl[-which(is.na(tickColl$subsampleID)),]

tickPathSub <- tickPath[,-which(colnames(tickPath) %in% c("domainID","siteID","namedLocation",
                                                        "plotID","plotType","nlcdClass",
                                                        "decimalLatitude","decimalLongitude",
                                                        "geodeticDatum","coordinateUncertainty",
                                                        "elevation","elevationUncertainty",
                                                        "collectDate"))]

tick <- merge(tickColl, tickPathSub, by=c("subsampleID"), all=F)

write.table(tick[1:500,], file="/Users/clunch/sandbox/WiDS/tick_example.csv", 
            sep=",", row.names=F)


## other options
zipsByProduct("DP1.20033.001", site="WALK", package="basic", 
              savepath="/Users/clunch/sandbox/WiDS/")
stackByTable("/Users/clunch/sandbox/WiDS/filesToStack20033", folder=T)

nsw <- read.delim("/Users/clunch/sandbox/WiDS/filesToStack20033/stackedFiles/NSW_15_minute.csv",
                  sep=",")
# nope. ~1 million rows

#zipsByProduct("DP1.10098.001", site="WREF", package="basic", 
#              savepath="/Users/clunch/sandbox/WiDS/")

vegmap <- read.delim("/Users/clunch/Desktop/ESA 2018 Wkshp Data/NEON_struct-woody-plant/stackedFiles/vst_mappingandtagging_geo.csv",
                  sep=",")
vegind <- read.delim("/Users/clunch/Desktop/ESA 2018 Wkshp Data/NEON_struct-woody-plant/stackedFiles/vst_apparentindividual.csv",
                     sep=",")
intersect(names(veg),names(vegind))
veg <- merge(vegind, vegmap, by=c("individualID","namedLocation","domainID","siteID"))
vegWREF <- veg[which(veg$siteID=="WREF"),]

write.table(vegWREF, file="/Users/clunch/sandbox/WiDS/woody_veg_example.csv", 
            sep=",", row.names=F)

zipsByProduct("DP1.10055.001", site="ABBY", package="basic",
              savepath="/Users/clunch/Desktop/")
stackByTable("/Users/clunch/Desktop/filesToStack10055", folder=T)

pheno <- read.delim("/Users/clunch/Desktop/filesToStack10055/stackedFiles/phe_statusintensity.csv",
                    sep=",")

