library(neonUtilities)
library(neonOS)
library(ggplot2)

zoo <- loadByProduct('DP1.20219.001', include.provisional = T, package='expanded',
                     token=Sys.getenv('NEON_TOKEN'), check.size=F)

# total count per year
zoo$zoo_taxonomyProcessed$year <- lubridate::year(zoo$zoo_taxonomyProcessed$collectDate)
zoot <- aggregate(zoo$zoo_taxonomyProcessed$individualCount, by=list(zoo$zoo_taxonomyProcessed$siteID,
                                                     zoo$zoo_taxonomyProcessed$year),
                  FUN=sum)
names(zoot) <- c('site','year','count')
zoot$year <- as.factor(zoot$year)

gg <- ggplot(zoot, aes(year, count)) +
  geom_col()
gg

# number of taxa per year
zoon <- aggregate(zoo$zoo_taxonomyProcessed$taxonID, by=list(zoo$zoo_taxonomyProcessed$siteID,
                                                                     zoo$zoo_taxonomyProcessed$year),
                  FUN=length)
names(zoon) <- c('site','year','ntaxa')
zoon$year <- as.factor(zoon$year)

gg <- ggplot(zoon, aes(year, ntaxa)) +
  geom_col()
gg

# this is not right, they subsample. need to look at count per bottle and tow traps volume
# one record per sample in zoo_fieldData
list2env(zoo, .GlobalEnv)
zoot <- joinTableNEON(zoo_fieldData, zoo_taxonomyProcessed)
zoot$year <- lubridate::year(zoot$collectDate.x)
zoo.samp <- aggregate(zoot$adjCountPerBottle, 
                      by=list(zoot$siteID, zoot$year, zoot$laboratoryName, zoot$sampleID),
                      FUN=sum)
zoo.vol <- aggregate(zoot$towsTrapsVolume, 
                      by=list(zoot$siteID, zoot$year, zoot$laboratoryName, zoot$sampleID),
                      FUN=mean)
zoon <- merge(zoo.samp, zoo.vol, by=c('Group.1','Group.2','Group.3','Group.4'))
names(zoon) <- c('siteID','year','lab','sampleID','countPerBottle','volume')

gg <- ggplot(zoon, aes(year, volume, group=year)) +
  geom_col()
gg

gg <- ggplot(zoon, aes(year, countPerBottle, group=year)) +
  geom_boxplot()
gg

zoon$logcount <- log(zoon$countPerBottle)
zoon$year <- factor(zoon$year)
zoon$total <- zoon$countPerBottle/zoon$volume
zoon$logtotal <- log(zoon$total)

gg <- ggplot(zoon, aes(x=year, y=logcount, fill=lab)) +
  geom_boxplot() +
  facet_wrap(~lab)
gg

gg <- ggplot(zoon, aes(x=year, y=logcount, fill=lab)) +
  geom_boxplot() +
  facet_wrap(~siteID)
gg

gg <- ggplot(zoon, aes(x=year, y=volume, fill=siteID)) +
  geom_boxplot() +
  facet_wrap(~siteID)
gg

gg <- ggplot(zoon, aes(x=year, y=logtotal, fill=siteID)) +
  geom_boxplot() +
  facet_wrap(~siteID)
gg

gg <- ggplot(zoon, aes(x=year, y=logtotal, fill=lab)) +
  geom_boxplot() +
  facet_wrap(~siteID)
gg

gg <- ggplot(zoon, aes(x=year, y=total, fill=lab)) +
  geom_boxplot() +
  facet_wrap(~siteID)
gg

gg <- ggplot(zoon, aes(x=year, y=total, fill=lab)) +
  geom_boxplot() +
  coord_cartesian(ylim=c(0, 1500)) +
  facet_wrap(~siteID)
gg

# with bouts
zoob.samp <- aggregate(zoot$adjCountPerBottle, 
                      by=list(zoot$siteID, zoot$year, zoot$boutNumber, 
                              zoot$laboratoryName, zoot$sampleID),
                      FUN=sum)
zoob.vol <- aggregate(zoot$towsTrapsVolume, 
                     by=list(zoot$siteID, zoot$year, zoot$boutNumber, 
                             zoot$laboratoryName, zoot$sampleID),
                     FUN=mean)
zoob <- merge(zoob.samp, zoob.vol, by=c('Group.1','Group.2','Group.3','Group.4','Group.5'))
names(zoob) <- c('siteID','year','bout','lab','sampleID','countPerBottle','volume')
zoob$year <- factor(zoob$year)
zoob$total <- zoob$countPerBottle/zoob$volume

gg <- ggplot(subset(zoob, bout==3), aes(x=year, y=total, fill=lab)) +
  geom_boxplot() +
  coord_cartesian(ylim=c(0, 1500)) +
  facet_wrap(~siteID)
gg

