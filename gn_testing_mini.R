library(devtools)
library(neonUtilities)
library(geoNEON)
setwd("/Users/clunch/GitHub/NEON-geolocation/geoNEON")
check() # build and test package locally - run every time code changes
test() # only run tests - happens as part of check(), but can run independently if needed
install('.') # after check() passes, run to install current version

# examples/snippets for local ad hoc testing
loc <- getLocBySite('ARIK', type='AQU')
loc <- getLocBySite('SYCA', type='all', history=T, token=Sys.getenv('NEON_TOKEN'))

loc <- getLocBySite('BART', type='TOS')


# BLAN location conversion - div test case
div <- loadByProduct('DP1.10058.001', site='BLAN', 
                     startdate='2023-01', package='expanded',
                     include.provisional=F, check.size=F,
                     token=Sys.getenv('NEON_TOKEN'))
div1m2loc <- getLocTOS(div$div_1m2Data, dataProd='div_1m2Data',
                       token=Sys.getenv('NEON_TOKEN'))

div1m2loc <- getLocTOS(div$div_1m2Data, dataProd='div_1m2Data',
                       convertBLAN=T, token=Sys.getenv('NEON_TOKEN'))



