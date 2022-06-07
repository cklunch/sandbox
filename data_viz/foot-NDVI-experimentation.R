library(neonUtilities)
library(raster)

zipsByProduct(dpID='DP4.00200.001', site='CLBJ', startdate='2019-04', enddate='2019-04',
              package='expanded', check.size=F, release='RELEASE-2022', 
              savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))
ftCLBJ <- footRaster('/Users/clunch/Desktop/filesToStack00200/NEON.D11.CLBJ.DP4.00200.001.2019-04.expanded.20220120T173946Z.RELEASE-2022/NEON.D11.CLBJ.DP4.00200.001.nsae.2019-04-19.expanded.20211216T042629Z.h5.gz')
raster::filledContour(ftCLBJ$CLBJ.summary, col=topo.colors(24), 
                      levels=0.001*0:24)
raster::filledContour(ftCLBJ$CLBJ.summary, 
                      col=topo.colors(24), 
                      levels=0.001*0:24,
                      xlim=c(632500,633500),
                      ylim=c(3696400,3697000))

footMost <- raster::calc(ftCLBJ$CLBJ.summary, fun=function(x){ x[x < 0.0005] <- 0; return(x)})
foot <- raster::trim(footMost, values=0)
raster::filledContour(foot, col=topo.colors(24), 
                      levels=0.001*0:24)

byTileAOP(dpID='DP3.30026.001', site='CLBJ', year=2019,
          easting=c(extent(foot)[1], extent(foot)[2], extent(foot)[2], extent(foot)[1]),
          northing=c(extent(foot)[3], extent(foot)[4], extent(foot)[3], extent(foot)[4]), 
          check.size=F, savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))

nee1 <- raster('/Users/clunch/Desktop/DP3.30026.001/neon-aop-products/2019/FullSite/D11/2019_CLBJ_4/L3/Spectrometer/VegIndices/NEON_D11_CLBJ_DP3_632000_3696000_VegIndices/NEON_D11_CLBJ_DP3_632000_3696000_NDVI.tif')
nee2 <- raster('/Users/clunch/Desktop/DP3.30026.001/neon-aop-products/2019/FullSite/D11/2019_CLBJ_4/L3/Spectrometer/VegIndices/NEON_D11_CLBJ_DP3_633000_3696000_VegIndices/NEON_D11_CLBJ_DP3_633000_3696000_NDVI.tif')
ndvi <- raster::merge(nee1, nee2)

plot(ndvi)
plot(foot, col=terrain.colors(5), alpha=0.7, add=T)

ndvi.foot <- crop(ndvi, extent(foot))
plot(ndvi.foot)
