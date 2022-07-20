library(neonUtilities)
library(raster)

zipsByProduct(dpID='DP4.00200.001', site='CLBJ', startdate='2019-04', enddate='2019-04',
              package='expanded', check.size=F, release='RELEASE-2022', 
              savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))
ftCLBJ <- footRaster('/Users/clunch/Desktop/filesToStack00200/NEON.D11.CLBJ.DP4.00200.001.2019-04.expanded.20220120T173946Z.RELEASE-2022/NEON.D11.CLBJ.DP4.00200.001.nsae.2019-04-07.expanded.20211216T042628Z.h5')
raster::filledContour(ftCLBJ$CLBJ.summary, col=topo.colors(24), 
                      levels=0.001*0:24)
raster::filledContour(ftCLBJ$CLBJ.summary, 
                      col=topo.colors(24), 
                      levels=0.001*0:24,
                      xlim=c(632500,633500),
                      ylim=c(3696400,3697000))

footMost <- raster::calc(ftCLBJ$CLBJ.summary, fun=function(x){ x[x < 0.0001] <- 0; return(x)})
foot <- raster::trim(footMost, values=0)
raster::filledContour(foot, col=topo.colors(24), 
                      levels=0.001*0:24)

byTileAOP(dpID='DP3.30026.001', site='CLBJ', year=2019,
          easting=c(extent(foot)[1], extent(foot)[2], extent(foot)[2], extent(foot)[1]),
          northing=c(extent(foot)[3], extent(foot)[4], extent(foot)[3], extent(foot)[4]), 
          check.size=F, savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))

ndvi1 <- raster('/Users/clunch/Desktop/DP3.30026.001/neon-aop-products/2019/FullSite/D11/2019_CLBJ_4/L3/Spectrometer/VegIndices/NEON_D11_CLBJ_DP3_632000_3696000_VegIndices/NEON_D11_CLBJ_DP3_632000_3696000_NDVI.tif')
ndvi2 <- raster('/Users/clunch/Desktop/DP3.30026.001/neon-aop-products/2019/FullSite/D11/2019_CLBJ_4/L3/Spectrometer/VegIndices/NEON_D11_CLBJ_DP3_633000_3696000_VegIndices/NEON_D11_CLBJ_DP3_633000_3696000_NDVI.tif')
ndviCLBJ <- raster::merge(ndvi1, ndvi2)

plot(ndviCLBJ)
plot(ftCLBJ$CLBJ.summary, col=terrain.colors(5), alpha=0.7, add=T)

ndvi.foot <- crop(ndvi, extent(foot))
plot(ndvi.foot)

foot.ndvi <- raster::resample(foot, ndvi.foot)
plot(foot.ndvi, col=terrain.colors(12))
foot.ndvi <- foot.ndvi/cellStats(foot.ndvi, stat='sum', na.rm=T)

wa <- foot.ndvi*ndvi.foot
waa <- cellStats(wa, stat='sum', na.rm=T)

cellStats(foot, stat='sum', na.rm=T)

ndvi.coarse <- resample(ndvi.foot, foot)
plot(ndvi.coarse)
ca <- foot/cellStats(foot, stat='sum', na.rm=T)*ndvi.coarse
caa <- cellStats(ca, stat='sum', na.rm=T)

flux <- stackEddy(c('/Users/clunch/Desktop/filesToStack00200/NEON.D11.CLBJ.DP4.00200.001.2019-04.expanded.20220120T173946Z.RELEASE-2022/NEON.D11.CLBJ.DP4.00200.001.nsae.2019-04-19.expanded.20211216T042629Z.h5',
                    '/Users/clunch/Desktop/filesToStack00200/NEON.D11.CLBJ.DP4.00200.001.2019-04.expanded.20220120T173946Z.RELEASE-2022/NEON.D11.CLBJ.DP4.00200.001.nsae.2019-04-20.expanded.20211216T042702Z.h5'),
                  level='dp04')
plot(flux$CLBJ$data.fluxCo2.nsae.flux~flux$CLBJ$timeEnd, pch=20)
plot(flux$CLBJ$data.fluxCo2.turb.flux~flux$CLBJ$timeEnd, pch=20)


### slight automation

fluxpath <- '/Users/clunch/Desktop/filesToStack00200/'
aoppath <- '/Users/clunch/Desktop/DP3.30026.001/'
flight.dates <- read.csv('/Users/clunch/Downloads/FlightDatesThrough2021.csv')
site.dates <- flight.dates[grep('CLBJ', flight.dates$YearSiteVisit),]
ex.dates <- substring(site.dates$FlightDate, 1, 8)
hy.dates <- paste(substring(ex.dates, 1, 4), substring(ex.dates, 5, 6),
                  substring(ex.dates, 7, 8), sep='-')
months <- substring(hy.dates, 1, 7)
months <- unique(months)

comp <- matrix(data=NA, nrow=0, ncol=4)
comp <- data.frame(comp)
names(comp) <- c('sm','nee','num.mis.nee','ndvi')

for(i in 3:length(months)) {

  zipsByProduct(dpID='DP4.00200.001', site='CLBJ', startdate=months[i], enddate=months[i],
                package='expanded', check.size=F, #release='RELEASE-2022', 
                savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))
  
  fl <- list.files(fluxpath, pattern='[.]zip$', full.names=T, recursive=T)
  lapply(fl, utils::unzip, exdir=fluxpath)
  fls <- list.files(fluxpath, pattern=paste(hy.dates[grep(months[i], hy.dates)], collapse="|"), 
                    full.names=T, recursive=T)
  fls <- grep('CLBJ', fls, value=T)
  lapply(fls, R.utils::gunzip, overwrite=T, remove=T)
  fls <- list.files(fluxpath, pattern='[.]h5$', full.names=T, recursive=T)
  fls <- grep('CLBJ', fls, value=T)
  fls <- grep(months[i], fls, value=T)
  
  ftStack <- footRaster(fls)
  foot <- ftStack$CLBJ.summary
  
  flux <- stackEddy(fls, level='dp04')
  try(plot(flux$CLBJ$data.fluxCo2.nsae.flux~flux$CLBJ$timeEnd, pch=20))

  wid <- extent(foot)[2] - extent(foot)[1]
  num <- floor(wid/1000)
  xcoord <- c(extent(foot)[1], extent(foot)[1]+I(1000*1:num), extent(foot)[2])
  ycoord <- c(extent(foot)[3], extent(foot)[3]+I(1000*1:num), extent(foot)[4])
  
  byTileAOP(dpID='DP3.30026.001', site='CLBJ', year=substring(months[i], 1, 4),
            easting=expand.grid(xcoord, ycoord)$Var1,
            northing=expand.grid(xcoord, ycoord)$Var2, 
            check.size=F, savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))
  afls <- list.files(aoppath, pattern='CLBJ(.*)zip$', full.names=T, recursive=T)
  afls <- grep(substring(months[i], 1, 4), afls, value=T)
  lapply(afls, utils::unzip, exdir=dirname(afls[1]))
  afls <- list.files(aoppath, pattern='CLBJ(.*)_NDVI.tif$', full.names=T, recursive=T)
  
  ndvilist <- list()
  for(j in 1:length(afls)) {
    ndvilist[[j]] <- raster(afls[j])
    if(j==1) {
      ndvi <- ndvilist[[1]]
    } else {
      ndvi <- raster::merge(ndvi, ndvilist[[j]])
    }
  }
  
  ndvi.foot <- crop(ndvi, extent(foot))
  foot.ndvi <- raster::resample(foot, ndvi.foot)
  foot.ndvi <- foot.ndvi/cellStats(foot.ndvi, stat='sum', na.rm=T)
  
  comb <- foot.ndvi*ndvi.foot
  w.ndvi <- cellStats(comb, stat='sum', na.rm=T)
  
  comp <- rbind(comp, c(months[i], sum(flux$CLBJ$data.fluxCo2.nsae.flux, na.rm=T),
                        length(which(is.na(flux$CLBJ$data.fluxCo2.nsae.flux) | 
                                       flux$CLBJ$data.fluxCo2.nsae.flux=='NaN')),
                        w.ndvi))

}


# multi-site, already downloaded
# write out data in more usable form
fluxpath <- '/Users/clunch/Desktop/filesToStack00200/'
aoppath <- '/Users/clunch/Desktop/DP3.30026.001/'
flight.dates <- read.csv('/Users/clunch/Downloads/FlightDatesThrough2021.csv')
site.dates <- flight.dates[grep('KONZ', flight.dates$YearSiteVisit),]
ex.dates <- substring(site.dates$FlightDate, 1, 8)
hy.dates <- paste(substring(ex.dates, 1, 4), substring(ex.dates, 5, 6),
                  substring(ex.dates, 7, 8), sep='-')
sites <- substring(site.dates$YearSiteVisit, 6, 9)
months <- substring(hy.dates, 1, 7)
sfd <- cbind(sites, hy.dates, months)
sfd <- data.frame(sfd)

for(i in unique(sfd$sites)) {
  
  sfd.i <- sfd[which(sfd$sites==i),]
  months <- unique(sfd.i$months)
  
  for(j in 1:length(months)) {

    if(i=='WOOD'){i <- 'DCFS'}
    fls <- list.files(fluxpath, pattern=paste(sfd.i$hy.dates[grep(months[j], 
                                                                sfd.i$hy.dates)], 
                                              collapse="|"), full.names=T, recursive=T)
    if(length(fls)==0) {
      next
    }
    fls <- grep(i, fls, value=T)
    if(length(fls)==0) {
      next
    }
    fls <- grep('[.]h5$', fls, value=T)
    
    ftStack <- footRaster(fls)
    foot <- ftStack[[1]]
    
    flux <- stackEddy(fls, level='dp04')
    flux.dat <- flux[[i]]
    
    if(i=='DCFS'){i <- 'WOOD'}
    afls <- list.files(aoppath, pattern=paste(i, '(.*)_NDVI.tif$', sep=''), 
                       full.names=T, recursive=T)
    afls <- grep(substring(months[j], 1, 4), afls, value=T)
    
    ndvilist <- list()
    for(k in 1:length(afls)) {
      ndvilist[[k]] <- raster(afls[k])
      if(k==1) {
        ndvi <- ndvilist[[1]]
      } else {
        ndvi <- raster::merge(ndvi, ndvilist[[k]])
      }
    }
    
    print(paste(i, months[j], sum(flux.dat$data.fluxCo2.nsae.flux, na.rm=T)))
    write.table(flux.dat, 
                paste('/Users/clunch/Library/CloudStorage/Box-Box/NEON_Lunch/data/fluxcourse_data/flux',
                      i, months[j], '.csv', sep=''), sep=',', row.names=F)
    writeRaster(foot, 
                paste('/Users/clunch/Library/CloudStorage/Box-Box/NEON_Lunch/data/fluxcourse_data/foot',
                      i, months[j], '.grd', sep=''), overwrite=T)
    writeRaster(ndvi, 
                paste('/Users/clunch/Library/CloudStorage/Box-Box/NEON_Lunch/data/fluxcourse_data/ndvi',
                      i, months[j], '.grd', sep=''), overwrite=T)
    
    
  }

}


# next steps
# 1. get entire month (and adjacent month?) for flux data
# 2. merge to single flux data file
# 3. create function to calculate weighted NDVI
# 4. get Bridget to test if rasterio can read .grd files
# 5. find flux-NDVI relationship, pick datasets

for(i in unique(sfd$sites)) {
  
  sfd.i <- sfd[which(sfd$sites==i),]
  
  for(j in unique(sfd.i$months)) {
    
    f <- try(zipsByProduct(dpID='DP4.00200.001', site=i, startdate=j, enddate=j,
                  package='basic', check.size=F, 
                  savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN')))

  }
  
}

flux <- stackEddy('/Users/clunch/Desktop/filesToStack00200/', level='dp04')
flux$DCFS <- cbind(siteID=rep('DCFS', nrow(flux$DCFS)), flux$DCFS)
flux$NOGP <- cbind(siteID=rep('NOGP', nrow(flux$NOGP)), flux$NOGP)
flux$CPER <- cbind(siteID=rep('CPER', nrow(flux$CPER)), flux$CPER)
flux$WOOD <- cbind(siteID=rep('WOOD', nrow(flux$WOOD)), flux$WOOD)
flux$OAES <- cbind(siteID=rep('OAES', nrow(flux$OAES)), flux$OAES)
f.all <- data.table::rbindlist(flux[1:5], fill=T)

write.table(f.all, 
            '/Users/clunch/Library/CloudStorage/Box-Box/NEON_Lunch/data/fluxcourse_neon_data/flux_allSites.csv', 
            sep=',', row.names=F)

f.all <- read.csv('/Users/clunch/Library/CloudStorage/Box-Box/NEON_Lunch/data/fluxcourse_data/flux_allSites.csv')

# get weighted NDVI calculation
foot.weighted <- function(ndvi.raster, foot.raster) {

  ndvi.foot <- crop(ndvi.raster, extent(foot.raster))
  foot.ndvi <- raster::resample(foot.raster, ndvi.foot)
  foot.ndvi <- foot.ndvi/cellStats(foot.ndvi, stat='sum', na.rm=T)
  comb <- foot.ndvi*ndvi.foot
  w.ndvi <- cellStats(comb, stat='sum', na.rm=T)
  return(w.ndvi)
  
}

fpath <- '/Users/clunch/Library/CloudStorage/Box-Box/NEON_Lunch/data/fluxcourse_data'
# loop over sites and years to get footprint-weighted NDVI
ndvi.w <- character()
for(i in unique(sfd$sites)) {
  
  ffls <- list.files(fpath, 'foot', full.names=T)
  afls <- list.files(fpath, 'ndvi', full.names=T)
  ffls <- grep('.grd$', ffls, value=T)
  afls <- grep('.grd$', afls, value=T)

  sfd.i <- sfd[which(sfd$sites==i),]
  
  for(j in unique(sfd.i$months)) {
    
    footfl <- grep(i, ffls, value=T)
    footfl <- grep(j, footfl, value=T)
    if(length(footfl)==0) {next}
    nfl <- grep(i, afls, value=T)
    nfl <- grep(j, nfl, value=T)
    
    foot <- raster(footfl)
    ndvi <- raster(nfl)
    
    nw <- foot.weighted(ndvi, foot)
    ndvi.w <- rbind(ndvi.w, c(i, j, nw))
    
  }
  
}

ndvi.w <- data.frame(ndvi.w)
names(ndvi.w) <- c('site','month','ndvi')
ndvi.w$ndvi <- as.numeric(ndvi.w$ndvi)

write.table(ndvi.w, 
            '/Users/clunch/Library/CloudStorage/Box-Box/NEON_Lunch/data/fluxcourse_data/ndvi_set.csv',
            sep=',', row.names=F)
ndvi.w <- read.csv('/Users/clunch/Library/CloudStorage/Box-Box/NEON_Lunch/data/fluxcourse_data/ndvi_set.csv')

f.all$timeBgn <- as.POSIXct(f.all$timeBgn, tz='GMT', format='%Y-%m-%d %H:%M:%S')
f.all$timeEnd <- as.POSIXct(f.all$timeEnd, tz='GMT', format='%Y-%m-%d %H:%M:%S')

site <- 'WOOD'
startd <- as.POSIXct('2021-06-10', tz='GMT')
endd <- as.POSIXct('2021-06-15', tz='GMT')

f.sub <- f.all[which(f.all$siteID==site & 
                       f.all$timeBgn>=startd &
                       f.all$timeBgn<endd),]

plot(f.sub$data.fluxCo2.nsae.flux~f.sub$timeBgn, pch=20)


# compare flux to ndvi
fl.dt <- read.csv('/Users/clunch/Library/CloudStorage/Box-Box/NEON_Lunch/data/fluxcourse_data/flight_dates.csv')
fl.dt$FlightDate <- as.POSIXct(fl.dt$FlightDate, tz='GMT')

ndvi.f <- ndvi.w[ndvi.w$site %in% fl.dt$Site,]
ndvi.f <- ndvi.f[ndvi.f$month %in% substring(as.character(fl.dt$FlightDate), 1, 7),]
ndvi.f$flux <- rep(NA, nrow(ndvi.f))
ndvi.f$dayflux <- rep(NA, nrow(ndvi.f))
for(i in 1:nrow(fl.dt)) {
  
  f.sub <- f.all[which(f.all$siteID==fl.dt$Site[i] & 
                         f.all$timeBgn>=I(fl.dt$FlightDate[i]-86400) &
                         f.all$timeBgn<I(fl.dt$FlightDate[i]+86400)),]
  fl <- sum(f.sub$data.fluxCo2.nsae.flux, na.rm=T)/3
  fl.d <- sum(f.sub$data.fluxCo2.nsae.flux[which(f.sub$data.fluxCo2.nsae.flux<0)], na.rm=T)/3
  ndvi.f$flux[which(ndvi.f$site==fl.dt$Site[i] & ndvi.f$month==
                      substring(as.character(fl.dt$FlightDate[i]), 1, 7))] <- fl
  ndvi.f$dayflux[which(ndvi.f$site==fl.dt$Site[i] & ndvi.f$month==
                      substring(as.character(fl.dt$FlightDate[i]), 1, 7))] <- fl.d
  
}

ndvi.f <- ndvi.f[-which(is.na(ndvi.f$flux)),]

plot(ndvi.f$flux~ndvi.f$ndvi, pch=20, xlab='NDVI', ylab='NEE')
plot(ndvi.f$dayflux~ndvi.f$ndvi, pch=20, xlab='NDVI', ylab='NEE')

plot(ndvi.f$flux~ndvi.f$ndvi, pch=20, xlab='NDVI', ylab='NEE', type='n')
text(ndvi.f$ndvi, ndvi.f$flux, labels=ndvi.f$site, cex=0.5)

plot(ndvi.f$dayflux~ndvi.f$ndvi, pch=20, xlab='NDVI', ylab='NEE', type='n')
text(ndvi.f$ndvi, ndvi.f$dayflux, labels=ndvi.f$site, cex=0.5)


# next steps:
# 1. rename WOOD to DCFS
# 2. subset to needed files
# 3. write up (!)
