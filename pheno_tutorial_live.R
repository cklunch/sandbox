library(neonUtilities)
library(dplyr)
library(ggplot2)

options(stringsAsFactors = F)

phe <- loadByProduct(dpID='DP1.10055.001', site=c('BLAN','SCBI','SERC'),
                     startdate='2017-01', enddate='2019-12',
                     check.size=F)
ind <- phe$phe_perindividual
status <- phe$phe_statusintensity
View(ind)
View(status)

# clean up the data
ind_noUID <- select(ind, -(uid))
status_noUID <- select(status, -(uid))

ind_noD <- distinct(ind_noUID)
status_noD <- distinct(status_noUID)

intersect(names(status_noD), names(ind_noD))

status_noD <- rename(status_noD, dateStat=date,
                     editedDateStat=editedDate,
                     measuredByStat=measuredBy,
                     recordedByStat=recordedBy,
                     samplingProtocolVersionStat=samplingProtocolVersion,
                     remarksStat=remarks,
                     dataQFStat=dataQF,
                     publicationDateStat=publicationDate)
# keep only the most recently edited record for each individual
ind_last <- ind_noD %>%
  group_by(individualID) %>%
  filter(editedDate==max(editedDate))
ind_lastnoD <- ind_last %>%
  group_by(editedDate, individualID) %>%
  filter(row_number()==1)

phe_ind <- left_join(status_noD, ind_lastnoD)

phe_1st <- filter(phe_ind, siteID %in% 'SCBI')
unique(phe_1st$taxonID)
unique(phe_1st$scientificName)
phe_1sp <- filter(phe_1st, taxonID=='LITU')
unique(phe_1sp$phenophaseName)
phe_1sp <- filter(phe_1sp, phenophaseName %in% 'Leaves')

phe_1spPrimary <- filter(phe_1sp, subtypeSpecification=='primary')

inStat <- phe_1spPrimary %>%
  group_by(dateStat, phenophaseStatus) %>%
  summarise(countYes = n_distinct(individualID))

sampSize <- phe_1spPrimary %>%
  group_by(dateStat) %>%
  summarise(numInd = n_distinct(individualID))

inStat <- full_join(sampSize, inStat, by='dateStat')
inStat_T <- filter(inStat, phenophaseStatus=='yes')
View(inStat_T)

ggplot(inStat_T, aes(dateStat, countYes)) +
  geom_bar(stat='identity', na.rm=T)

# calculate a % in leaf
inStat_T$percent <- ((inStat_T$countYes)/inStat_T$numInd.x)*100

# trim to just 2018 data
phe_1sp_2018 <- filter(inStat_T, dateStat >= "2018-01-01" & 
                         dateStat <= "2018-12-31")
View(phe_1sp_2018)


# now get temperature data for comparison
saat <- loadByProduct(dpID='DP1.00002.001', site='SCBI',
                      startdate='2018-01', enddate='2018-12',
                      timeIndex=30, check.size=F)
list2env(saat, .GlobalEnv)

ggplot(data=SAAT_30min, aes(startDateTime, tempSingleMean)) +
  geom_point()

SAAT_30minC <- filter(SAAT_30min, SAAT_30min$finalQF==0)

ggplot(data=SAAT_30minC, aes(startDateTime, tempSingleMean)) +
  geom_point()

head(SAAT_30minC$startDateTime)
SAAT_30minC$Date <- as.Date(SAAT_30minC$startDateTime)
head(SAAT_30minC$Date)

temp_day <- SAAT_30minC %>%
  group_by(Date) %>% 
  distinct(Date, .keep_all = T) %>%
  mutate(dayMax = max(tempSingleMean))

ggplot(data=temp_day, aes(Date, dayMax)) +
  geom_point()


# merge phenology and temperature data - first need to trim to matching days
temp_day_filt <- filter(temp_day, Date >= min(phe_1sp_2018$dateStat) &
                          Date <= max(phe_1sp_2018$dateStat))

tempPlot_dayMaxFiltered <- ggplot(temp_day_filt, aes(Date, dayMax)) +
  geom_point()

phenoPlot <- ggplot(phe_1sp_2018, aes(dateStat, countYes)) +
  geom_bar(stat='identity', na.rm=T)

grid.arrange(phenoPlot, tempPlot_dayMaxFiltered)
