# install packages
source("http://bioconductor.org/biocLite.R")
biocLite("rhdf5")
devtools::install_github("NEONScience/NEON-utilities/neonUtilities")

# load packages
library(rhdf5)
library(neonUtilities)
library(plyr)

# download some data
zipsByProduct(dpID="DP4.00200.001", site="BART", package="expanded", savepath="/Users/clunch/Desktop")

# try out the extracting functions
# (have to source stackEC(), flattenH5EC(), and H5ECtoDF() for this to work)
stack.co2 <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200BART",
                      site="BART", level="dp04", var="fluxCo2", avg=NA)

stack.h2o.dp02 <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200BART",
                     site="BART", level="dp02", var="h2oStor", avg="30")


