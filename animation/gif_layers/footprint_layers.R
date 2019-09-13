library(neonUtilities)
library(raster)
options(stringsAsFactors = F)

byTileAOP(dpID='DP3.30010.001', site='WREF', year='2018',
          easting=581418, northing=5074637, savepath='/Users/clunch/Desktop')
tower.tile <- raster('/Users/clunch/DP3.30010.001/2018/FullSite/D16/2018_WREF_2/L3/Camera/Mosaic/V01/2018_WREF_2_581000_5074000_image.tif')
