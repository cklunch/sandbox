library(neonUtilities)
library(ggplot2)
library(lubridate)
options(stringsAsFactors = F)

# get data
waq <- loadByProduct('DP1.20288.001', site='BARC')

# convert time stamps
strt <- as.POSIXct(strptime(waq$waq_instantaneous$startDateTime, 
                            format='%Y-%m-%dT%H:%M:%SZ', tz='GMT'))

# plot everything
plot(waq$waq_instantaneous$chlorophyll~strt, pch='.',
     xlab='Date', ylab='Chlorophyll a', tck=0.01)

# aggregate chlorophyll data to make reasonable bounds
strtM <- format(strt, '%Y-%m')
waq$waq_instantaneous <- cbind(strt, strtM, waq$waq_instantaneous)
chl <- aggregate(waq$waq_instantaneous$chlorophyll, by=list(strtM), FUN=mean, na.rm=T)
chlsd <- aggregate(waq$waq_instantaneous$chlorophyll, by=list(strtM), FUN=sd, na.rm=T)
chl <- merge(chl, chlsd, by='Group.1')
names(chl) <- c('month','mean','sd')
chl$month <- parse_date_time(chl$month, 'ym')

# plot mean +/- sd by month
gg <- ggplot(chl, aes(x=month, y=mean)) + 
  geom_ribbon(aes(ymin=mean-2*sd, ymax=mean+2*sd), alpha=0.7) + 
  geom_line()
gg

