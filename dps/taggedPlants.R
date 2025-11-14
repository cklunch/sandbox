# code to identify veg structure & phenology individuals with the same tags

library(neonUtilities)
library(geoNEON)
library(dplyr)

vegds <- datasetQuery('DP1.10098.001', site='all', tabl='vst_mappingandtagging', 
                      include.provisional = T, token=Sys.getenv('NEON_TOKEN'))
veg <- vegds |>
  collect()

pheds <- datasetQuery('DP1.10055.001', site='all', tabl='phe_perindividual',
                      include.provisional = T, token=Sys.getenv('NEON_TOKEN'))
phe <- pheds |>
  collect()

int <- intersect(veg$individualID, phe$individualID)
sites <- unique(substring(int, 14, 17))

phesub <- phe[which(phe$individualID %in% int),]
vegsub <- veg[which(veg$individualID %in% int),]

phesub <- getLocTOS(phesub, 'phe_perindividual', token=Sys.getenv('NEON_TOKEN'))
vegsub <- getLocTOS(vegsub, 'vst_mappingandtagging', token=Sys.getenv('NEON_TOKEN'))

phelocs <- phesub[,c('individualID','plotID','adjEasting','adjNorthing','taxonID','vstTag')]
names(phelocs)[2:5] <- c('phePlot','pheEasting', 'pheNorthing', 'pheTaxon')
veglocs <- vegsub[,c('individualID','plotID','adjEasting','adjNorthing','taxonID')]
names(veglocs)[2:5] <- c('vegPlot','vegEasting', 'vegNorthing', 'vegTaxon')

treeLocs <- merge(phelocs, veglocs, by='individualID', all=T)
treeLocs$distance <- sqrt((treeLocs$pheEasting - treeLocs$vegEasting)^2 + 
                            (treeLocs$pheNorthing - treeLocs$vegNorthing)^2)
treeLocs <- treeLocs[order(treeLocs$distance),]

write.csv(treeLocs, file='/Users/clunch/Desktop/taggedPlantLocations.csv', quote=F, row.names=F)

fulc <- read.csv('/Users/clunch/Desktop/tagid_overlap_vst.csv')
setdiff(fulc$individualid, treeLocSub$individualID)





