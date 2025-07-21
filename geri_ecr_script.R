# Download & Explore, adapted for GERI ECR

# SAY:
# THIS IS AN ADAPTED VERSION OF DOWNLOAD & EXPLORE!
# THIS FUNCTIONALITY IS ALSO AVAILABLE IN PYTHON!

# go to portal, download air temperature DP1.00002.001
# ONAQ & RMNP 2024 Apr-June
# exclude & basic
# show files but don't dig in

library(neonUtilities)
stackByTable('/Users/clunch/Downloads/NEON_temp-air-single.zip')

# show files but don't dig in

# here's how we get the same thing directly in R
# basic package is the default
saat <- loadByProduct(dpID='DP1.00002.001', site=c('ONAQ','RNMP'),
                      startdate='2024-04', enddate='2024-06')
names(saat)
View(saat$SAAT_30min)

