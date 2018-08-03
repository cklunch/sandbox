library(neonUtilities)
library(geoNEON)
library(rhdf5)
library(raster)
options(stringsAsFactors = F)

# first stack the files we downloaded from the portal
stackByTable("/Users/clunch/Desktop/NEON_par.zip")

# show contents of new folder; save details for later

# get veg structure data and stack
zipsByProduct(dpID="DP1.10098.001", site="WREF", package="expanded", 
              savepath="/Users/clunch/Desktop/")
# remember to warn people about check.size
stackByTable("/Users/clunch/Desktop/filesToStack10098", folder=T)

# include avg example or skip?
zipsByProduct(dpID="DP1.00002.001", site="BART", 
              package="basic", avg=30, savepath="/Users/clunch/Desktop")
# this example is still 30 MB, even with only the 30-min

# get EC data, but don't stack because we can't - unzip to show format
# basic or expanded???
zipsByProduct(dpID="DP4.00200.001", site="BART", 
              package="basic", savepath="/Users/clunch/Desktop/EC")

# get AOP data by site by year - do not run command, 140 MB
byFileAOP("DP3.30015.001", site="HOPB", 
          year="2017", check.size=T)

# --------
# this ends the neonUtilities section
# there is a little more in the tutorial, and there's a tutorial for Python
# --------

# start with PAR - read in 30 min file
par30 <- read.delim("/Users/clunch/Desktop/NEON_par/stackedFiles/PARPAR_30min.csv", sep=",")
View(par30)
# first 4 columns are added by stackByTable()
# the rest are defined in variables file
# open variables file, look at definitions, units

# explain tower levels, convert time to time class, plot
# you will spend a lot of time dealing with time stamps!

par30$startDateTime <- as.POSIXct(par30$startDateTime, 
                                  format="%Y-%m-%d T %H:%M:%S Z", 
                                  tz="GMT")

# plot highest tower level PAR
# note tower levels are NOT in meters!
# those of you familiar with ggplot know it offers a much more
# elegant way to do this, but we have a wide range of R 
# familiarities in the room, so I'm not breaking out the ggplot
plot(PARMean~startDateTime, 
     data=par30[which(par30$verticalPosition==60),],
     type="l")

# too much to make sense of, so let's subset to the first few days
parsub <- par30[which(par30$startDateTime<as.POSIXct("2017-09-7T00:00:00Z", 
                                                       format="%Y-%m-%d T %H:%M:%S Z", 
                                                       tz="GMT")),]

# plot highest tower level PAR for the first 6 days of Sept
plot(PARMean~startDateTime, 
     data=parsub[which(parsub$verticalPosition==60),],
     type="l")

# add mid-canopy tower level
lines(PARMean~startDateTime, 
     data=parsub[which(parsub$verticalPosition==30),],
     col="green")

# and an understory tower level
lines(PARMean~startDateTime, 
      data=parsub[which(parsub$verticalPosition==20),],
      col="blue")

# add outPAR
lines(outPARMean~startDateTime, 
      data=parsub[which(parsub$verticalPosition==60),],
      col="orange")

# start over with just the PARMean, and plot it with its uncertainty
# a bit unwieldy and long, skip it if running late?
plot(PARMean~startDateTime, 
     data=parsub[which(parsub$verticalPosition==60),],
     type="l")

# make a separate object with the subset, makes the polygon a lot easier
parsub60 <- parsub[which(parsub$verticalPosition==60),]
polygon(c(parsub60$startDateTime, rev(parsub60$startDateTime)), 
        c(parsub60$PARMean+parsub60$PARExpUncert, 
          rev(parsub60$PARMean-parsub60$PARExpUncert)),
        col=rgb(1,0,0, alpha=0.5), border=NA)



# ggplot interlude -----------
library(ggplot2)
# first plot everything
gg <- ggplot(par30) + 
  aes(startDateTime, PARMean, color=as.factor(verticalPosition)) + 
  geom_line()
gg

# then subset to the first 6 days of september
gg <- ggplot(par30[which(par30$startDateTime<as.POSIXct("2017-09-7T00:00:00Z", 
                                                  format="%Y-%m-%d T %H:%M:%S Z", 
                                                  tz="GMT")),]) + 
  aes(startDateTime, PARMean, color=as.factor(verticalPosition)) + 
  geom_line()
gg
# end ggplot interlude --------

# if you want more info: pull up ATBDs (there are 5)

# Eddy covariance
# this will barely scratch the surface! rhdf5 is your friend, 
# and we are developing functionality for easy flattening
# variable definitions are in readme
ecls <- h5ls("/Users/clunch/Desktop/EC/filesToStack00200/NEON.D01.BART.DP4.00200.001.2017-09.basic.20180424T184516Z/NEON.D01.BART.DP4.00200.001.nsae.2017-09.basic.h5")
View(ecls)
# makes a data frame with the paths to the files in the H5 object
# does not actually load any data into R!
# OK, let's load some data:
co2flux <- h5read("/Users/clunch/Desktop/EC/filesToStack00200/NEON.D01.BART.DP4.00200.001.2017-09.basic.20180424T184516Z/NEON.D01.BART.DP4.00200.001.nsae.2017-09.basic.h5",
              paste(ecls$group[intersect(grep("data/fluxCo2", ecls$group), 
                                         grep("nsae", ecls$name))],
                    ecls$name[intersect(grep("data/fluxCo2", ecls$group), 
                                        grep("nsae", ecls$name))], sep="/"))
View(co2flux)

# convert time stamps - not quite the same as PAR
co2flux$timeBgn <- as.POSIXct(co2flux$timeBgn, 
                                  format="%Y-%m-%d T %H:%M:%OS Z", 
                                  tz="GMT")

plot(flux~timeBgn, data=co2flux, type="l")

# next up: veg structure!
# OS products are simple in that the data generally tabular, and 
# data volumes are low, but they are complex in that almost all
# consist of multiple tables containing information collected at 
# different times in different ways. Complexity in working with 
# OS data involves bringing those data together.
vegmap <- read.delim("/Users/clunch/Desktop/filesToStack10098/stackedFiles/vst_mappingandtagging.csv",
                     sep=",")
View(vegmap)
vegind <- read.delim("/Users/clunch/Desktop/filesToStack10098/stackedFiles/vst_apparentindividual.csv",
                     sep=",")
View(vegind)
# show variables file, validation file
# DPUG, protocol, generic ATBD

# use the geoNEON package to calculate stem locations
# (plot locations are in perplotperyear)
names(vegmap)
vegmap <- geoNEON::def.calc.geo.os(vegmap, "vst_mappingandtagging")
names(vegmap)

# merge mapping and individual measurements (individualID is the linking
# variable, I included the others to avoid having duplicate columns for each of them)
veg <- merge(vegind, vegmap, by=c("individualID","namedLocation",
                                  "domainID","siteID","plotID"))

# map the individuals in plot 85. note coordinates are in m, 
# stemDiameter is in cm
symbols(veg$adjEasting[which(veg$plotID=="WREF_085")], 
        veg$adjNorthing[which(veg$plotID=="WREF_085")], 
        circles=veg$stemDiameter[which(veg$plotID=="WREF_085")]/100, 
        xlab="Easting", ylab="Northing", inches=F)

# look, a couple are on top of each other!
# plot uncertainty in stem location
symbols(veg$adjEasting[which(veg$plotID=="WREF_085")], 
        veg$adjNorthing[which(veg$plotID=="WREF_085")], 
        circles=veg$adjCoordinateUncertainty[which(veg$plotID=="WREF_085")], 
        inches=F, add=T, fg="red")

# end veg structure section

# last data type: remote sensing
# load the tile we downloaded from the portal
chm <- raster("/Users/clunch/Desktop/2017 WREF/FullSite/D16/2017_WREF_1/L3/DiscreteLidar/CanopyHeightModelGtif/NEON_D16_WREF_DP3_580000_5075000_CHM.tif")
plot(chm, col=topo.colors(6))

# this is all we're going to do with the AOP data!
# one of the suggested activities for the next couple of hours is to 
# dig into these data, along with the veg structure data
# in general, the raster package is your friend - it can do most
# things you'd be interested in

