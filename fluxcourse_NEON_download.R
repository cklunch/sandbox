# Preparatory NEON data download for flux course
# You'll need to be using R v3.4 or higher

# Install neonUtilities even if you've installed it before!
# We released a new version, v1.3.0, on July 6
install.packages('neonUtilities')
library(neonUtilities)

# PLACEHOLDER! Put in a logical file path for your machine
# This should be a place where you can put ~750 MB of data
filepath <- '/User/Data'

# This function will download the data. Don't worry about
# how it works or what the inputs mean! I'll go over that 
# on Friday.
zipsByProduct(dpID='DP4.00200.001', package='basic', 
              site=c('NIWO', 'HARV'), 
              startdate='2018-06', enddate='2018-07',
              savepath=filepath, 
              check.size=F)
