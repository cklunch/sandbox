library(neonUtilities)
library(dplyr)


# Bind files into a dataset

mamds <- datasetQuery(dpID="DP1.10072.001", 
                      site="TREE", package="basic",
                      tabl="mam_pertrapnight",
                      release="RELEASE-2025",
                      token=Sys.getenv("NEON_TOKEN"))

# Database-style query of dataset

mamTREE <- mamds |> 
  filter(!is.na(taxonID)) |> 
  select(tagID, taxonID, scientificName) |>
  distinct() |>
  collect()

ct <- table(mamTREE$taxonID)

barplot(ct[order(ct, decreasing=T)], 
        horiz=T, las=1, cex.names=0.5)

# Joining data tables

# bind dataset for rodent pathogens

pthds <- datasetQuery(dpID="DP1.10064.002", 
                      site="TREE", package="basic",
                      tabl="rpt2_pathogentesting",
                      release="RELEASE-2025",
                      token=Sys.getenv("NEON_TOKEN"))

# join

mampath <- mamds |> 
  select(tagID, taxonID, scientificName, bloodSampleID) |> 
  inner_join(pthds, by=c('bloodSampleID' = 'sampleID')) |>
  filter(testResult=='Positive') |>
  distinct() |>
  collect()

table(mampath$scientificName)

# NEON sensor data

# one soil moisture sensor, all data

swds <- datasetQuery(dpID="DP1.00094.001", 
                     site="SJER", package="basic",
                     hor="004", ver="502",
                     startdate="2023-01", enddate="2023-12",
                     tabl="SWS_30_minute",
                     release="RELEASE-2025")

swSJER <- swds |>
  collect()

plot(swSJER$VSWCMean~swSJER$endDateTime, type="l")

# aggregating sensor data

swmean <- swds |> 
  filter(VSWCFinalQF==0) |>
  select(endDateTime, VSWCMean) |> 
  mutate(dat = date(endDateTime)) |>
  group_by(dat) |>
  summarize(swdaily = mean(VSWCMean, na.rm=T)) |>
  arrange(dat) |>
  collect()

plot(swmean$swdaily~swmean$dat, type="l")

# what was flagged?

swmeanf <- swds |> 
  select(endDateTime, VSWCFinalQF) |> 
  mutate(dat = date(endDateTime)) |>
  group_by(dat) |>
  summarize(flagdaily = sum(abs(VSWCFinalQF)), na.rm=F) |>
  arrange(dat) |>
  collect()

plot(swmean$swdaily~swmean$dat, type="l")
points(swmeanf$flagdaily~swmeanf$dat, pch=20, cex=0.5, col="blue")

# repeat mammal captures

tagdups <- mamTREE |>
  group_by(tagID) |>
  filter(n() > 1) |>
  ungroup() |>
  arrange(tagID)

head(tagdups, 10)

# repeat mammal individuals in pathogen data

pathdups <- mampath |>
  group_by(tagID) |>
  filter(n() > 1) |>
  ungroup() |>
  select(tagID, scientificName, 
         collectDate, testPathogenName) |>
  arrange(tagID, collectDate)

head(pathdups, 21)

# time test - query

start.time <- Sys.time()

wcds <- datasetQuery(dpID="DP1.20093.001", 
                     site="MCRA", package="basic",
                     tabl="swc_externalLabDataByAnalyte",
                     release="RELEASE-2025",
                     token=Sys.getenv("NEON_TOKEN"))

Sys.time() - start.time
start.time <- Sys.time()

tn <- wcds |>
  filter(analyte=="TN") |>
  collect()

Sys.time() - start.time

# time test - download

start.time <- Sys.time()

wclist <- loadByProduct(dpID="DP1.20093.001", 
                        site="MCRA", package="basic",
                        release="RELEASE-2025",
                        check.size=F, progress=F,
                        token=Sys.getenv("NEON_TOKEN"))

Sys.time() - start.time
start.time <- Sys.time()

tnl <- wclist$swc_externalLabDataByAnalyte |>
  filter(analyte=="TN") |>
  collect()

Sys.time() - start.time

