library(neonUtilities)
library(raster)

zipsByProduct(dpID='DP4.00200.001', site='CLBJ', startdate='2019-04', enddate='2019-04',
              package='expanded', check.size=F, release='RELEASE-2022', 
              savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))
ftCLBJ <- footRaster('/Users/clunch/Desktop/filesToStack00200/NEON.D11.CLBJ.DP4.00200.001.2019-04.expanded.20220120T173946Z.RELEASE-2022/NEON.D11.CLBJ.DP4.00200.001.nsae.2019-04-19.expanded.20211216T042629Z.h5')
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
ndvi <- raster::merge(ndvi1, ndvi2)

plot(ndvi)
plot(foot, col=terrain.colors(5), alpha=0.7, add=T)

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
flight.dates <- read.csv('/Users/clunch/Downloads/FlightDates.csv')
site.dates <- flight.dates[grep('NOGP', flight.dates$YearSiteVisit),]
ex.dates <- substring(site.dates$FlightDate, 1, 8)
hy.dates <- paste(substring(ex.dates, 1, 4), substring(ex.dates, 5, 6),
                  substring(ex.dates, 5, 6), sep='-')
months <- substring(hy.dates, 1, 7)
months <- unique(months)

for(i in 4:length(months)) {

  zipsByProduct(dpID='DP4.00200.001', site='NOGP', startdate=months[i], enddate=months[i],
                package='expanded', check.size=F, release='RELEASE-2022', 
                savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))
  
  fl <- list.files(fluxpath, full.names=T, recursive=T)
  utils::unzip(fl, exdir=fluxpath)
  fls <- list.files(fluxpath, pattern=paste(hy.dates[grep(months[i], hy.dates)], collapse="|"), 
                    full.names=T, recursive=T)
  lapply(fls, R.utils::gunzip)
  fls <- list.files(fluxpath, pattern='[.]h5$', full.names=T, recursive=T)
  
  ftStack <- footRaster(fls)
  foot <- ftStack$NOGP.summary
  
  flux <- stackEddy(fls, level='dp04')
  plot(flux$NOGP$data.fluxCo2.nsae.flux~flux$NOGP$timeEnd, pch=20)

  byTileAOP(dpID='DP3.30026.001', site='NOGP', year=substring(months[i], 1, 4),
            easting=c(extent(foot)[1], extent(foot)[2], extent(foot)[2], extent(foot)[1]),
            northing=c(extent(foot)[3], extent(foot)[4], extent(foot)[3], extent(foot)[4]), 
            check.size=F, savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))
  afls <- list.files(aoppath, pattern='NOGP(.*)zip$', full.names=T, recursive=T)
  lapply(afls, utils::unzip, exdir=dirname(afls[1]))
  afls <- list.files(aoppath, pattern='NOGP(.*)_NDVI.tif$', full.names=T, recursive=T)
  
}
