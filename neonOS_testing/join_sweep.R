library(devtools)
library(neonUtilities)
library(neonOS)

wd <- '/Users/clunch/GitHub/definitional-data/pubWBs'
deflist <- list.files(wd)

joinResult <- matrix(data=NA, ncol=5, nrow=1)
joinResult <- data.frame(joinResult)
names(joinResult) <- c('table1', 'table2', 'records1', 'records2', 'joinRecords')

for(i in c(74:length(deflist))) {
  
  vars <- read.delim(paste(wd, deflist[i], sep='/'), sep='\t')
  dpID <- substring(unique(vars$dpID), 15, 28)
  if(length(dpID)!=1) {
    cat(paste('Could not find dpID for row ', i, sep=''))
    next
  }
  
  datList <- try(loadByProduct(dpID, check.size=F, package='expanded',
                               startdate='2019-05', enddate='2020-08',
                               token=Sys.getenv('NEON_TOKEN')))
  
  if(class(datList)=='try-error') {
    cat(paste(dpID, ': No data found for 2019-05 to 2020-08', sep=''))
    next
  }
  
  tabs <- names(datList)
  tabs <- tabs[grep('variables', tabs, invert=T)]
  tabs <- tabs[grep('validation', tabs, invert=T)]
  tabs <- tabs[grep('categorical', tabs, invert=T)]
  tabs <- tabs[grep('readme', tabs, invert=T)]
  tabs <- tabs[grep('issueLog', tabs, invert=T)]
  
  if(length(tabs)==1) {
    joinResult <- rbind(joinResult, c(tabs,'','','','only table in DP'))
  } else {
    
    for(j in 1:length(tabs)) {
      for(k in j:length(tabs)) {
        
        tst <- try(joinTableNEON(datList[[grep(tabs[j], names(datList))]], 
                             datList[[grep(tabs[k], names(datList))]], 
                             tabs[j], tabs[k]))
        if(class(tst)=='try-error') {
          joinResult <- rbind(joinResult, c(tabs[j],tabs[k],
                                            nrow(datList[[grep(tabs[j], names(datList))]]),
                                            nrow(datList[[grep(tabs[k], names(datList))]]),
                                            tst[1]))
        } else {
          joinResult <- rbind(joinResult, c(tabs[j],tabs[k],
                                            nrow(datList[[grep(tabs[j], names(datList))]]),
                                            nrow(datList[[grep(tabs[k], names(datList))]]),
                                            nrow(tst)))
        }
        
      }
    }
    
  }
  
}

write.csv(joinResult, '/Users/clunch/GitHub/sandbox/neonOS_testing/joinResults.csv', row.names=F)
joinResult <- read.csv('/Users/clunch/GitHub/sandbox/neonOS_testing/joinResults.csv')
