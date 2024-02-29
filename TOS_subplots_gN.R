# compare locations calculated by RELEASE-2023 and RELEASE-2024

library(neonUtilities)
library(geoNEON)

# table of DPIDs and table names to be checked
dps <- read.csv('/Users/clunch/GitHub/sandbox/TOS_subplot_prods.csv')

for(i in c(1,2,5,7)) {
  
  d23 <- loadByProduct(dps$dpID[i], 
                       site='JERC', 
                       release='RELEASE-2023',
                       startdate='2018-01', 
                       enddate='2019-12',
                       check.size=F,
                       token=Sys.getenv('NEON_TOKEN'))
  
  d24 <- loadByProduct(dps$dpID[i], 
                       site='JERC', 
                       release='RELEASE-2024',
                       startdate='2018-01', 
                       enddate='2019-12',
                       check.size=F,
                       token=Sys.getenv('NEON_TOKEN'))
  
  g23 <- getLocTOS(d23[[dps$tableName[i]]], 
                   dps$tableName[i],
                   token=Sys.getenv('NEON_TOKEN'))
  
  g24 <- getLocTOS(d24[[dps$tableName[i]]], 
                   dps$tableName[i],
                   token=Sys.getenv('NEON_TOKEN'))
  
  print(dps$tableName[i])
  print(all(g23$adjEasting==g24$adjEasting))
  
}

# vst comparison
for(j in 1:nrow(g24)) {
  if(!is.na(g24$individualID[j])) {
    if(!is.na(g24$pointID[j])) {
      if(!is.na(g24$stemDistance[j])) {
        if(g24$individualID[j] %in% g23$individualID & 
           g24$eventID[j] %in% g23$eventID) {
          if(g24$adjEasting[j]!=g23$adjEasting[which(g23$individualID==g24$individualID[j] &
                                                     g23$eventID==g24$eventID[j])]) {
            print(j)
          }
        }
      }
    }
  }
}

# sls comparison
for(k in 1:nrow(g24)) {
  if(g24$adjEasting[k]!=g23$adjEasting[which(g23$sampleID==g24$sampleID[k])]) {
    print(k)
  }
}

# div comparison
for(k in 1:nrow(g24)) {
  if(g24$adjEasting[k]!=g23$adjEasting[which(g23$subplotID==g24$subplotID[k] &
                                             g23$eventID==g24$eventID[k] &
                                             g23$taxonID==g24$taxonID[k])]) {
    print(k)
  }
}



