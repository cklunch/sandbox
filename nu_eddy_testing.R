library(neonUtilities)
library(devtools)
setwd('/Users/clunch/GitHub/NEON-utilities/neonUtilities/')
install('.')

flux <- stackEddy('/Users/clunch/Desktop/filesToStack00200KONZ/', level='dp04')
iso <- stackEddy('/Users/clunch/Desktop/filesToStack00200/', level='dp01', 
                 var=c('rtioMoleDryCo2','dlta13CCo2'), avg=30)

ras <- footRaster('/Users/clunch/Desktop/filesToStack00200KONZ/NEON.D06.KONZ.DP4.00200.001.nsae.2018-04-19.expanded.h5')
ras <- footRaster('/Users/clunch/Desktop/KONZmini/')
raster::plot(ras$KONZ.summary)

zipsByProduct(dpID='DP4.00200.001', site='WREF', startdate='2018-07', enddate='2018-08',
              package='expanded', savepath='/Users/clunch/Desktop')
flux <- stackEddy('/Users/clunch/Desktop/filesToStack00200/', level='dp04')
iso <- stackEddy('/Users/clunch/Desktop/NEON_eddy-flux.zip', level='dp01', 
                 var=c('rtioMoleDryCo2','dlta13CCo2'), avg=30)

ras <- footRaster('/Users/clunch/Desktop/filesToStack00200WREF/')
raster::plot(ras$WREF.summary)
raster::filledContour(ras$WREF.summary, col=topo.colors(24),
                      xlim=c(580000,582500), ylim=c(5073500,5076000))

raster::filledContour(ras$NEON.D16.WREF.DP4.00200.001.nsae.2018.07.01.expanded.WREF.dp04.data.foot.grid.turb.20180701T110000Z, col=topo.colors(24),
                      xlim=c(580000,582500), ylim=c(5073500,5076000))

raster::filledContour(ras$NEON.D16.WREF.DP4.00200.001.nsae.2018.07.01.expanded.WREF.dp04.data.foot.grid.turb.20180701T143000Z, 
                      col=topo.colors(24),
                      xlim=c(580000,582500), ylim=c(5073500,5076000))

