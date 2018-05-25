source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")

#
library(rhdf5)
library(neonUtilities)
library(plyr)

# try it out
zipsByProduct(dpID="DP4.00200.001", site="BART", package="expanded", savepath="/Users/clunch/Desktop")

# manually unzipped before moving forward

turb30 <- flattenH5EC(filepath="/Users/clunch/Desktop/filesToStack00200/NEON.D01.BART.DP4.00200.001.2017-09.expanded.20180424T184516Z/NEON.D01.BART.DP4.00200.001.nsae.2017-09-29.expanded.h5",
            site="BART", level="dp01", var="co2Turb", avg=30)

h2o.l2 <- flattenH5EC(filepath="/Users/clunch/Desktop/filesToStack00200/NEON.D01.BART.DP4.00200.001.2017-09.expanded.20180424T184516Z/NEON.D01.BART.DP4.00200.001.nsae.2017-09-29.expanded.h5",
                      site="BART", level="dp02", var="h2oStor", avg=30)

# no data in this one
shf30 <- flattenH5EC(filepath="/Users/clunch/Desktop/filesToStack00200/NEON.D01.BART.DP4.00200.001.2017-09.expanded.20180424T184516Z/NEON.D01.BART.DP4.00200.001.nsae.2017-09-29.expanded.h5",
                   site="BART", level="dp01", var="fluxHeatSoil", avg=30)

isoC <- flattenH5EC(filepath="/Users/clunch/Desktop/filesToStack00200/NEON.D01.BART.DP4.00200.001.2017-09.expanded.20180424T184516Z/NEON.D01.BART.DP4.00200.001.nsae.2017-09-29.expanded.h5",
                    site="BART", level="dp01", var="isoCo2", avg=9)

nee <- flattenH5EC(filepath="/Users/clunch/Desktop/filesToStack00200/NEON.D01.BART.DP4.00200.001.2017-09.expanded.20180424T184516Z/NEON.D01.BART.DP4.00200.001.nsae.2017-09-29.expanded.h5",
                   site="BART", level="dp04", var="fluxCo2", avg=NA)

temp.l3 <- flattenH5EC(filepath="/Users/clunch/Desktop/filesToStack00200/NEON.D01.BART.DP4.00200.001.2017-09.expanded.20180424T184516Z/NEON.D01.BART.DP4.00200.001.nsae.2017-09-29.expanded.h5",
                       site="BART", level="dp03", var="tempStor", avg=NA)

