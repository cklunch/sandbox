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

ppt.norm <- raster('/Users/clunch/Dropbox/data/NEON data/prism/PRISM_ppt_30yr_normal_4kmM2_all_bil/PRISM_ppt_30yr_normal_4kmM2_01_bil.bil')
ppt.site <- extract(x=ppt.norm, y=cbind(sites$longitude, sites$latitude))

