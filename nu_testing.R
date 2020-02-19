library(devtools)
setwd("/Users/clunch/GitHub/NEON-utilities/neonUtilities")
#install_github('NateMietk/NEON-utilities/neonUtilities', ref='issue-69')
install('.')
library(neonUtilities)
options(stringsAsFactors = F)

byTileAOP(dpID = "DP3.30006.001", site = "ORNL", year = "2016", 
          easting = 744000, northing = 983000, check.size = FALSE)

byTileAOP(dpID = "DP3.30006.001", site = "ORNL", year = "2016", 
          easting = c(743000,747000), 
          northing = c(3984000,3984000), 
          savepath='/Users/clunch/Desktop', check.size = FALSE)

byTileAOP(dpID = "DP3.30025.001", site = "ORNL", year = "2016", 
          easting = c(743000,747000), 
          northing = c(3984000,3984000), 
          savepath='/Users/clunch/Desktop', check.size = FALSE)

byTileAOP(dpID = "DP3.30015.001", site = "WREF", year = "2017", 
          easting = c(571000,743000,578000), 
          northing = c(5079000,3984000,5080000), 
          savepath='/Users/clunch/Desktop', check.size = FALSE)

byFileAOP(dpID='DP3.30015.001', site='SJER', year=2017, check.size=F, 
          savepath='/Users/clunch/Desktop') # started ~9:18, 713 files = 477.8 MB

pr <- loadByProduct(dpID='DP1.00024.001', site=c('WREF','ABBY'),
              startdate='2019-07', enddate='2019-08')

cfc <- loadByProduct(dpID='DP1.10026.001', package='expanded', 
                     check.size=F, nCores=1)

gwe <- loadByProduct(dpID='DP1.20100.001', site=c('MART','WLOU'),
                    startdate='2019-07', enddate='2019-09', check.size=F, nCores=5)

wch <- loadByProduct(dpID='DP1.20093.001', site=c('ARIK','POSE'),
                     package='expanded', check.size=F)

wdp <- loadByProduct(dpID='DP1.00013.001', site=c('RMNP','NIWO'),
                     package='expanded', check.size=F)

dst <- loadByProduct(dpID='DP1.00017.001', site=c('RMNP','CPER','ONAQ'),
                     startdate='2019-01', enddate='2019-10', check.size=F,
                     avg=60)

rh <- loadByProduct(dpID='DP1.00098.001', site='HARV', startdate='2019-06',
                    avg=30, check.size=F)

alg <- loadByProduct(dpID='DP1.20166.001', startdate='2017-05', enddate='2018-08',
                     check.size=F)

buoyT <- loadByProduct(dpID='DP1.20046.001', site='BARC',
                     check.size=F)

bat <- loadByProduct(dpID='DP4.00132.001', startdate='2017-05',
                     enddate='2018-08', check.size=F)

zipsByProduct(dpID='DP1.00024.001', site=c('WREF','ABBY'),
              startdate='2019-07', enddate='2019-09',
              savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack00024', folder=T, nCores=1)

zipsByProduct(dpID='DP1.10098.001', site=c('WREF','ABBY'),
              savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack10098')

zipsByProduct(dpID='DP1.10026.001',
              savepath='/Users/clunch/Desktop', package='expanded')
stackByTable('/Users/clunch/Desktop/filesToStack10026', folder=T, nCores=1)

zipsByProduct(dpID='DP1.10026.001',
              savepath='/Users/clunch/Desktop', package='expanded')
stackByTable('/Users/clunch/Desktop/filesToStack10026', folder=T, nCores=1)

zipsByProduct(dpID='DP1.20288.001',
              savepath='/Users/clunch/Desktop', package='expanded')
stackByTable('/Users/clunch/Desktop/filesToStack20288', nCores=5)

zipsByProduct(dpID='DP1.00017.001', site=c('RMNP','CPER','ONAQ'),
              startdate='2019-01', enddate='2019-10', check.size=F,
              avg=60, savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack00017')
dst <- readTableNEON('/Users/clunch/Desktop/filesToStack00017/stackedFiles/dpsd_60_minutes.csv',
              '/Users/clunch/Desktop/filesToStack00017/stackedFiles/variables.csv')

zipsByProduct(dpID='DP1.20099.001', savepath='/Users/clunch/Desktop',
              check.size=F)

stackByTable('/Users/clunch/Desktop/filesToStack20099')

stackByTable('/Users/clunch/Desktop/NEON_par.zip')
stackByTable('/Users/clunch/Desktop/NEON_gp.zip')
stackByTable('/Users/clunch/Desktop/NEON_size-dust-particulate.zip')
stackByTable('/Users/clunch/Desktop/filesToStack10026', nCores=1)
stackByTable('/Users/clunch/Desktop/filesToStack00022', nCores=3)
stackByTable('/Users/clunch/Desktop/filesToStack00024', nCores=3)
stackByTable('/Users/clunch/Desktop/filesToStack00024v131', folder=T)

pr30 <- read.csv('/Users/clunch/Desktop/filesToStack00024/stackedFiles/PARPAR_30min.csv')
pr30v131 <- read.csv('/Users/clunch/Desktop/filesToStack00024v131/stackedFiles/PARPAR_30min.csv')
pr30 <- read.csv('/Users/clunch/Desktop/filesToStack00024/stackedFiles/PARPAR_30min.csv')
pr30v131 <- read.csv('/Users/clunch/Desktop/filesToStack00024v131/stackedFiles/PARPAR_30min.csv')
setdiff(names(pr30),names(pr30v131))
pr30key <- paste0(pr30$siteID, pr30$verticalPosition, pr30$endDateTime)
pr131key <- paste0(pr30v131$siteID, pr30v131$verticalPosition, pr30v131$endDateTime)
all(pr30key %in% pr131key)
all(pr131key %in% pr30key)

pr30key <- paste0(pr30$siteID, pr30$verticalPosition, pr30$endDateTime, pr30$PARMean)
pr131key <- paste0(pr30v131$siteID, pr30v131$verticalPosition, pr30v131$endDateTime, pr30v131$PARMean)
all(pr30key %in% pr131key)
all(pr131key %in% pr30key)

