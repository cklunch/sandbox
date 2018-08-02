library(neonUtilities)
library(geoNEON)
library(raster)
library(rhdf5)
library(ggplot2)
options(stringsAsFactors = F)

# first stack data downloaded from portal
stackByTable("/Users/clunch/Desktop/NEON_par.zip")

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
zipsByProduct(dpID="DP4.00200.001", site="BART", 
              package="basic", savepath="/Users/clunch/Desktop")

# get AOP data by site by year - do not run command, 140 MB
byFileAOP("DP3.30015.001", site="HOPB", 
          year="2017", check.size=T)

# --------
# this ends the neonUtilities section
# --------

# start with PAR - read in 30 min file
par30 <- read.delim("/Users/clunch/Desktop/NEON_par/stackedFiles/PARPAR_30min.csv", sep=",")
View(par30)
# first 4 columns are added by stackByTable()
# the rest are defined in variables file
# open variables file, look at definitions, units

# explain tower levels and plot


# if you want more info: pull up ATBDs (there are 5)

# 2: veg, 3: EC, 4: raster

