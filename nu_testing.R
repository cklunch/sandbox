library(devtools)
install_github('NateMietk/NEON-utilities/neonUtilities')
library(neonUtilities)
options(stringsAsFactors = F)

pr <- loadByProduct(dpID='DP1.00024.001', site=c('WREF','ABBY'),
              startdate='2019-07', enddate='2019-08')

cfc <- loadByProduct(dpID='DP1.10026.001', site=c('WREF','SCBI'),
             package='expanded')

gwe <- loadByProduct(dpID='DP1.20100.001', site=c('MART','WLOU'),
                    startdate='2019-07', enddate='2019-09')

wch <- loadByProduct(dpID='DP1.20093.001', site=c('ARIK','POSE'),
                     package='expanded')


zipsByProduct(dpID='DP1.00024.001', site=c('WREF','ABBY'),
              startdate='2019-07', enddate='2019-08',
              savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack00024', folder=T, nCores=1)

zipsByProduct(dpID='DP1.10098.001', site=c('WREF','ABBY'),
              savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack10098', folder=T, nCores=1)

zipsByProduct(dpID='DP1.10026.001',
              savepath='/Users/clunch/Desktop', package='expanded')
stackByTable('/Users/clunch/Desktop/filesToStack10026', folder=T, nCores=1)




