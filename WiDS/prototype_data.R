# prototypes for WiDS

library(neonUtilities)

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


