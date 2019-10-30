library(devtools)
install_github('NateMietk/NEON-utilities/neonUtilities')
library(neonUtilities)
options(stringsAsFactors = F)

pr <- loadByProduct(dpID='DP1.00024.001', site=c('WREF','ABBY'),
              startdate='2019-07', enddate='2019-08')

cfc <- loadByProduct(dpID='DP1.10026.001', site=c('WREF','SCBI'),
             package='expanded')


zipsByProduct(dpID='DP1.00024.001', site=c('WREF','ABBY'),
              startdate='2019-07', enddate='2019-08',
              savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack00024', folder=T, nCores=1)
# Unpacking zip files using 8 cores.
# |++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed=01s  
# File requirements do not meet the threshold for automatic parallelization, please see forceParallel to run stacking operation across multiple cores. Running on single core.
# Stacking table PARPAR_1min
# |++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed=03s  
# Stacking table PARPAR_30min
# |++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed=00s  
# Stacking table sensor_positions
# |++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed=00s  
# Stacking ReadMe documentation
# |++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed=00s  
# All unzipped monthly data folders have been removed.

zipsByProduct(dpID='DP1.10098.001', site=c('WREF','ABBY'),
              savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack10098', folder=T, nCores=1)
#Error in if (input == "" || length(grep("\\n|\\r", input))) { : 
#missing value where TRUE/FALSE needed
#In addition: There were 34 warnings (use warnings() to see them)
#Warning messages:
#  1: In grep(sites, x) :
#  argument 'pattern' has length > 1 and only the first element will be used
#2: In grep(sites, tblnames) :
  
zipsByProduct(dpID='DP1.10026.001', site=c('WREF','ABBY'),
              savepath='/Users/clunch/Desktop', package='expanded')
stackByTable('/Users/clunch/Desktop/filesToStack10026', folder=T, nCores=1)
# this only downloaded one site, and worked - no data at ABBY

zipsByProduct(dpID='DP1.10026.001', site=c('WREF','SCBI'),
              savepath='/Users/clunch/Desktop', package='expanded')
stackByTable('/Users/clunch/Desktop/filesToStack10026', folder=T, nCores=1)
#Error in if (input == "" || length(grep("\\n|\\r", input))) { : 
# missing value where TRUE/FALSE needed
# In addition: Warning messages:
#   1: In grep(sites, x) :
#   argument 'pattern' has length > 1 and only the first element will be used
# 2: In grep(sites, tblnames) :
#   argument 'pattern' has length > 1 and only the first element will be used
# 3: In grep(sites, x) :
#   argument 'pattern' has length > 1 and only the first element will be used
# 4: In grep(sites, tblnames) :
#   argument 'pattern' has length > 1 and only the first element will be used
# 5: In grep(sites, x) :
#   argument 'pattern' has length > 1 and only the first element will be used
# 6: In grep(sites, tblnames) :
#   argument 'pattern' has length > 1 and only the first element will be used




