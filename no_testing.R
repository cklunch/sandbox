library(devtools)
library(neonUtilities)
setwd("~/GitHub/NEON-OS-data-processing/neonOS")
install('.')
library(neonOS)
check()


# removeDups() testing
cfc <- loadByProduct(dpID='DP1.10026.001', check.size=F, 
                     startdate='2017-05', enddate='2019-08',
                     package='expanded', token=Sys.getenv('NEON_TOKEN'))
cfc.cn <- removeDups(cfc$cfc_chlorophyll, variables=cfc$variables_10026, table='cfc_chlorophyll')

amc <- loadByProduct(dpID='DP1.20138.001', check.size=F, 
                     startdate='2017-05', enddate='2019-08',
                     package='expanded', token=Sys.getenv('NEON_TOKEN'))

# test expanded package error
cfc <- loadByProduct(dpID='DP1.10026.001', check.size=F, 
                     startdate='2017-05', enddate='2019-08',
                     token=Sys.getenv('NEON_TOKEN'))
cfc.cn <- removeDups(cfc$cfc_chlorophyll, variables=cfc$variables_10026, table='cfc_chlorophyll')
cfc.dum <- removeDups(cfc$cfc_chlorophyll, variables=cfc$variables_10026, table='cfc_elements')

bird <- loadByProduct(dpID='DP1.10003.001', check.size=F, 
                      startdate='2017-05', enddate='2019-08',
                      package='expanded', token=Sys.getenv('NEON_TOKEN'))
brd.d <- removeDups(bird$brd_countdata, variables=bird$variables_10003, table='brd_countdata')

fish <- loadByProduct(dpID='DP1.20107.001', check.size=F, 
                      startdate='2017-05', enddate='2019-08',
                      package='expanded', token=Sys.getenv('NEON_TOKEN'))
fish.d <- removeDups(fish$fsh_fieldData, variables=fish$variables_20107, table='fsh_fieldData')
fish.p <- removeDups(fish$fsh_perPass, variables=fish$variables_20107, table='fsh_perPass')



dust <- loadByProduct(dpID='DP1.00101.001', check.size=F, startdate='2017-05', enddate='2019-06')
dpm.d <- removeDups(dust$dpm_lab, variables=dust$variables_00101, table='dpm_lab')



# joinTableNEON() testing
cfc <- loadByProduct(dpID='DP1.10026.001', check.size=F, 
                     startdate='2019-05', enddate='2021-08',
                     package='expanded', token=Sys.getenv('NEON_TOKEN'))
list2env(cfc, .GlobalEnv)
tst <- joinTableNEON(cfc_fieldData, cfc_elements)

# test joining tables not directly mapped together
tst <- joinTableNEON(cfc_carbonNitrogen, cfc_elements)

