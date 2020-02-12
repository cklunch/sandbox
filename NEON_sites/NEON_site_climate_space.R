# script to calculate mean annual temperature and mean annual precipitation for NEON sites
# also calculates standard deviation of MAT and MAP
# using PRISM 4km normals (1981-2010) and recent years (1981-2019) datasets, accessed 2020-02-03
# Alaska, Hawaii, and Puerto Rico are separate datasets. Accessed 2020-02-04

options(stringsAsFactors = F)
library(raster)
library(httr)
library(jsonlite)
library(SDMTools)
library(ggplot2)

# get NEON site list & location data
site.req <- GET('https://data.neonscience.org/api/v0/locations/sites')
site.locs <- fromJSON(content(site.req, as='text'))
site.mat <- cbind(site.locs$data$siteCode, site.locs$data$locationDecimalLatitude, 
                  site.locs$data$locationDecimalLongitude, site.locs$data$locationUtmEasting,
                  site.locs$data$locationUtmNorthing, site.locs$data$locationUtmZone)
site.mat <- data.frame(site.mat)
names(site.mat) <- c('site','latitude','longitude','easting','northing','utmZone')
sites <- site.mat[which(!is.na(site.mat$latitude)),]
sites$latitude <- as.numeric(sites$latitude)
sites$longitude <- as.numeric(sites$longitude)
sites$easting <- as.numeric(sites$easting)
sites$northing <- as.numeric(sites$northing)

# load prism 30-year precipitation data, and extract values at NEON sites
ppt.norm <- raster('/Users/clunch/Dropbox/data/NEON data/prism/PRISM_ppt_30yr_normal_4kmM2_all_bil/PRISM_ppt_30yr_normal_4kmM2_annual_bil.bil')
ppt.site <- extract(x=ppt.norm, y=cbind(sites$longitude, sites$latitude))

site.clim <- cbind(sites$site, ppt.site)
site.clim <- data.frame(site.clim)
names(site.clim) <- c('site','ppt.30yr.mean')

# load prism 30-year temperature data, and extract values at NEON sites
temp.norm <- raster('/Users/clunch/Dropbox/data/NEON data/prism/PRISM_tmean_30yr_normal_4kmM2_annual_bil/PRISM_tmean_30yr_normal_4kmM2_annual_bil.bil')
temp.site <- extract(x=temp.norm, y=cbind(sites$longitude, sites$latitude))
site.clim <- cbind(site.clim, temp.site)
names(site.clim)[3] <- 'temp.30yr.mean'

# plot annual mean values
plot(site.clim$ppt.30yr.mean~site.clim$temp.30yr.mean, pch=20, tck=0.01,
     xlab='Mean annual temperature (C)', ylab='Mean annual rainfall (mm)')

# prism historical data is organized with a separate raster for each month since 1981, plus metadata files
# get full list of files for precipitation, then filter down to only the raster files
ppt.files <- list.files('/Users/clunch/Dropbox/data/NEON data/prism/PRISM_ppt_stable_4kmM3_198101_201907_bil/')
ppt.bil <- ppt.files[grep('bil.bil', ppt.files)]
ppt.bil <- ppt.bil[-grep('aux.xml', ppt.bil)]

# loop over the list of rasters, extracting data at NEON site locations from each raster
pptByMonth <- character()
for(i in ppt.bil) {
  ras.i <- raster(paste('/Users/clunch/Dropbox/data/NEON data/prism/PRISM_ppt_stable_4kmM3_198101_201907_bil/',
               i, sep=''))
  ppt.i <- extract(x=ras.i, y=cbind(sites$longitude, sites$latitude))
  mat.i <- cbind(sites$site, substring(i, 24, 27), substring(i, 28, 29), ppt.i)
  pptByMonth <- rbind(pptByMonth, mat.i)
  remove(ras.i)
}

pptByMonth <- data.frame(pptByMonth)
names(pptByMonth) <- c('site','year','month','ppt')
pptByMonth$ppt <- as.numeric(pptByMonth$ppt)

# for precip data, each month's data is total precip for that month, so calculate the total per year
pptByYear <- aggregate(pptByMonth$ppt, by=list(pptByMonth$site, pptByMonth$year), FUN=sum, na.rm=T)
names(pptByYear) <- c('site','year','ppt')
# trim to 1981-2010 to match 'norm' dataset
pptByYear <- pptByYear[-which(as.numeric(pptByYear$year)>2010),]

# now calculate the standard deviation in precip across years
sdBySite <- aggregate(pptByYear$ppt, by=list(pptByYear$site), FUN=sd, na.rm=T)
names(sdBySite) <- c('site','ppt.sd')


# get full list of raster files for prism historical temperature data
temp.files <- list.files('/Users/clunch/Dropbox/data/NEON data/prism/PRISM_tmean_stable_4kmM3_198101_201907_bil/')
temp.bil <- temp.files[grep('bil.bil', temp.files)]
temp.bil <- temp.bil[-grep('aux.xml', temp.bil)]

# loop over the list of rasters, extracting data at NEON site locations from each raster
tempByMonth <- character()
for(i in temp.bil) {
  ras.i <- raster(paste('/Users/clunch/Dropbox/data/NEON data/prism/PRISM_tmean_stable_4kmM3_198101_201907_bil/',
                        i, sep=''))
  ppt.i <- extract(x=ras.i, y=cbind(sites$longitude, sites$latitude))
  mat.i <- cbind(sites$site, substring(i, 26, 29), substring(i, 30, 31), ppt.i)
  tempByMonth <- rbind(tempByMonth, mat.i)
  remove(ras.i)
}

tempByMonth <- data.frame(tempByMonth)
names(tempByMonth) <- c('site','year','month','temp')
tempByMonth$temp <- as.numeric(tempByMonth$temp)

# calculate mean temperature per year
tempByYear <- aggregate(tempByMonth$temp, by=list(tempByMonth$site, tempByMonth$year), FUN=mean, na.rm=T)
names(tempByYear) <- c('site','year','temp')
# trim to 1981-2010 to match 'norm' dataset
tempByYear <- tempByYear[-which(as.numeric(tempByYear$year)>2010),]

# now calculate the standard deviation in temperature across years
sdTBySite <- aggregate(tempByYear$temp, by=list(tempByYear$site), FUN=sd, na.rm=T)
names(sdTBySite) <- c('site','temp.sd')

sdBySite <- cbind(sdBySite, sdTBySite$temp.sd)
names(sdBySite)[3] <- 'temp.sd'

# combine files to get single data frame with mean and sd of both temp and precip
site.clim <- cbind(site.clim, sdBySite[,c('ppt.sd','temp.sd')])
site.clim$ppt.30yr.mean <- as.numeric(site.clim$ppt.30yr.mean)

# plot MAT and MAP with standard deviation bars
g <- ggplot(site.clim, aes(x=temp.30yr.mean, y=ppt.30yr.mean, 
                           xmin=temp.30yr.mean-temp.sd, xmax=temp.30yr.mean+temp.sd,
                           ymin=ppt.30yr.mean-ppt.sd, ymax=ppt.30yr.mean+ppt.sd)) + geom_errorbar() + geom_errorbarh() + geom_point() + xlab('Mean annual temperature (C)') + ylab('Mean annual precipitation (mm)')
g

