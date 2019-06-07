level <- "dp04"
filepath <- "/Users/clunch/Desktop/filesToStack00200/"
var <- NA
avg <- NA

library(neonUtilities)
zipsByProduct(dpID="DP4.00200.001", package="basic", 
              site=c("BONA", "DEJU"), startdate="2017-12", enddate="2018-02",
              savepath="/Users/clunch/Desktop", check.size=F)

# if level=dp04, var and avg are ignored
flux <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200/",
                    level="dp04", var=NA, avg=NA)

prof <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200/",
                level="dp03", var=NA, avg=30)

filepath <- "/Users/clunch/Desktop/filesToStack00200/NEON.D19.BONA.DP4.00200.001.nsae.2017-12.basic.h5"
getVarsEC(filepath="/Users/clunch/Desktop/filesToStack00200/NEON.D19.BONA.DP4.00200.001.nsae.2017-12.basic.h5")
