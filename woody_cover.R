library(neonUtilities)
library(httr)
library(jsonlite)
library(ggplot2)

veg <- loadByProduct(dpID='DP1.10098.001', check.size=F, 
                     token=Sys.getenv('NEON_TOKEN'),
                     package='expanded')

div <- loadByProduct(dpID='DP1.10058.001', check.size=F, 
                     token=Sys.getenv('NEON_TOKEN'),
                     package='expanded')

sch <- loadByProduct(dpID='DP1.10008.001', check.size=F,
                     token=Sys.getenv('NEON_TOKEN'),
                     package='expanded')

# stem density and basal area?

intersect(names(veg$vst_apparentindividual), names(veg$vst_mappingandtagging))
vegall <- merge(veg$vst_mappingandtagging, veg$vst_apparentindividual, 
                by=c('individualID','namedLocation','domainID','siteID','plotID'),
                all=T)

vegd <- vegall[which(!is.na(vegall$stemDiameter)),]
vegd$area <- pi*(vegd$stemDiameter/200)^2

# basal area
ba <- aggregate(vegd$area, by=list(vegd$siteID, vegd$plotID), FUN=sum, na.rm=T)
colnames(ba) <- c('site','plot','area')
ba$area <- ba$area/1600 # now in m2 per m2 - tree basal area per m2

m.ba <- merge(m, ba, by='site', all.x=T)

plot(m.ba$area~m.ba$map, pch=20, cex=0.3)
plot(m.ba$area~m.ba$mat, pch=20, cex=0.3)

gg <- ggplot(data=m.ba, aes(x=mat, y=map)) +
  geom_point(aes(size=area))
gg

# stem density
stemd <- aggregate(vegd$area, by=list(vegd$siteID, vegd$plotID), FUN=length)
colnames(stemd) <- c('site','plot','count')
stemd$dens <- stemd$count/1600 # stems per m2 - should probably be per hectare

m.sd <- merge(m, stemd, by='site', all.x=T)

plot(m.sd$dens~m.sd$map, pch=20, cex=0.3,
     tck=0.01, xlab='Mean Annual Precipitation',
     ylab="Stem Density")
plot(m.sd$dens~m.sd$mat, pch=20, cex=0.3,
     tck=0.01, xlab='Mean Annual Temperature',
     ylab="Stem Density")

m.sd$Density <- m.sd$dens
m.f <- aggregate(cbind(m.sd$Density, m.sd$map, m.sd$mat), by=list(m.sd$site), FUN=mean, na.rm=T)
colnames(m.f) <- c('site','Density','map','mat')
gg <- ggplot(data=m.f, aes(x=mat, y=map)) +
  geom_point(aes(size=Density), alpha=0.5) + 
  theme_classic() +
  labs(x='Mean Annual Temperature', y='Mean Annual Precipitation')
gg




# soil carbon

# mean per site - all horizons
sc <- aggregate(sch$spc_biogeochem$carbonTot, by=list(sch$spc_biogeochem$siteID), FUN=mean, na.rm=T)
names(sc) <- c('site','Carbon')

sc.m <- merge(m, sc, by='site', all.x=T)

gg <- ggplot(data=sc.m, aes(x=mat, y=map)) +
  geom_point(aes(size=Carbon), alpha=0.5) + 
  theme_classic() +
  labs(x='Mean Annual Temperature', y='Mean Annual Precipitation')
gg

# mean per site - mineral horizons
noo <- sch$spc_biogeochem[grep('O', sch$spc_biogeochem$horizonName, invert=T),]
no <- aggregate(noo$carbonTot, by=list(noo$siteID), FUN=mean, na.rm=T)
names(no) <- c('site','Carbon')

no.m <- merge(m, sc, by='site', all.x=T)

gg <- ggplot(data=no.m, aes(x=mat, y=map)) +
  geom_point(aes(size=Carbon), alpha=0.5) + 
  theme_classic() +
  labs(x='Mean Annual Temperature', y='Mean Annual Precipitation')
gg




# a bunch of attempts at overstory cover

div.cover <- div$div_1m2Data[which(div$div_1m2Data$otherVariables=="overstory"),]
site.cover <- aggregate(div.cover$percentCover, by=list(div.cover$siteID), FUN=mean, na.rm=T)
site.sd <- aggregate(div.cover$percentCover, by=list(div.cover$siteID), FUN=sd, na.rm=T)
colnames(site.cover) <- c('site','meanCover')
colnames(site.sd) <- c('site','sdCover')
cover <- merge(site.cover, site.sd)

cover.all <- data.frame(cbind(div.cover$percentCover, div.cover$siteID))
colnames(cover.all) <- c('overCover', 'site')

# site climate data
m <- read.delim('https://www.neonscience.org/science-design/field-sites/export', sep=',')
mat <- data.frame(matrix(unlist(strsplit(m$Mean.Annual.Temperature, '/', fixed=T)), ncol=2, byrow=T))
mat[,1] <- gsub('C', '', mat[,1])
mat <- mat[,1]
mat <- as.numeric(mat)

map <- gsub(' mm', '', m$Mean.Annual.Precipitation)
map <- as.numeric(map)

m <- cbind(m, mat, map)
colnames(m)[2] <- 'site'

m.dat <- merge(m, cover, by='site', all.x=T)

plot(m.dat$meanCover~m.dat$map, pch=20)
plot(m.dat$meanCover~m.dat$mat, pch=20)

symbols(m.dat$map~m.dat$mat, circles=sqrt(m.dat$meanCover)/pi, inches=0.1)

gg <- ggplot(data=subset(m.dat, !is.na(m.dat$meanCover)), aes(x=map, y=meanCover)) +
  geom_violin(aes(color=Domain.Number))
gg


# no aggregating
m.all <- merge(m, cover.all, by='site', all=T)
m.all$overCover <- as.numeric(m.all$overCover)

plot(m.all$overCover~m.all$map, pch=20, cex=0.3)
plot(m.all$overCover~m.all$mat, pch=20, cex=0.3)

gg <- ggplot(data=m.all, aes(x=map, y=overCover)) +
  geom_violin(aes(color=site))
gg

gg <- ggplot(data=m.all, aes(x=mat, y=overCover)) +
  geom_violin(aes(color=site))
gg

# this is... not great.

# aggregate by plot?
plot.cover <- aggregate(div.cover$percentCover, 
                        by=list(div.cover$plotID, div.cover$siteID), FUN=mean, na.rm=T)
colnames(plot.cover) <- c('plot','site','meanCover')

m.plot <- merge(m, plot.cover, by='site', all=T)

gg <- ggplot(data=m.plot, aes(x=map, y=meanCover)) +
  geom_violin(aes(color=site))
gg

gg <- ggplot(data=m.plot, aes(x=mat, y=meanCover)) +
  geom_violin(aes(color=site))
gg

gg <- ggplot(data=m.plot, aes(x=map, y=meanCover)) +
  geom_violin(aes(color=Domain.Number))
gg

# use only forested sites?
m.f <- m.plot[grep('Forest', m.plot$Dominant.NLCD.Classes),]
gg <- ggplot(data=m.f, aes(x=map, y=meanCover)) +
  geom_violin(aes(color=site))
gg


## a bunch of futzing around

unique(vegall$taxonID[!vegall$taxonID %in% div$div_1m2Data$taxonID])
unique(div$div_1m2Data$taxonID[!div$div_1m2Data$taxonID %in% vegall$taxonID])


tst <- GET('https://plants.usda.gov/api/plants/search/basic?symbol=ABBA', accept='application/json')
fromJSON(content(tst, "text"), flatten=T)

tst <- GET('https://plants.usda.gov/api/plants/search?scientific_name=Viburnum%20lantanoides', accept='application/json')
fromJSON(content(tst, "text"), flatten=T)
