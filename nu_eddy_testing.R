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
              savepath='/Users/clunch/Desktop')
flux <- stackEddy('/Users/clunch/Desktop/filesToStack00200/', level='dp04')
iso <- stackEddy('/Users/clunch/Desktop/NEON_eddy-flux.zip', level='dp01', 
                 var=c('rtioMoleDryCo2','dlta13CCo2'), avg=30)
