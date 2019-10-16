library(neonUtilities)
library(raster)
options(stringsAsFactors = F)

byTileAOP(dpID='DP3.30010.001', site='WREF', year='2018',
          easting=581418, northing=5074637, savepath='/Users/clunch/Desktop')
tl <- stack('/Users/clunch/Desktop/DP3.30010.001/2018/FullSite/D16/2018_WREF_2/L3/Camera/Mosaic/2018_WREF_2_581000_5074000_image.tif')
plotRGB(tl, r=1, g=2, b=3)
# where's the tower?
points(581418, 5074637, pch=19, col='white')

# next step: get dimensions of footprint.
