level <- "dp01"
filepath <- "/Users/clunch/Desktop/filesToStack00200/NEON.D01.HARV.DP4.00200.001.nsae.2018-07.basic.h5"
var <- c("veloXaxsErth")
avg <- 30
var <- NA
avg <- NA

library(neonUtilities)
zipsByProduct(dpID="DP4.00200.001", package="basic", 
              site=c("BONA", "DEJU"), startdate="2017-12", enddate="2018-02",
              savepath="/Users/clunch/Desktop", check.size=F)

# if level=dp04, var and avg are ignored
flux <- stackEddy(filepath="/Users/clunch/Desktop/filesToStack00200/",
                    level="dp04", var=NA, avg=NA)

prof <- stackEddy(filepath="/Users/clunch/Desktop/filesToStack00200/",
                level="dp03", var=NA, avg=NA)

temp.prof <- stackEddy(filepath="/Users/clunch/Desktop/filesToStack00200/",
                level="dp02", var=NA, avg=NA)

raw <- stackEddy(filepath="/Users/clunch/Desktop/filesToStack00200/NEON.D13.NIWO.DP4.00200.001.nsae.2018-07.basic.h5",
                level="dp01", var=NA, avg=30)

raw.iso <- stackEddy(filepath="/Users/clunch/Desktop/filesToStack00200/NEON.D13.NIWO.DP4.00200.001.nsae.2018-07.basic.h5",
                 level="dp01", var=c("rtioMoleDry12CCo2","rtioMoleDry13CCo2"), avg=9)

isoC <- stackEddy(filepath="/Users/clunch/Desktop/filesToStack00200/",
               level="dp01", var=c("dlta13CCo2"), avg=30)


filepath <- "/Users/clunch/Desktop/filesToStack00200/NEON.D19.BONA.DP4.00200.001.nsae.2017-12.basic.h5"
ec.m <- getVarsEC(filepath="/Users/clunch/Desktop/filesToStack00200/NEON.D19.BONA.DP4.00200.001.nsae.2017-12.basic.h5")


attributes(tableList$`NEON.D10.CPER.DP4.00200.001.nsae.2018-02.basic`)
attributes(tableList$`NEON.D10.CPER.DP4.00200.001.nsae.2018-02.basic`$`CPER/dp01/data/co2Stor/000_010_02m/rtioMoleDryCo2`)
attributes(tableList$`NEON.D10.CPER.DP4.00200.001.nsae.2018-02.basic`$`CPER/dp01/data/co2Stor/000_010_02m/rtioMoleDryCo2`$mean)


# from portal download
flux <- stackEddy(filepath="/Users/clunch/Desktop/NEON_eddy-flux.zip",
                level="dp04", var=NA, avg=NA)


# EXPANDED PACKAGE!!!!!
zipsByProduct(dpID="DP4.00200.001", package="expanded", 
              site=c("BONA", "DEJU"), startdate="2017-12", enddate="2018-02",
              savepath="/Users/clunch/Desktop", check.size=F)
zipsByProduct(dpID="DP4.00200.001", package="expanded", 
              site="ABBY", startdate="2018-07", enddate="2018-07",
              savepath="/Users/clunch/Desktop/expanded", check.size=F)
filepath <- "/Users/clunch/Desktop/expanded/filesToStack00200"
ex.m <- getVarsEddy(filepath="/Users/clunch/Desktop/filesToStack00200/NEON.D19.BONA.DP4.00200.001.nsae.2017-12-01.expanded.h5")
flux.ex <- stackEddy(filepath="/Users/clunch/Desktop/filesToStack00200/",
                level="dp04", var=NA, avg=NA)

prof.ex <- stackEddy(filepath="/Users/clunch/Desktop/filesToStack00200/",
                level="dp03", var=NA, avg=NA)

temp.prof.ex <- stackEddy(filepath="/Users/clunch/Desktop/filesToStack00200/",
                     level="dp02", var=NA, avg=NA)

isoC <- stackEddy(filepath="/Users/clunch/Desktop/filesToStack00200/",
                level="dp01", var=c("dlta13CCo2"), avg=30)


