devtools::install_github('NEONScience/NEON-utilities/neonUtilities', ref='eddy')
library(neonUtilities)

# get some data
# change savepath to something on your machine, modify filepaths accordingly in commands below
# portal downloads are also OK
zipsByProduct(dpID="DP4.00200.001", package="basic", 
              site=c("BONA", "CPER"), startdate="2017-12", enddate="2018-02",
              savepath="/Users/clunch/Desktop", check.size=F)

# merge the dp04 data by site
# same syntax works for dp03 and dp02
flux <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200/", level="dp04")
View(flux$CPER)

# for dp01, have to put in an averaging interval to use and a vector of variable names
# you can put in these inputs for dp02-4, but they'll be ignored

# what variables are available?
metaEC <- getVarsEC("/Users/clunch/Desktop/filesToStack00200/NEON.D10.CPER.DP4.00200.001.nsae.2017-12.basic.h5")
View(metaEC)

# let's get dp01 isotope data
iso <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200/", level="dp01",
               avg=30, var=c("dlta13CCo2", "dlta18OH2o", "dlta2HH2o"))
View(iso$BONA)

