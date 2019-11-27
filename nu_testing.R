library(devtools)
install_github('NateMietk/NEON-utilities/neonUtilities')
library(neonUtilities)
options(stringsAsFactors = F)

pr <- loadByProduct(dpID='DP1.00024.001', site=c('WREF','ABBY'),
              startdate='2019-07', enddate='2019-08')

cfc <- loadByProduct(dpID='DP1.10026.001', package='expanded', 
                     check.size=F, nCores=1)

gwe <- loadByProduct(dpID='DP1.20100.001', site=c('MART','WLOU'),
                    startdate='2019-07', enddate='2019-09', check.size=F, nCores=5)

wch <- loadByProduct(dpID='DP1.20093.001', site=c('ARIK','POSE'),
                     package='expanded', check.size=F)

dst <- loadByProduct(dpID='DP1.00017.001', site=c('RMNP','CPER','ONAQ'),
                     startdate='2019-01', enddate='2019-10', check.size=F)


zipsByProduct(dpID='DP1.00024.001', site=c('WREF','ABBY'),
              startdate='2019-07', enddate='2019-08',
              savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack00024', folder=T, nCores=1)

zipsByProduct(dpID='DP1.10098.001', site=c('WREF','ABBY'),
              savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack10098')

zipsByProduct(dpID='DP1.10026.001',
              savepath='/Users/clunch/Desktop', package='expanded')
stackByTable('/Users/clunch/Desktop/filesToStack10026', folder=T, nCores=1)

stackByTable('/Users/clunch/Desktop/NEON_gp.zip')


