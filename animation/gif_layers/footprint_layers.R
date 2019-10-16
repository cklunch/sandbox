library(neonUtilities)
library(raster)
options(stringsAsFactors = F)

byTileAOP(dpID='DP3.30010.001', site='WREF', year='2018',
          easting=581418, northing=5074637, savepath='/Users/clunch/Desktop')
tower.tile <- raster('/Users/clunch/Desktop/DP3.30010.001/2018/FullSite/D16/2018_WREF_2/L3/Camera/Mosaic/2018_WREF_2_581000_5074000_image.tif')
tl <- stack(tower.tile)
plotRGB(tl, r=3, g=2, b=1) # doesn't work

