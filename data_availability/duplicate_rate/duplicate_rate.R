options(stringsAsFactors = F)
library(devtools)
library(lubridate)
library(neonUtilities)
library(neonOSbase)

wd <- '/Users/clunch/GitHub'
l1Index <- read.delim('/Users/clunch/GitHub/sandbox/data_availability/duplicate_rate/L1Index_short.txt',
                      sep='\t')

dupRate <- c(NA, NA, NA, NA, NA, NA)
for(i in c(17:18)) {
  
  dpID <- l1Index$DPID[i]
  dpend <- l1Index$pathToPub[i]

  vars <- read.delim(paste(wd, dpend, sep=''), sep='\t')
  datList <- loadByProduct(dpID, check.size=F)
  
  for(j in 1:length(datList)) {
    
    if(names(datList)[j] %in% c('variables','validation','rea_conductivityFieldData')) {
      next
    }
    
    datListDup <- try(removeDups(datList[[j]], vars, 
                             paste(names(datList)[j], '_pub', sep='')), silent=T)
    
    if(class(datListDup)=='try-error') {
      cat(paste('No output for table', names(datList)[j]))
      next
    }
    
    dateR <- names(datListDup)[grep('Date', names(datListDup))][1]
    dateS <- try(strptime(datListDup[,dateR], format='%Y-%m-%dT%H:%M', tz='GMT'), silent=T)
    
    if(class(dateS)[1]=='try-error') {
      cat(paste('Date field not found for table', names(datList)[j]))
      next
    }
    
    if(all(is.na(dateS))) {
      dateS <- try(strptime(datListDup[,dateR], format='%Y-%m-%dT%H', tz='GMT'), silent=T)
    }
    
    if(all(is.na(dateS))) {
      dateS <- try(strptime(datListDup[,dateR], format='%Y-%m-%d', tz='GMT'), silent=T)
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
    ct <- aggregate(datListDup$uid,
                    by=list(dateY, dateM),
                    FUN=length)
    dupByDate <- cbind(rep(names(datList)[j], nrow(dupByDate)), 
                       ct$x, dupByDate)
    names(dupByDate) <- names(dupRate)
    dupRate <- rbind(dupRate, dupByDate)
    
  }
  
  remove(datList)
  remove(vars)

}

dupRate <- dupRate[-1,]
dupRate <- data.frame(dupRate)
names(dupRate) <- c('table', 'records', 'year', 'month', 'resolved', 'unresolved')

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
