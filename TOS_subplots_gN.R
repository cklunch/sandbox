# compare locations calculated by RELEASE-2023 and RELEASE-2024

library(neonUtilities)
library(geoNEON)

# table of DPIDs and table names to be checked
dps <- read.csv('/Users/clunch/GitHub/sandbox/TOS_subplot_prods.csv')

l23 <- loadByProduct('DP1.10033.001', 
                     site='HARV', 
                     release='RELEASE-2023',
                     startdate='2021-01', 
                     enddate='2021-12',
                     check.size=F,
                     token=Sys.getenv('NEON_TOKEN'))

l24 <- loadByProduct('DP1.10033.001', 
                     site='HARV', 
                     release='RELEASE-2024',
                     startdate='2021-01', 
                     enddate='2021-12',
                     check.size=F,
                     token=Sys.getenv('NEON_TOKEN'))

g23 <- getLocTOS(l23$ltr_pertrap, 
                 'ltr_pertrap',
                 token=Sys.getenv('NEON_TOKEN'))

g24 <- getLocTOS(l24$ltr_pertrap, 
                 'ltr_pertrap',
                 token=Sys.getenv('NEON_TOKEN'))


