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
unique(swc$swc_fieldData$sampleID[which(swc$swc_fieldData$replicateNumber==3)])
# yes, replicate number is included in the sampleID

# making fake duplicates:
# this one should get resolved
dup1 <- swc$swc_fieldData[53,]
dup1$uid <- 1
dup1$sampleVolumeFiltered <- NA

# this one should be unresolveable
dup2 <- swc$swc_fieldData[588,]
dup2$uid <- 2
dup2$sampleCondition <- "garbage"

swc$swc_fieldData <- rbind(swc$swc_fieldData, dup1, dup2)

swc_fd_d <- removeDups(data=swc$swc_fieldData, variables=pub, table="swc_fieldData_pub")
# 1 rows removed
# 2 unresolveable duplicates flagged
swc_fd_d[which(swc_fd_d$duplicateRecordQF!=0),]
# as expected



# domain lab table
swc_dl <- removeDups(data=swc$swc_domainLabData, variables=pub, table="swc_domainLabData_pub")
# No duplicated key values found!

pub$fieldName[which(pub$primaryKey=="Y" & pub$table=="swc_domainLabData_pub")]
# "namedLocation"  "startDate"      "domainSampleID" "sampleType"     "methodType"
pub$primaryKey[which(pub$fieldName=="startDate" & pub$table=="swc_domainLabData_pub")] <- "N"
swc_dld <- removeDups(data=swc$swc_domainLabData, variables=pub, table="swc_domainLabData_pub")
# No duplicated key values found!

pub$primaryKey[which(pub$fieldName=="namedLocation" & pub$table=="swc_domainLabData_pub")] <- "N"
swc_dld <- removeDups(data=swc$swc_domainLabData, variables=pub, table="swc_domainLabData_pub")
# No duplicated key values found!

pub$primaryKey[which(pub$fieldName=="sampleType" & pub$table=="swc_domainLabData_pub")] <- "N"
swc_dld <- removeDups(data=swc$swc_domainLabData, variables=pub, table="swc_domainLabData_pub")
# No duplicated key values found!

pub$primaryKey[which(pub$fieldName=="methodType" & pub$table=="swc_domainLabData_pub")] <- "N"
swc_dld <- removeDups(data=swc$swc_domainLabData, variables=pub, table="swc_domainLabData_pub")
# No duplicated key values found!



# external lab table
swc_el <- removeDups(data=swc$swc_externalLabData, variables=pub, table="swc_externalLabData_pub")
# Error in removeDups(data = swc$swc_externalLabData, variables = pub, table = "swc_externalLabData_pub") : 
# Field names in data do not match variables file.
names(swc$swc_externalLabData)[!names(swc$swc_externalLabData) %in% 
                                 pub$fieldName[which(pub$table=="swc_externalLabData_pub" & pub$downloadPkg!="none")]]
# "receivedBy"        "shipmentCondition" "shipmentLateQF"   
# right, these were removed as part of the sample custody modifications
swc$swc_externalLabData <- swc$swc_externalLabData[,-which(names(swc$swc_externalLabData) %in% 
                                                             c("receivedBy","shipmentCondition","shipmentLateQF"))]
swc_el <- removeDups(data=swc$swc_externalLabData, variables=pub, table="swc_externalLabData_pub")
# 1 rows removed
# 2 unresolveable duplicates flagged
swc_el[which(swc_el$duplicateRecordQF!=0),]
# unresolveable differs in a few analyte values. resolveable differed in having NAs

pub$fieldName[which(pub$primaryKey=="Y" & pub$table=="swc_externalLabData_pub")]
# "namedLocation" "sampleID"      "startDate"
pub$primaryKey[which(pub$fieldName=="startDate" & pub$table=="swc_externalLabData_pub")] <- "N"
swc_el <- removeDups(data=swc$swc_externalLabData, variables=pub, table="swc_externalLabData_pub")
# same result

pub$primaryKey[which(pub$fieldName=="namedLocation" & pub$table=="swc_externalLabData_pub")] <- "N"
swc_el <- removeDups(data=swc$swc_externalLabData, variables=pub, table="swc_externalLabData_pub")
# same result



# Groundwater chem

gwc <- loadByProduct(dpID="DP1.20092.001", package="expanded")
pub <- read.delim("/Users/clunch/GitHub/biogeochemistryIPT/StreamWaterChem/defData/gwc_datapub_NEONDOC002290.txt", 
                  sep="\t")

# super parent table
gwc_fsp <- removeDups(data=gwc$gwc_fieldSuperParent, variables=pub, table="gwc_fieldSuperParent_pub")
# No duplicated key values found!

pub$fieldName[which(pub$primaryKey=="Y" & pub$table=="gwc_fieldSuperParent_pub")]
# "namedLocation"  "startDate"      "collectDate"    "parentSampleID"
pub$primaryKey[which(pub$fieldName=="startDate" & pub$table=="gwc_fieldSuperParent_pub")] <- "N"
gwc_fsp <- removeDups(data=gwc$gwc_fieldSuperParent, variables=pub, table="gwc_fieldSuperParent_pub")
# No duplicated key values found!

pub$primaryKey[which(pub$fieldName=="collectDate" & pub$table=="gwc_fieldSuperParent_pub")] <- "N"
gwc_fsp <- removeDups(data=gwc$gwc_fieldSuperParent, variables=pub, table="gwc_fieldSuperParent_pub")
# No duplicated key values found!

pub$primaryKey[which(pub$fieldName=="namedLocation" & pub$table=="gwc_fieldSuperParent_pub")] <- "N"
gwc_fsp <- removeDups(data=gwc$gwc_fieldSuperParent, variables=pub, table="gwc_fieldSuperParent_pub")
# No duplicated key values found!

unique(gwc_fsp$samplingImpractical)


# field data table
gwc_fd <- removeDups(data=gwc$gwc_fieldData, variables=pub, table="gwc_fieldData_pub")
# No duplicated key values found!

pub$fieldName[which(pub$primaryKey=="Y" & pub$table=="gwc_fieldData_pub")]
# "namedLocation"   "startDate"       "sampleID"        "replicateNumber"
pub$primaryKey[which(pub$fieldName=="startDate" & pub$table=="gwc_fieldData_pub")] <- "N"
gwc_fd <- removeDups(data=gwc$gwc_fieldData, variables=pub, table="gwc_fieldData_pub")
# No duplicated key values found!

pub$primaryKey[which(pub$fieldName=="namedLocation" & pub$table=="gwc_fieldData_pub")] <- "N"
gwc_fd <- removeDups(data=gwc$gwc_fieldData, variables=pub, table="gwc_fieldData_pub")
# No duplicated key values found!

pub$primaryKey[which(pub$fieldName=="replicateNumber" & pub$table=="gwc_fieldData_pub")] <- "N"
gwc_fd <- removeDups(data=gwc$gwc_fieldData, variables=pub, table="gwc_fieldData_pub")
# No duplicated key values found!



# domain lab table
gwc_dl <- removeDups(data=gwc$gwc_domainLabData, variables=pub, table="gwc_domainLabData_pub")
# No duplicated key values found!

pub$fieldName[which(pub$primaryKey=="Y" & pub$table=="gwc_domainLabData_pub")]
# "namedLocation"  "startDate"      "domainSampleID" "sampleType"     "methodType"
pub$primaryKey[which(pub$fieldName=="startDate" & pub$table=="gwc_domainLabData_pub")] <- "N"
gwc_dl <- removeDups(data=gwc$gwc_domainLabData, variables=pub, table="gwc_domainLabData_pub")
# No duplicated key values found!

pub$primaryKey[which(pub$fieldName=="namedLocation" & pub$table=="gwc_domainLabData_pub")] <- "N"
gwc_dl <- removeDups(data=gwc$gwc_domainLabData, variables=pub, table="gwc_domainLabData_pub")
# No duplicated key values found!

pub$primaryKey[which(pub$fieldName=="sampleType" & pub$table=="gwc_domainLabData_pub")] <- "N"
gwc_dl <- removeDups(data=gwc$gwc_domainLabData, variables=pub, table="gwc_domainLabData_pub")
# No duplicated key values found!

pub$primaryKey[which(pub$fieldName=="methodType" & pub$table=="gwc_domainLabData_pub")] <- "N"
gwc_dl <- removeDups(data=gwc$gwc_domainLabData, variables=pub, table="gwc_domainLabData_pub")
# No duplicated key values found!



# external lab table
gwc_el <- removeDups(data=gwc$gwc_externalLabData, variables=pub, table="gwc_externalLabData_pub")
# Error in removeDups(data = gwc$gwc_externalLabData, variables = pub, table = "gwc_externalLabData_pub") : 
# Field names in data do not match variables file.
names(gwc$gwc_externalLabData)[!names(gwc$gwc_externalLabData) %in% 
                                 pub$fieldName[which(pub$table=="gwc_externalLabData_pub" & pub$downloadPkg!="none")]]
# "receivedBy"        "shipmentCondition" "shipmentLateQF"
gwc$gwc_externalLabData <- gwc$gwc_externalLabData[,-which(names(gwc$gwc_externalLabData) %in% 
                                                             c("receivedBy","shipmentCondition","shipmentLateQF"))]
gwc_el <- removeDups(data=gwc$gwc_externalLabData, variables=pub, table="gwc_externalLabData_pub")
# No duplicated key values found!

pub$fieldName[which(pub$primaryKey=="Y" & pub$table=="gwc_externalLabData_pub")]
# "namedLocation" "sampleID"      "startDate"    
pub$primaryKey[which(pub$fieldName=="startDate" & pub$table=="gwc_externalLabData_pub")] <- "N"
gwc_el <- removeDups(data=gwc$gwc_externalLabData, variables=pub, table="gwc_externalLabData_pub")
# No duplicated key values found!

pub$primaryKey[which(pub$fieldName=="namedLocation" & pub$table=="gwc_externalLabData_pub")] <- "N"
gwc_el <- removeDups(data=gwc$gwc_externalLabData, variables=pub, table="gwc_externalLabData_pub")
# No duplicated key values found!





