options(stringsAsFactors = F)
library(devtools)
library(lubridate)
library(neonUtilities)
library(neonOS)

wd <- '/Users/clunch/GitHub/definitional-data/pubWBs'
deflist <- list.files(wd)

dupRate <- matrix(data=NA, ncol=6, nrow=1)
dupRate <- data.frame(dupRate)
names(dupRate) <- c('table', 'records', 'year', 'month', 'resolved', 'unresolved')
#dupRate <- read.csv('/Users/clunch/GitHub/sandbox/data_availability/duplicate_rate/duplicateRate.csv')

tableResult <- matrix(data=NA, ncol=4, nrow=1)
tableResult <- data.frame(tableResult)
names(tableResult) <- c('dpID', 'table', 'records', 'duplicates')
#tableResult <- read.csv('/Users/clunch/GitHub/sandbox/data_availability/duplicate_rate/tableResults.csv')

for(i in c(65:length(deflist))) {

  vars <- read.delim(paste(wd, deflist[i], sep='/'), sep='\t')
  dpID <- substring(unique(vars$dpID), 15, 28)
  if(length(dpID)!=1) {
    cat(paste('Could not find dpID for row ', i, sep=''))
    next
  }
  
  datList <- try(loadByProduct(dpID, check.size=F, package='expanded',
                               startdate='2017-05', enddate='2018-08',
                               token=Sys.getenv('NEON_TOKEN')))
  
  if(class(datList)=='try-error') {
    dres <- c(dpID, '', 'No data found for 2017-05 to 2018-08', '')
    tableResult <- rbind(tableResult, dres)
    next
  }
  
  for(j in names(datList)) {
    
    if(j %in% c('rea_conductivityFieldData','sbd_conductivityFieldData') | 
       length(grep('variables', j))>0 | length(grep('validation', j))>0 | 
       length(grep('readme', j))>0 | length(grep('categoricalCodes', j))>0) {
      next
    }
    
    datList[[j]] <- datList[[j]][,-which(names(datList[[j]])=='publicationDate')]
    
    datListDup <- try(removeDups(datList[[j]], 
                                 vars, 
                                 paste(j, '_pub', sep='')), silent=T)
    
    if(class(datListDup)=='try-error') {
      dupres <- c(dpID, j, datListDup[1], '')
      tableResult <- rbind(tableResult, dupres)
      next
    }
    
    ctall <- nrow(datListDup)
    dupall <- length(which(datListDup$duplicateRecordQF!=0))
    endres <- c(dpID, j, ctall, dupall)
    tableResult <- rbind(tableResult, endres)
    #tableResult[which(tableResult$table==j),] <- endres
    
    dateS <- try(datListDup[,grep('Date', names(datListDup), ignore.case=T)[1]], silent=T)

    if(class(dateS)[1]!='POSIXct') {
      datres <- c(dpID, j, 'Date field not found', '')
      #tableResult <- rbind(tableResult, datres)
      next
    }
    
    dateM <- month(dateS)
    dateY <- year(dateS)
    
    dups1 <- datListDup$duplicateRecordQF
    dups2 <- datListDup$duplicateRecordQF
    dups1[which(dups1==2)] <- 0
    dups2[which(dups2==1)] <- 0
    
    dupByDate <- aggregate(cbind(dups1, dups2), 
                           by=list(dateY, dateM), 
                           FUN=sum, na.rm=T)
    ct <- try(aggregate(datListDup$uid,
                    by=list(dateY, dateM),
                    FUN=length), silent=T)
    if(class(ct)=='try-error') {
      datres <- c(dpID, j, 'No uid found', '')
      #tableResult <- rbind(tableResult, datres)
      next
    }
    dupByDate <- cbind(rep(j, nrow(dupByDate)), 
                       ct$x, dupByDate)

    names(dupByDate) <- names(dupRate)
    dupRate <- rbind(dupRate, dupByDate)
    
  }
  
  remove(datList)
  remove(vars)

}

dupRate <- dupRate[-1,]

write.table(dupRate, 
            '/Users/clunch/GitHub/sandbox/data_availability/duplicate_rate/duplicateRate.csv',
            sep=',', row.names=F)

# tabResSpl <- tidyr::separate(tableResult, 'outcome', sep=' ', 
#                              into=c('records', NA, NA, NA, 'dupNum', NA), 
#                              fill='right')
# tabResSpl <- tabResSpl[-1,]
# tabResSpl$dupPct <- 100*as.numeric(tabResSpl$dupNum)/as.numeric(tabResSpl$records)

tableResult <- tableResult[-1,]
write.table(tableResult, 
            '/Users/clunch/GitHub/sandbox/data_availability/duplicate_rate/tableResults.csv',
            sep=',', row.names=F)


datMerg <- ymd(paste(dupRate$year, dupRate$month, '01', sep='-'))
dupCt <- dupRate$resolved + dupRate$unresolved/2
dupPct <- dupCt/dupRate$records

pctByMonth <- aggregate(dupPct, by=list(datMerg), mean)
names(pctByMonth) <- c('month','dupPct')
plot(pctByMonth$dupPct~pctByMonth$month, type='l')

ctByMonth <- aggregate(dupCt, by=list(datMerg), mean)
names(ctByMonth) <- c('month','dupCt')
plot(ctByMonth$dupCt~ctByMonth$month, type='l')

# converting to by quarter
pctByMonth <- pctByMonth[25:78,]
qurt <- quarter(pctByMonth$month, with_year=T)
pctByQ <- aggregate(pctByMonth$dupPct, by=list(qurt), FUN=mean)
names(pctByQ) <- c('quarter','dupPct')
pctByQ$quarter <- c('2015-02-01','2015-05-01','2015-08-01','2015-11-01',
                    '2016-02-01','2016-05-01','2016-08-01','2016-11-01',
                    '2017-02-01','2017-05-01','2017-08-01','2017-11-01',
                    '2018-02-01','2018-05-01','2018-08-01','2018-11-01',
                    '2019-02-01','2019-05-01')
pctByQ$quarter <- strptime(pctByQ$quarter, format='%Y-%m-%d')
pctByQ$quarter <- as.POSIXct(pctByQ$quarter)
pctByQ$dupPct <- pctByQ$dupPct*100
#pctByQ$dupPct[1] <- NA
plot(pctByQ$dupPct~pctByQ$quarter, type='l', tck=0.01, lwd=2,
     xlab='Date (by quarter)', ylab='Duplicate rate (%)')


saveRDS(dupRate, '/Users/clunch/GitHub/sandbox/data_availability/duplicate_rate/dupRate.rds')
