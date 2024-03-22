library(devtools)
library(neonUtilities)
library(neonOS)

wd <- '/Users/clunch/GitHub/definitional-data/pubWBs'
deflist <- list.files(wd)
deflist <- grep('.txt', deflist, value=T, fixed=T)

joinResult <- matrix(data=NA, ncol=6, nrow=0)
joinResult <- data.frame(joinResult)
names(joinResult) <- c('dpID', 'table1', 'table2', 'records1', 'records2', 'joinRecords')

for(i in 75:length(deflist)) {

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
  tabs <- tabs[grep('citation', tabs, invert=T)]
  
  if(length(tabs)==1) {
    joinResult <- rbind(joinResult, c(dpID, tabs,'','','','only table in DP'))
  } else {
    
    for(j in 1:I(length(tabs)-1)) {
      for(k in I(j+1):length(tabs)) {
        
        tst <- try(joinTableNEON(datList[[grep(paste(tabs[j], '$', sep=''), names(datList))]], 
                             datList[[grep(paste(tabs[k], '$', sep=''), names(datList))]], 
                             tabs[j], tabs[k]))
        if(class(tst)=='try-error') {
          joinResult <- rbind(joinResult, c(dpID, tabs[j],tabs[k],
                                            nrow(datList[[grep(paste(tabs[j], '$', sep=''), 
                                                               names(datList))]]),
                                            nrow(datList[[grep(paste(tabs[k], '$', sep=''), 
                                                               names(datList))]]),
                                            tst[1]))
        } else {
          joinResult <- rbind(joinResult, c(dpID, tabs[j],tabs[k],
                                            nrow(datList[[grep(paste(tabs[j], '$', sep=''), 
                                                               names(datList))]]),
                                            nrow(datList[[grep(paste(tabs[k], '$', sep=''), 
                                                               names(datList))]]),
                                            nrow(tst)))
        }
        
      }
    }
    
  }
  
}

joinResult <- unique(joinResult)

length(grep('only table in DP', joinResult$joinRecords))
length(grep('not identified in any quick start guide[.]', joinResult$joinRecords))
length(grep('could not be inferred', joinResult$joinRecords))
length(grep('not found in data tables', joinResult$joinRecords))
length(grep('not found in quick start guides', joinResult$joinRecords))
length(grep('is not recommended', joinResult$joinRecords))
length(grep('linking variables do not match', joinResult$joinRecords))
length(grep('automatable', joinResult$joinRecords))
length(grep('Direct join', joinResult$joinRecords))
length(which(!is.na(as.numeric(joinResult$joinRecords))))

joinS <- joinResult[which(!is.na(as.numeric(joinResult$joinRecords))),]
joinS$sumRecords <- joinS$records1+joinS$records2
joinQ <- joinS[which(joinS$sumRecords<as.numeric(joinS$joinRecords)),]
joinE <- joinS[which(joinS$sumRecords==as.numeric(joinS$joinRecords)),]

joinNI <- joinResult[grep('not identified', joinResult$joinRecords),]
joinNT <- joinResult[grep('not found in quick start guides', joinResult$joinRecords),]
joinNV <- joinResult[grep('linking variables', joinResult$joinRecords),]
joinNL <- joinResult[grep('Linking variables', joinResult$joinRecords),]

write.csv(joinResult, '/Users/clunch/GitHub/sandbox/neonOS_testing/joinResults.csv', row.names=F)
joinResult <- read.csv('/Users/clunch/GitHub/sandbox/neonOS_testing/joinResults.csv')
