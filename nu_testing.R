library(devtools)
install_github('NateMietk/NEON-utilities/neonUtilities')
library(neonUtilities)
options(stringsAsFactors = F)

pr <- loadByProduct(dpID='DP1.00024.001', site=c('WREF','ABBY'),
              startdate='2019-07', enddate='2019-08')
#Error in stackDataFilesParallel(savepath, nCores, forceParallel, forceStack) : 
#  argument "nCores" is missing, with no default

pr <- loadByProduct(dpID='DP1.00024.001', site=c('WREF','ABBY'),
              startdate='2019-07', enddate='2019-08',
              nCores=1)
#Error in loadByProduct(dpID = "DP1.00024.001", site = c("WREF", "ABBY"),  : 
#                         unused argument (nCores = 1)

zipsByProduct(dpID='DP1.00024.001', site=c('WREF','ABBY'),
              startdate='2019-07', enddate='2019-08',
              savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack00024', folder=T, nCores=1)
#Parallelizing stacking operation across 8 cores.
#Stacking table PARPAR_1min
#|++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed=05s  
#Stacking table PARPAR_30min
#|++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed=00s  
#Stacking table sensor_positions
#|++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed=00s  
#Stacking ReadMe documentation
#|                                                  | 0 % ~calculating  Error in str_detect(X1, "Date-Time for Data Publication") : 
#  could not find function "str_detect"

library(stringr)
stackByTable('/Users/clunch/Desktop/filesToStack00024', folder=T, nCores=1)
#Parallelizing stacking operation across 8 cores.
#Skipping PARPAR_1min because /Users/clunch/Desktop/filesToStack00024/stackedFiles/PARPAR_1min.csv already exists.
#Skipping PARPAR_30min because /Users/clunch/Desktop/filesToStack00024/stackedFiles/PARPAR_30min.csv already exists.
#Skipping sensor_positions because /Users/clunch/Desktop/filesToStack00024/stackedFiles/sensor_positions.csv already exists.
#Stacking ReadMe documentation
#|                                                  | 0 % ~calculating  Error in as_factor(splitter[2]) : could not find function "as_factor"

library(haven)
stackByTable('/Users/clunch/Desktop/filesToStack00024', folder=T, nCores=1)
#Parallelizing stacking operation across 8 cores.
#Skipping PARPAR_1min because /Users/clunch/Desktop/filesToStack00024/stackedFiles/PARPAR_1min.csv already exists.
#Skipping PARPAR_30min because /Users/clunch/Desktop/filesToStack00024/stackedFiles/PARPAR_30min.csv already exists.
#Skipping sensor_positions because /Users/clunch/Desktop/filesToStack00024/stackedFiles/sensor_positions.csv already exists.
#Stacking ReadMe documentation
#|++++++++++++++++++++++++++++++++++++++++++++++++++| 100% elapsed=00s  
#Error in filter(., !str_detect(value, "Date-Time for Data Publication:"),  : 
#                  unused arguments (!str_detect(value, "Additional documentation"), !str_detect(value, "This zip package also contains"), !str_detect(value, "Basic download package definition"), !str_detect(value, "Expanded download package definition"))




