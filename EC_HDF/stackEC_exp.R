level <- "dp03"
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
                level="dp03", var=NA, avg=NA)

temp.prof <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200/",
                level="dp02", var=NA, avg=NA)

raw <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200/",
                level="dp01", var=c("rtioMoleDryCo2","rtioMoleDryH2o"), avg=30)

isoC <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200/",
               level="dp01", var=c("dlta13CCo2"), avg=30)


filepath <- "/Users/clunch/Desktop/filesToStack00200/NEON.D19.BONA.DP4.00200.001.nsae.2017-12.basic.h5"
ec.m <- getVarsEC(filepath="/Users/clunch/Desktop/filesToStack00200/NEON.D19.BONA.DP4.00200.001.nsae.2017-12.basic.h5")


# from portal download
flux <- stackEC(filepath="/Users/clunch/Desktop/NEON_eddy-flux.zip",
                level="dp04", var=NA, avg=NA)


# EXPANDED PACKAGE!!!!!
zipsByProduct(dpID="DP4.00200.001", package="expanded", 
              site=c("BONA", "DEJU"), startdate="2017-12", enddate="2018-02",
              savepath="/Users/clunch/Desktop", check.size=F)
ex.m <- getVarsEC(filepath="/Users/clunch/Desktop/filesToStack00200/NEON.D19.BONA.DP4.00200.001.nsae.2017-12-01.expanded.h5")
flux.ex <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200/",
                level="dp04", var=NA, avg=NA)

prof.ex <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200/",
                level="dp03", var=NA, avg=NA)

temp.prof.ex <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200/",
                     level="dp02", var=NA, avg=NA)

isoC <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200/",
                level="dp01", var=c("dlta13CCo2"), avg=30)


