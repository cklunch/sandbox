# investigate new photos in old DHP data

library(neonUtilities)

dhp <- loadByProduct('DP1.10017.001', site=c('HEAL','DEJU'), 
                     startdate='2019-01', enddate='2019-12', 
                     release='LATEST', token=Sys.getenv('LATEST_TOKEN'))

dhp23 <- loadByProduct('DP1.10017.001', site=c('HEAL','DEJU'), 
                       startdate='2019-01', enddate='2019-12', 
                       release='current', token=Sys.getenv('NEON_TOKEN'))

dhpdiff <- dhp$dhp_perimagefile[which(!dhp$dhp_perimagefile$imageFileName %in% 
                                        dhp23$dhp_perimagefile$imageFileName),]
any(duplicated(dhp$dhp_perimagefile$subsampleID)) # FALSE

# looking up samples in Postman: transaction date=2022-12-17, changeBy=somFulcrumRequestJob
# new theory: photos had already been uploaded, data got stuck in fulcrum and ingested late

# try the same thing for TEAK
dhp <- loadByProduct('DP1.10017.001', site=c('TEAK'), 
                     startdate='2021-01', enddate='2021-12', 
                     release='LATEST', token=Sys.getenv('LATEST_TOKEN'))

dhp23 <- loadByProduct('DP1.10017.001', site=c('TEAK'), 
                       startdate='2021-01', enddate='2021-12', 
                       release='current', token=Sys.getenv('NEON_TOKEN'))

dhpdiff <- dhp$dhp_perimagefile[which(!dhp$dhp_perimagefile$imageFileName %in% 
                                        dhp23$dhp_perimagefile$imageFileName),]
# transaction date 2022-12-16

