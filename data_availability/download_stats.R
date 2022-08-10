met <- read.csv('/Users/clunch/Desktop/NEON Data Access Statistics_Data Access Stats Table_Table.csv')
met.agg <- aggregate(met[,5:6], by=list(met$dpID, met$product_name), FUN=sum, na.rm=T)
names(met.agg)[1:2] <- c('dpID','DPName')
met.agg$DPL <- substring(met.agg$dpID, 3, 3)
met.agg <- met.agg[which(!is.na(as.numeric(met.agg$DPL))),]
met.agg <- met.agg[which(met.agg$DPL!=0),]
met.agg <- met.agg[which(substring(met.agg$dpID,1,1)=='D'),]
met.agg <- met.agg[order(met.agg$count_distinct_ip_addresses, decreasing=T),]

par(mar=c(6,4,1,1))
barplot(met.agg$count_distinct_ip_addresses[1:10], 
        names.arg=met.agg$dpID[1:10],
        las=2, cex.axis=0.8, cex.names=0.8)
barplot(met.agg$count_distinct_ip_addresses[124:133], 
        names.arg=met.agg$dpID[124:133],
        las=2, cex.axis=0.8, cex.names=0.8)

barplot(met.agg$count_distinct_ip_addresses[1:10], 
        names.arg=met.agg$DPName[1:10],
        las=2, cex.axis=0.8, cex.names=0.8)
barplot(met.agg$count_distinct_ip_addresses[124:133], 
        names.arg=met.agg$DPName[124:133],
        las=2, cex.axis=0.8, cex.names=0.8)

l.agg <- aggregate(met.agg$count_distinct_ip_addresses, by=list(met.agg$DPL), FUN=length)
s.agg <- aggregate(met.agg$count_distinct_ip_addresses, by=list(met.agg$DPL), FUN=sum)

lev <- s.agg$x/l.agg$x
barplot(lev, names.arg=1:4, xlab='Data product level', col='darkblue', border=NA)
