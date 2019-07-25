# Install neonUtilities even if you've installed it before!
# You'll need to have the most recent version, v1.3.0
install.packages('neonUtilities')
library(neonUtilities)

# PLACEHOLDER! Put in a logical file path for your machine
# This should be a place where you can put ~750 MB of data
filepath <- '/Users/clunch/Desktop/'

# This function will download the data. Don't worry about
# how it works or what the inputs mean! I'll go over that 
# on Friday.
zipsByProduct(dpID='DP4.00200.001', package='basic', 
              site=c('NIWO', 'HARV'), 
              startdate='2018-06', enddate='2018-07',
              savepath=filepath, 
              check.size=F)

# And another data downlaod:
zipsByProduct(dpID='DP1.00024.001', package='basic', 
              site=c('NIWO', 'HARV'), avg=30,
              startdate='2018-06', enddate='2018-07',
              savepath=filepath,
              check.size=F)

