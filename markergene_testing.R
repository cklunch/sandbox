library(neonUtilities)
library(neonOS)

# get data
mmg <- loadByProduct(dpID='DP1.10108.001', package='expanded',
                     check.size = F, token=Sys.getenv('NEON_TOKEN'))

# remove duplicates based on primaryKey rules
mmgr <- removeDups(mmg$mmg_soilRawDataFiles, mmg$variables_10108, 'mmg_soilRawDataFiles')

# records with the same file name
rawDups <- mmgr[union(which(duplicated(mmgr$rawDataFileName)),
                      which(duplicated(mmgr$rawDataFileName, fromLast=T))),]

# records with unique file names
notDups <- mmgr[which(!mmgr$uid %in% rawDups$uid),]

# are there samples with both a unique file name and a duplicated file name?
sampDups <- rawDups[intersect(which(rawDups$dnaSampleID %in% notDups$dnaSampleID),
                              which(rawDups$internalLabID %in% notDups$internalLabID)),]
# yes, almost all of them

# the 16 records that aren't duplicated (?) in the unique file names
dupOnly <- rawDups[which(!rawDups$uid %in% sampDups$uid),]
# no pattern I can see in which ones these are


# aquatic
mmb <- loadByProduct(dpID='DP1.20280.001', package='expanded',
                     check.size = F, token=Sys.getenv('NEON_TOKEN'))
mmbr <- removeDups(mmb$mmg_benthicRawDataFiles, mmb$variables_20280, 'mmg_benthicRawDataFiles')
rawDupsB <- mmbr[union(which(duplicated(mmbr$rawDataFileName)),
                      which(duplicated(mmbr$rawDataFileName, fromLast=T))),]


mmw <- loadByProduct(dpID='DP1.20282.001', package='expanded',
                     check.size = F, token=Sys.getenv('NEON_TOKEN'))
mmwr <- removeDups(mmw$mmg_swRawDataFiles, mmw$variables_20282, 'mmg_swRawDataFiles')
rawDupsW <- mmwr[union(which(duplicated(mmwr$rawDataFileName)),
                       which(duplicated(mmwr$rawDataFileName, fromLast=T))),]


