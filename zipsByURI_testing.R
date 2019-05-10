library(devtools)
setwd("~/GitHub/NEON-utilities/neonUtilities")
install(".")
library(neonUtilities)

zipsByProduct(dpID="DP4.00131.001", package="expanded", savepath="/Users/clunch/Desktop", check.size=F)
stackByTable("/Users/clunch/Desktop/filesToStack00131", folder=T)
zipsByURI("/Users/clunch/Desktop/filesToStack00131/stackedFiles")

zipsByProduct(dpID="DP1.10081.001", package="expanded", savepath="/Users/clunch/Desktop", check.size=F)
stackByTable("/Users/clunch/Desktop/filesToStack10081", folder=T)
zipsByURI("/Users/clunch/Desktop/filesToStack10081/stackedFiles")

zipsByProduct(dpID="DP1.10017.001", package="basic", site="WREF", savepath="/Users/clunch/Desktop", check.size=F)
stackByTable("/Users/clunch/Desktop/filesToStack10017", folder=T)
zipsByURI("/Users/clunch/Desktop/filesToStack10017/stackedFiles")

zipsByProduct(dpID="DP1.10108.001", package="expanded", site="BARR", savepath="/Users/clunch/Desktop")
stackByTable("/Users/clunch/Desktop/filesToStack10108", folder=T)
zipsByURI("/Users/clunch/Desktop/filesToStack10108/stackedFiles")
