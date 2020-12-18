library(neonUtilities)
library(dplyr)
library(ggplot2)
options(stringsAsFactors = F)

# the goal of this tutorial set is to align phenology data from 
# human observations to automated sensor measurements of temperature

phe <- loadByProduct(dpID = "DP1.10055.001", site=c("BLAN","SCBI","SERC"), 
                     startdate = "2017-01", enddate="2019-12", 
                     token = Sys.getenv("NEON_TOKEN"),
                     check.size = F) 
ind <- phe$phe_perindividual
status <- phe$phe_statusintensity
str(ind)

ind_noUID <- select(ind, -(uid))
status_noUID <- select(status, -(uid))
ind_noD <- distinct(ind_noUID)
status_noD <- distinct(status_noUID)
nrow(status_noD)
intersect(names(status_noD), names(ind_noD))

status_noD <- rename(status_noD, dateStat=date, 
                     editedDateStat=editedDate, measuredByStat=measuredBy, 
                     recordedByStat=recordedBy, 
                     samplingProtocolVersionStat=samplingProtocolVersion, 
                     remarksStat=remarks, dataQFStat=dataQF, 
                     publicationDateStat=publicationDate)

ind_last <- ind_noD %>%
  group_by(individualID) %>%
  filter(editedDate==max(editedDate))

ind_lastnoD <- ind_last %>%
  group_by(editedDate, individualID) %>%
  filter(row_number()==1)

phe_ind <- left_join(status_noD, ind_lastnoD)

siteOfInterest <- "SCBI"
phe_1st <- filter(phe_ind, siteID %in% siteOfInterest)
unique(paste(phe_1st$taxonID, phe_1st$scientificName, sep=' - ')) 
speciesOfInterest <- "LITU"
phe_1sp <- filter(phe_1st, taxonID==speciesOfInterest)
phenophaseOfInterest <- "Leaves"
phe_1sp <- filter(phe_1sp, phenophaseName %in% phenophaseOfInterest)
phe_1spPrimary <- filter(phe_1sp, subtypeSpecification == 'primary')




