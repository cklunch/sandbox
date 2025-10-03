library(neonUtilities)
library(neonOS)
library(ggplot2)
library(lubridate)
library(dplyr)
library(visNetwork)

soil <- loadByProduct(dpID='DP1.10086.001',
                      site='SOAP',
                      startdate='2018-01',
                      enddate='2024-12',
                      include.provisional = T,
                      progress=F,
                      check.size=F)
list2env(soil, .GlobalEnv)

moisturedups <- removeDups(sls_soilMoisture,
                           variables_10086)
chemdups <- removeDups(sls_soilChemistry,
                       variables_10086)

moistchem <- joinTableNEON(sls_soilMoisture,
                           sls_soilChemistry)

plot(nitrogenPercent~soilMoisture,
     data=moistchem,
     pch=20)

sim <- byEventSIM('fire', site='SOAP')

View(sim$sim_eventData)

unique(year(sls_soilChemistry$collectDate))

plot(nitrogenPercent~soilMoisture,
     data=moistchem[which(year(moistchem$collectDate.y)==2018),],
     pch=20)
points(nitrogenPercent~soilMoisture,
     data=moistchem[which(year(moistchem$collectDate.y)==2024),],
     pch=20, col='red')

micro <- loadByProduct(dpID='DP1.10081.002',
                       site='SOAP',
                       startdate = '2018-05',
                       enddate = '2024-12',
                       package = 'expanded',
                       include.provisional = T,
                       progress=F,
                       check.size = F)
list2env(micro, .GlobalEnv)

gg <- ggplot(mct_soilPerSampleTaxonomy_ITS, aes(phylum, individualCount)) +
  geom_col() +
  theme(axis.text.x=element_text(angle=90))
gg

unique(year(mct_soilSampleMetadata_ITS$collectDate))


samp <- getSampleTree(sls_soilCoreCollection$sampleID[1])
View(samp)
edges <- data.frame(cbind(to=samp$sampleUuid, from=samp$parentSampleUuid))
nodes <- data.frame(cbind(id=samp$sampleUuid, label=samp$sampleTag))
visNetwork(nodes, edges) |>
  visEdges(arrows='to')

