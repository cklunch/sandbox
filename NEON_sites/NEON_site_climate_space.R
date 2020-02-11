# script to calculate mean annual temperature and mean annual precipitation for NEON sites
# also calculates variance in MAT and MAP
# using PRISM 4km normals (1981-2010) and recent years (1981-2019) datasets, accessed 2020-02-03
# Alaska, Hawaii, and Puerto Rico are separate datasets. Accessed 2020-02-04

options(stringsAsFactors = F)
library(raster)
library(httr)
library(jsonlite)
library(SDMTools)

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

ppt.norm <- raster('/Users/clunch/Dropbox/data/NEON data/prism/PRISM_ppt_30yr_normal_4kmM2_all_bil/PRISM_ppt_30yr_normal_4kmM2_annual_bil.bil')
ppt.site <- extract(x=ppt.norm, y=cbind(sites$longitude, sites$latitude))

site.clim <- cbind(sites$site, ppt.site)
site.clim <- data.frame(site.clim)
names(site.clim) <- c('site','ppt.30yr.mean')
site.clim$ppt.30yr.mean <- as.numeric(site.clim$ppt.30yr.mean)*25.4

temp.norm <- raster('/Users/clunch/Dropbox/data/NEON data/prism/PRISM_tmean_30yr_normal_4kmM2_annual_bil/PRISM_tmean_30yr_normal_4kmM2_annual_bil.bil')
temp.site <- extract(x=temp.norm, y=cbind(sites$longitude, sites$latitude))
site.clim <- cbind(site.clim, temp.site)
names(site.clim)[3] <- 'temp.30yr.mean'

plot(site.clim$ppt.30yr.mean~site.clim$temp.30yr.mean, pch=20, tck=0.01,
     xlab='Mean annual temperature (C)', ylab='Mean annual rainfall (mm)')


