library(devtools)

options(stringsAsFactors = F)

devtools::install_github("NEONScience/NEON-utilities/neonUtilities", ref="duplicates")
library(neonUtilities)


# Chem prop surface water

#swc <- stackByTable("/Users/clunch/Desktop/NEON_chem-surfacewater.zip", savepath="envt")
swc <- loadByProduct(dpID="DP1.20093.001", package="expanded")
pub <- read.delim("/Users/clunch/GitHub/biogeochemistryIPT/StreamWaterChem/defData/swc_datapub_NEONDOC002292.txt", 
                  sep="\t")

# super parent table
swc_fsp <- removeDups(data=swc$swc_fieldSuperParent, variables=pub, table="swc_fieldSuperParent_pub")
# 0 rows removed
# 2 unresolveable duplicates flagged
swc_fsp[which(swc_fsp$duplicateRecordQF!=0),]
# identical except for remarks, collectedBy, and samplingProtocolVersion. fascinating!

pub$primaryKey[which(pub$fieldName=="startDate" & pub$table=="swc_fieldSuperParent_pub")] <- "N"
swc_fsp <- removeDups(data=swc$swc_fieldSuperParent, variables=pub, table="swc_fieldSuperParent_pub")
# same result

pub$primaryKey[which(pub$fieldName=="collectDate" & pub$table=="swc_fieldSuperParent_pub")] <- "N"
swc_fsp <- removeDups(data=swc$swc_fieldSuperParent, variables=pub, table="swc_fieldSuperParent_pub")
# same result

pub$primaryKey[which(pub$fieldName=="namedLocation" & pub$table=="swc_fieldSuperParent_pub")] <- "N"
swc_fsp <- removeDups(data=swc$swc_fieldSuperParent, variables=pub, table="swc_fieldSuperParent_pub")
# same result
# reducing primary key to just parentSampleID, because they always collect a sample.

# making fake duplicates:
# this one should get resolved
dup1 <- swc$swc_fieldSuperParent[53,]
dup1$uid <- 1

# this one should get resolved too
dup2 <- swc$swc_fieldSuperParent[507,]
dup2$uid <- 2
dup2$dissolvedOxygen <- NA

# this one should be unresolveable
dup3 <- swc$swc_fieldSuperParent[589,]
dup3$uid <- 3
dup3$specificConductance <- 10

swc$swc_fieldSuperParent <- rbind(swc$swc_fieldSuperParent, dup1, dup2, dup3)

swc_fsp_d <- removeDups(data=swc$swc_fieldSuperParent, variables=pub, table="swc_fieldSuperParent_pub")
# 2 rows removed
# 4 unresolveable duplicates flagged
swc_fsp_d[which(swc_fsp_d$duplicateRecordQF!=0),]
# as expected


# field data table
swc_fd <- removeDups(data=swc$swc_fieldData, variables=pub, table="swc_fieldData_pub")
# No duplicated key values found!

pub$fieldName[which(pub$primaryKey=="Y" & pub$table=="swc_fieldData_pub")]
# "namedLocation"   "startDate"       "sampleID"        "replicateNumber"
pub$primaryKey[which(pub$fieldName=="startDate" & pub$table=="swc_fieldData_pub")] <- "N"
swc_fd <- removeDups(data=swc$swc_fieldData, variables=pub, table="swc_fieldData_pub")
# No duplicated key values found!

pub$primaryKey[which(pub$fieldName=="namedLocation" & pub$table=="swc_fieldData_pub")] <- "N"
swc_fd <- removeDups(data=swc$swc_fieldData, variables=pub, table="swc_fieldData_pub")
# No duplicated key values found!

pub$primaryKey[which(pub$fieldName=="replicateNumber" & pub$table=="swc_fieldData_pub")] <- "N"
swc_fd <- removeDups(data=swc$swc_fieldData, variables=pub, table="swc_fieldData_pub")
# No duplicated key values found!
# Do we not collect replicates? Or is the replicate number included in the sampleID?
unique(swc$swc_fieldData$replicateNumber)
# NA  1  2  3

# making fake duplicates:
# this one should get resolved
dup1 <- swc$swc_fieldData[53,]
dup1$uid <- 1
dup1$sampleVolumeFiltered <- NA

# this one should be unresolveable
dup2 <- swc$swc_fieldData[507,]
dup2$uid <- 2
dup2$sampleCondition <- "garbage"

swc$swc_fieldData <- rbind(swc$swc_fieldData, dup1, dup2)

swc_fd_d <- removeDups(data=swc$swc_fieldData, variables=pub, table="swc_fieldData_pub")
# 2 rows removed
# 0 unresolveable duplicates flagged
# whoops
swc_fd_d[which(swc_fd_d$duplicateRecordQF!=0),]
# apparently sampleCondition was blank when I started?


