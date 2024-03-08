# load packages
library(neonUtilities)
library(neonOS)
library(ggplot2)
library(maps)

# download data
cfc <- loadByProduct(dpID='DP1.10026.001', 
                     package='expanded',
                     include.provisional=F,
                     check.size=F)

# do this the first time you run the code, to download the data
# change file path to something on your computer
saveRDS(cfc, '/Users/clunch/Desktop/cfc_rel_2024.rds')
# after the first time, run this line instead of lines 6-13 - load already-downloaded data
# change file path
cfc <- readRDS('/Users/clunch/Desktop/cfc_rel_2024.rds')

# make species list for each site
splist <- vector('list', length(unique(cfc$cfc_fieldData$siteID)))
names(splist) <- unique(cfc$cfc_fieldData$siteID)
ind <- 0
for(i in unique(cfc$cfc_fieldData$siteID)) {
  ind <- ind+1
  itax <- unique(cfc$cfc_fieldData$taxonID[which(cfc$cfc_fieldData$siteID==i)])
  splist[[ind]] <- itax
}

# get frequency table of all species
ft <- table(unlist(splist))

# find most frequent species
ft[which(ft==max(ft))]

# get the 13 sites where ACRU (Acer rubrum) appears
# actually this step is unnecessary
aspl <- splist[unlist(lapply(splist, FUN=function(x) {'ACRU' %in% x}))]
acru.sites <- names(aspl)

# join chemistry data to species data, subset to only ACRU data
lma <- joinTableNEON(cfc$cfc_fieldData,
                     cfc$cfc_LMA,
                     'cfc_fieldData',
                     'cfc_LMA')
lmaa <- lma[which(lma$taxonID=='ACRU'),]

# load site metadata table to get location & climate of each site
fsm <- read.csv('/Users/clunch/Desktop/NEON_Field_Site_Metadata_20231026.csv')
# join to trait data
lmaall <- merge(lmaa, fsm, by.x='siteID', by.y='field_site_id', all.x=T)

# calculate mean values per site
lmamean <- aggregate(lmaall, by=list(lmaall$siteID), FUN=mean, na.rm=T)
colnames(lmamean)[1] <- 'Site'

# get US map data from maps package
mpus <- map_data('world')[which(map_data('world')$region=='USA'),]

# bubble map of ACRU LMA
gg <- ggplot() +
  geom_polygon(data=mpus, aes(x=long, y=lat, group=group), fill="grey", alpha=0.3) +
  geom_point(data=lmamean, aes(x=field_longitude, y=field_latitude, 
                              size=leafMassPerArea, color=Site, 
                              alpha=0.5)) +
  theme_void() + xlim(-130,-60) + ylim(25,50) + coord_map() 
gg

# plot against temperature/rainfall instead of map
gg <- ggplot(data=lmamean, aes(x=field_mean_annual_precipitation_mm,
                               y=field_mean_annual_temperature_C,
                               color=Site, alpha=0.5,
                               size=leafMassPerArea)) +
  geom_point()
gg


# do the same thing with the minor elements table, check out foliar Mn
ele <- joinTableNEON(cfc$cfc_fieldData,
                     cfc$cfc_elements,
                     'cfc_fieldData',
                     'cfc_elements')
elea <- ele[which(ele$taxonID=='ACRU'),]
eleall <- merge(elea, fsm, by.x='siteID', by.y='field_site_id', all.x=T)

elemean <- aggregate(eleall, by=list(eleall$siteID), FUN=mean, na.rm=T)
colnames(elemean)[1] <- 'Site'

gg <- ggplot() +
  geom_polygon(data=mpus, aes(x=long, y=lat, group=group), fill="grey", alpha=0.3) +
  geom_point(data=elemean, aes(x=field_longitude, y=field_latitude, 
                               size=foliarManganeseConc, color=Site, 
                               alpha=0.5)) +
  theme_void() + xlim(-130,-60) + ylim(25,50) + coord_map() 
gg

gg <- ggplot(data=elemean, aes(x=field_mean_annual_precipitation_mm,
                               y=field_mean_annual_temperature_C,
                               color=Site, alpha=0.5,
                               size=foliarManganeseConc)) +
  geom_point()
gg


# do the same thing with the C/N table, check out foliar C:N ratio
cn <- joinTableNEON(cfc$cfc_fieldData,
                     cfc$cfc_carbonNitrogen,
                     'cfc_fieldData',
                     'cfc_carbonNitrogen')
cna <- cn[which(cn$taxonID=='ACRU'),]
cnall <- merge(cna, fsm, by.x='siteID', by.y='field_site_id', all.x=T)

cnmean <- aggregate(cnall, by=list(cnall$siteID), FUN=mean, na.rm=T)
colnames(cnmean)[1] <- 'Site'

gg <- ggplot() +
  geom_polygon(data=mpus, aes(x=long, y=lat, group=group), fill="grey", alpha=0.3) +
  geom_point(data=cnmean, aes(x=field_longitude, y=field_latitude, 
                               size=CNratio, color=Site, 
                               alpha=0.5)) +
  theme_void() + xlim(-130,-60) + ylim(25,50) + coord_map() 
gg

gg <- ggplot(data=cnmean, aes(x=field_mean_annual_precipitation_mm,
                               y=field_mean_annual_temperature_C,
                               color=Site, alpha=0.5,
                               size=CNratio)) +
  geom_point()
gg


# 13C
gg <- ggplot() +
  geom_polygon(data=mpus, aes(x=long, y=lat, group=group), fill="grey", alpha=0.3) +
  geom_point(data=cnmean, aes(x=field_longitude, y=field_latitude, 
                              size=d13C, color=Site, 
                              alpha=0.5)) +
  theme_void() + xlim(-130,-60) + ylim(25,50) + coord_map() 
gg

gg <- ggplot(data=cnmean, aes(x=field_mean_annual_precipitation_mm,
                              y=field_mean_annual_temperature_C,
                              color=Site, alpha=0.5,
                              size=d13C)) +
  geom_point()
gg
