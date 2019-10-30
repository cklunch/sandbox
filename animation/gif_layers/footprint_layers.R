library(neonUtilities)
library(raster)
options(stringsAsFactors = F)

# get AOP tile containing tower
byTileAOP(dpID='DP3.30010.001', site='WREF', year='2018',
          easting=581418, northing=5074637, savepath='/Users/clunch/Desktop')
tl <- stack('/Users/clunch/Desktop/DP3.30010.001/2018/FullSite/D16/2018_WREF_2/L3/Camera/Mosaic/2018_WREF_2_581000_5074000_image.tif')
plotRGB(tl, r=1, g=2, b=3)
# where's the tower?
points(581418, 5074637, pch=19, col='white')

# get flux data
zipsByProduct(dpID='DP4.00200.001', site='WREF', startdate='2018-07',
              enddate='2018-07', savepath='/Users/clunch/Desktop')
d <- getVarsEddy('/Users/clunch/Desktop/filesToStack00200/NEON.D16.WREF.DP4.00200.001.2018-07.basic.20190718T193946Z/NEON.D16.WREF.DP4.00200.001.nsae.2018-07.basic.h5')

# next step: get dimensions of footprint.
# Cell_size <- (DistZaxsLvlMeasTow[length(DistZaxsLvlMeasTow)] + DistZaxsGrndOfst) – DistZaxsDisp
d[grep('DistZaxs', d$name),]
#nada

