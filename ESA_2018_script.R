library(neonUtilities)
library(geoNEON)
library(rhdf5)
library(raster)
options(stringsAsFactors = F)

# first stack the files we downloaded from the portal
stackByTable("/Users/clunch/Desktop/NEON_par.zip")

# show contents of new folder; save details for later
