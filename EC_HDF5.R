source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
library(rhdf5)

# look at structure of file
unde <- "/Users/clunch/Desktop/filesToStack00200/NEON.D05.UNDE.DP4.00200.001.2017-09.expanded.20180522T213225Z/NEON.D05.UNDE.DP4.00200.001.nsae.2017-09-01.expanded.h5"
h5ls(unde)

# extract and plot CO2 concentration at 3rd tower level, 30 minute
co2 <- h5read(unde, "/UNDE/dp01/data/co2Stor/000_030_30m/rtioMoleDryCo2")
dt <- substring(as.character(co2$timeEnd), 1, 19)
dt <- as.POSIXct(dt, format="%Y-%m-%dT%H:%M:%S", tz="GMT")
plot(co2$mean~dt, type="l")

h5readAttributes(unde,"/UNDE/dp01/data/co2Stor/000_030_30m/rtioMoleDryCo2")

# NEE data
nee <- h5read(unde, "/UNDE/dp04/data/fluxCo2/nsae")
dt <- substring(as.character(nee$timeEnd), 1, 19)
dt <- as.POSIXct(dt, format="%Y-%m-%dT%H:%M:%S", tz="GMT")
plot(nee$flux~dt, type="l")

# join NEE data with quality & uncertainty - some are missing? try out just for storage
stor <- h5read(unde, "/UNDE/dp04/data/fluxCo2/stor")
stor.q <- h5read(unde, "/UNDE/dp04/qfqm/fluxCo2/stor")

# read in fluxnet data for comparison
metolius.daily <- read.delim("/Users/clunch/Dropbox/data/FLUXNET/FLX_US-Me2_FLUXNET2015_SUBSET_2002-2014_1-3/FLX_US-Me2_FLUXNET2015_SUBSET_DD_2002-2014_1-3.csv",
           sep=",")



