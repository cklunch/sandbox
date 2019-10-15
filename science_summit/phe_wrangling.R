library(neonUtilities)

phe <- loadByProduct('DP1.10055.001', site='WREF', check.size=F)

phe.ind <- phe$phe_perindividual

# In the perindividual table, data about each individual can be updated over 
# time. We want to keep the most recent record for each individual, ie the 
# one with the maximum editedDate
ind <- numeric()
for(i in 1:nrow(phe.ind)) {
  phe.ind.sub <- phe.ind[which(phe.ind$individualID==phe.ind$individualID[i]),]
  if(as.character(phe.ind$editedDate[i])==max(as.character(phe.ind.sub$editedDate))) {
    ind <- c(ind, i)
  }
}

phe.ind <- phe.ind[ind,]

# only individualID is functional for the join, the other variables
# are included to avoid duplicate columns
phe.stat <- merge(phe.ind, phe$phe_statusintensity, by=c('namedLocation','individualID',
                                                         'domainID','siteID','plotID'))


