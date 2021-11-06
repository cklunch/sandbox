library(neonUtilities)
library(devtools)
setwd('/Users/clunch/GitHub/NEON-utilities/neonUtilities/')
install('.')

# soil data
zipsByProduct(dpID='DP4.00200.001', site=c('NIWO','HARV'), startdate='2021-04', enddate='2021-05',
              package='basic', savepath='/Users/clunch/Desktop', check.size=F,
              token=Sys.getenv('NEON_TOKEN'))

v <- getVarsEddy('/Users/clunch/Desktop/filesToStack00200/NEON.D13.NIWO.DP4.00200.001.nsae.2021-04.basic.20210506T164647Z.h5')
v <- getVarsEddy('/Users/clunch/Desktop/NEON.D18.TOOL.DP4.00200.001.nsae.2018-07-19.expanded.h5')

st <- stackEddy('/Users/clunch/Desktop/filesToStack00200/', level='dp01', 
                 var=c('temp'), avg=30)
shf <- stackEddy('/Users/clunch/Desktop/filesToStack00200/', level='dp01', 
                var=c('fluxHeatSoil'), avg=30)
nrow(shf$NIWO)

pres <- stackEddy('/Users/clunch/Desktop/filesToStack00200/', level='dp01', 
                 var=c('presAtm'), avg=30)
nrow(pres$NIWO)


# stack by system instead of name
iso <- stackEddy('/Users/clunch/Desktop/filesToStack00200/', level='dp01', 
                 var='isoCo2', avg=30)
# number of rows doesn't match selection by name below. checking for duplicates
ind <- paste(iso$NIWO$horizontalPosition, iso$NIWO$verticalPosition, 
             iso$NIWO$timeBgn, iso$NIWO$timeEnd, sep=".")
d <- which(duplicated(ind)) # no dups

ind13 <- paste(iso13$NIWO$horizontalPosition, iso13$NIWO$verticalPosition, 
             iso13$NIWO$timeBgn, iso13$NIWO$timeEnd, sep=".")
d13 <- which(duplicated(ind13)) # dups!
nrow(iso13$NIWO)-nrow(iso$NIWO)
d13 <- union(which(duplicated(ind13)), which(duplicated(ind13, fromLast=T)))
# difference in rows = # of duplicates

misInd <- iso13$NIWO[which(!ind13 %in% ind),]
dupInd <- iso13$NIWO[d13,]

harv13 <- paste(iso13$HARV$horizontalPosition, iso13$HARV$verticalPosition, 
               iso13$HARV$timeBgn, iso13$HARV$timeEnd, sep=".")
hd13 <- which(duplicated(harv13)) # dups!
misH <- iso13$HARV[hd13,]

# what is going on with the duplicated time stamps?
ad <- which(duplicated(dupInd)) # nada
ld <- apply(dupInd, 2, function(x) {length(which(is.na(x) | x=="" | x=="NaN"))})

# going line by line, there are no duplicates when time stamps are left in time format.
# coercing to character creates duplicates. suggests something is mismatched at the sub-second level.

timeSetChar <- apply(timeSetInit, 2, as.character)
timeSetChar <- as.data.frame(timeSetChar)
cind <- union(which(duplicated(timeSetChar)), which(duplicated(timeSetChar, fromLast=T)))
tsub <- timeSetInit[cind,]

# BOOM
# fix this, it's bring in the mismatched end time stamps:
timeSetTemp <- data.table::as.data.table(timeSet[[q]][,nameSet])
timeSetInit <- data.table::funion(timeSetInit, timeSetTemp)
# and decide: union of variables or intersect?
# union is current behavior, need to retain that for "name" variables
# but should combination of system and name be union or intersect?


# mix and match name and system
iso13d <- stackEddy('/Users/clunch/Desktop/filesToStack00200/', level='dp01', 
                 var=c('isoCo2', 'dlta13CCo2'), avg=30)

iso13d <- stackEddy('/Users/clunch/Desktop/NEON.D18.TOOL.DP4.00200.001.nsae.2018-07-19.expanded.h5', level='dp01', 
                    var=c('isoCo2', 'dlta13CCo2'), avg=30)

# basic stacking
flux <- stackEddy('/Users/clunch/Desktop/filesToStack00200/', level='dp04')
iso13 <- stackEddy('/Users/clunch/Desktop/filesToStack00200/', level='dp01', 
                 var=c('rtioMoleDryCo2','dlta13CCo2'), avg=30)

# footprint rasters
ras <- footRaster('/Users/clunch/Desktop/NEON.D18.TOOL.DP4.00200.001.nsae.2018-07-19.expanded.h5')
raster::plot(ras$TOOL.summary)

zipsByProduct(dpID='DP4.00200.001', site='WREF', startdate='2018-07', enddate='2018-08',
              package='expanded', savepath='/Users/clunch/Desktop')
flux <- stackEddy('/Users/clunch/Desktop/filesToStack00200/', level='dp04')
iso <- stackEddy('/Users/clunch/Desktop/NEON_eddy-flux.zip', level='dp01', 
                 var=c('rtioMoleDryCo2','dlta13CCo2'), avg=30)

ras <- footRaster('/Users/clunch/Desktop/filesToStack00200WREF/')
raster::plot(ras$WREF.summary)
raster::filledContour(ras$WREF.summary, col=topo.colors(24),
                      xlim=c(580000,582500), ylim=c(5073500,5076000))

raster::filledContour(ras$NEON.D16.WREF.DP4.00200.001.nsae.2018.07.01.expanded.WREF.dp04.data.foot.grid.turb.20180701T110000Z, col=topo.colors(24),
                      xlim=c(580000,582500), ylim=c(5073500,5076000))

raster::filledContour(ras$NEON.D16.WREF.DP4.00200.001.nsae.2018.07.01.expanded.WREF.dp04.data.foot.grid.turb.20180701T143000Z, 
                      col=topo.colors(24),
                      xlim=c(580000,582500), ylim=c(5073500,5076000))

