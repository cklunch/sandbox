devtools::install_github("NEONScience/NEON-utilities/neonUtilities", ref="footprint")
library(neonUtilities)

# have expanded package files from a single site here
ft <- footRaster("/Users/clunch/Desktop/expanded/filesToStack00200/")

# get just the summary layer
ft.sum <- raster::subset(ft, 1, drop=T)

# replace 0s with NA - does this help?
ft.sum[ft.sum < 0.0001] <- NA

raster::filledContour(ft.sum, color.palette=topo.colors)
