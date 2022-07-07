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
site.dates <- flight.dates[grep('NOGP', flight.dates$YearSiteVisit),]
ex.dates <- substring(site.dates$FlightDate, 1, 8)
hy.dates <- paste(substring(ex.dates, 1, 4), substring(ex.dates, 5, 6),
                  substring(ex.dates, 7, 8), sep='-')
months <- substring(hy.dates, 1, 7)
months <- unique(months)

comp <- matrix(data=NA, nrow=0, ncol=4)
comp <- data.frame(comp)
names(comp) <- c('sm','nee','num.mis.nee','ndvi')

for(i in 4:length(months)) {

  zipsByProduct(dpID='DP4.00200.001', site='NOGP', startdate=months[i], enddate=months[i],
                package='expanded', check.size=F, #release='RELEASE-2022', 
                savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))
  
  fl <- list.files(fluxpath, pattern='[.]zip$', full.names=T, recursive=T)
  lapply(fl, utils::unzip, exdir=fluxpath)
  fls <- list.files(fluxpath, pattern=paste(hy.dates[grep(months[i], hy.dates)], collapse="|"), 
                    full.names=T, recursive=T)
  fls <- grep('NOGP', fls, value=T)
  lapply(fls, R.utils::gunzip, overwrite=T, remove=T)
  fls <- list.files(fluxpath, pattern='[.]h5$', full.names=T, recursive=T)
  fls <- grep('NOGP', fls, value=T)
  fls <- grep(months[i], fls, value=T)
  
  ftStack <- footRaster(fls)
  foot <- ftStack$NOGP.summary
  
  flux <- stackEddy(fls, level='dp04')
  try(plot(flux$NOGP$data.fluxCo2.nsae.flux~flux$NOGP$timeEnd, pch=20))

  wid <- extent(foot)[2] - extent(foot)[1]
  num <- floor(wid/1000)
  xcoord <- c(extent(foot)[1], extent(foot)[1]+I(1000*1:num), extent(foot)[2])
  ycoord <- c(extent(foot)[3], extent(foot)[3]+I(1000*1:num), extent(foot)[4])
  
  byTileAOP(dpID='DP3.30026.001', site='NOGP', year=substring(months[i], 1, 4),
            easting=expand.grid(xcoord, ycoord)$Var1,
            northing=expand.grid(xcoord, ycoord)$Var2, 
            check.size=F, savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))
  afls <- list.files(aoppath, pattern='NOGP(.*)zip$', full.names=T, recursive=T)
  afls <- grep(substring(months[i], 1, 4), afls, value=T)
  lapply(afls, utils::unzip, exdir=dirname(afls[1]))
  afls <- list.files(aoppath, pattern='NOGP(.*)_NDVI.tif$', full.names=T, recursive=T)
  
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
  
  comp <- rbind(comp, c(months[i], sum(flux$NOGP$data.fluxCo2.nsae.flux, na.rm=T),
                        length(which(is.na(flux$NOGP$data.fluxCo2.nsae.flux) | 
                                       flux$NOGP$data.fluxCo2.nsae.flux=='NaN')),
                        w.ndvi))

}

# already downloaded
fluxlist <- list(length(months))
ndvilist <- list(length(months))
for(i in 1:length(months)) {
  
  fls <- list.files(fluxpath, pattern=paste(hy.dates[grep(months[i], hy.dates)], collapse="|"), 
                    full.names=T, recursive=T)
  fls <- grep('[.]h5$', fls, value=T)

  ftStack <- footRaster(fls)
  foot <- ftStack$JORN.summary
  
  flux <- stackEddy(fls, level='dp04')
  try(plot(flux$JORN$data.fluxCo2.nsae.flux~flux$JORN$timeEnd, pch=20))
  fluxlist[[i]] <- flux$JORN

  afls <- list.files(aoppath, pattern='JORN(.*)_NDVI.tif$', full.names=T, recursive=T)
  afls <- grep(substring(months[i], 1, 4), afls, value=T)
  
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
  
  ndvilist[[i]] <- ndvi.foot

  comb <- foot.ndvi*ndvi.foot
  w.ndvi <- cellStats(comb, stat='sum', na.rm=T)
  
  comp <- rbind(comp, c(months[i], 
                        sum(flux$JORN$data.fluxCo2.nsae.flux, na.rm=T)/length(hy.dates[grep(months[i], hy.dates)]),
                        length(which(is.na(flux$JORN$data.fluxCo2.nsae.flux) | 
                                       flux$JORN$data.fluxCo2.nsae.flux=='NaN')),
                        w.ndvi))

}

