# install packages
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
devtools::install_github("NEONScience/NEON-utilities/neonUtilities")

#
library(rhdf5)
library(neonUtilities)
library(plyr)

# try it out
zipsByProduct(dpID="DP4.00200.001", site="BART", package="expanded", savepath="/Users/clunch/Desktop")

stack.co2 <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200BART",
                      site="BART", level="dp04", var="fluxCo2", avg=NA)

stack.h2o.dp02 <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200BART",
                     site="BART", level="dp02", var="h2oStor", avg="30")


