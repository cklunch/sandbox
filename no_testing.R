library(devtools)
library(urlchecker)
library(neonUtilities)
setwd("~/GitHub/NEON-OS-data-processing/neonOS")
install('.')
library(neonOS)
check()
url_check()


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
list2env(bird, .GlobalEnv)
brd.d <- removeDups(brd_countdata, variables=variables_10003)

fish <- loadByProduct(dpID='DP1.20107.001', check.size=F, 
                      startdate='2017-05', enddate='2019-08',
                      package='expanded', token=Sys.getenv('NEON_TOKEN'))
fish.d <- removeDups(fish$fsh_fieldData, variables=fish$variables_20107, table='fsh_fieldData')
fish.p <- removeDups(fish$fsh_perPass, variables=fish$variables_20107, table='fsh_perPass')
fish.f <- removeDups(fish$fsh_perFish, variables=fish$variables_20107, table='fsh_perFish')


dust <- loadByProduct(dpID='DP1.00101.001', check.size=F, startdate='2017-05', enddate='2019-06')
dpm.d <- removeDups(dust$dpm_lab, variables=dust$variables_00101, table='dpm_lab')


# mammals
mam <- loadByProduct(dpID='DP1.10072.001', site='JERC', startdate='2016-01', enddate='2017-12',
                     package='expanded', check.size=F, token=Sys.getenv('NEON_TOKEN'))
mam.dup.plot <- removeDups(mam$mam_perplotnight, variables=mam$variables_10072, table='mam_perplotnight')
mam.dup.trap <- removeDups(mam$mam_pertrapnight, variables=mam$variables_10072, table='mam_pertrapnight')


# joinTableNEON() testing
mam.all <- joinTableNEON(mam.dup.plot, mam.dup.trap, 
                         name1="mam_perplotnight",
                         name2="mam_pertrapnight")
# error for incorrect name inputs
mam.all <- joinTableNEON(mam.dup.plot, mam.dup.trap, 
                         name1=mam_perplotnight,
                         name2=mam_pertrapnight)
# no names when they're needed
mam.all <- joinTableNEON(mam.dup.plot, mam.dup.trap)

cfc <- loadByProduct(dpID='DP1.10026.001', check.size=F, 
                     startdate='2019-05', enddate='2021-08',
                     package='expanded', token=Sys.getenv('NEON_TOKEN'))
list2env(cfc, .GlobalEnv)
tst <- joinTableNEON(cfc_fieldData, cfc_elements)
tst <- joinTableNEON(cfc_fieldData, cfc_carbonNitrogen)
# left join special case
tst <- joinTableNEON(cfc_fieldData, vst_mappingandtagging)
# override left join
tst <- joinTableNEON(cfc_fieldData, vst_mappingandtagging, left.join=F)

bird <- loadByProduct(dpID='DP1.10003.001', check.size=F, 
                      startdate='2017-05', enddate='2019-08',
                      package='expanded', token=Sys.getenv('NEON_TOKEN'))
list2env(bird, .GlobalEnv)
tst <- joinTableNEON(brd_countdata, brd_personnel)
tst <- joinTableNEON(brd_perpoint, brd_personnel)
tst <- joinTableNEON(brd_references, brd_personnel)
tst <- joinTableNEON(brd_countdata, brd_perpoint)


# location fields = F special case
sdg <- loadByProduct(dpID='DP1.20097.001', check.size=F,
                     startdate='2019-05', enddate='2019-10',
                     package='expanded', token=Sys.getenv('NEON_TOKEN'))
list2env(sdg, .GlobalEnv)
tst <- joinTableNEON(sdg_fieldDataProc, sdg_fieldDataAir)


# recent data only special case
tck <- loadByProduct(dpID='DP1.10092.001', check.size=F,
                     startdate='2020-01',
                     package='expanded', token=Sys.getenv('NEON_TOKEN'))
list2env(tck, .GlobalEnv)
tst <- joinTableNEON(tck_pathogen, tck_pathogenqa)
tck_pathogen <- tck_pathogen[tck_pathogen$collectDate>as.POSIXct("2021-01-01"),] # no 2021 data yet


mos <- loadByProduct(dpID="DP1.10043.001",
                     site="TOOL",
                     release="RELEASE-2022",
                     token=Sys.getenv('NEON_TOKEN'),
                     check.size=F)

inv <- loadByProduct(dpID="DP1.20120.001",
                     site="TOOK",
                     release="RELEASE-2022",
                     token=Sys.getenv('NEON_TOKEN'),
                     check.size=F)


# getSampleTree() testing
sampleNode <- "BLDE.SS.20181002"
idType <- "tag"
sampleClass <- "swc.asi.sdg.amc"
token <- Sys.getenv('NEON_TOKEN')

algs <- getSampleTree(sampleNode='BLDE.SS.20181002', idType='tag', 
                     sampleClass='swc.asi.sdg.amc', token=Sys.getenv('NEON_TOKEN'))

# should exit with sampleClass info:
algs <- getSampleTree('BLDE.SS.20181002', idType='tag', 
                      token=Sys.getenv('NEON_TOKEN'))


# plant div
div <- loadByProduct(dpID='DP1.10058.001', site='ABBY', 
                     startdate='2019-01', enddate='2019-12',
                     package='expanded', check.size=F,
                     token=Sys.getenv('NEON_TOKEN'))
div.all <- merge(div$div_1m2Data, div$div_10m2Data100m2Data, by='eventID') # NOPE




## taxa
t <- getTaxonList('FISH')
t <- getTaxonList('FISH', verbose='true')
p <- getTaxonList('PLANT', verbose='true', recordReturnLimit=15)
m <- getTaxonList('SMALL_MAMMAL', stream='false')
m <- getTaxonList('SMALL_MAMMAL', stream='true')


# join recursion

mamdat <- loadByProduct(dpID="DP1.10072.001",
                        site=c("SCBI", "SRER", "UNDE"),
                        package="basic",
                        check.size = FALSE,
                        startdate = "2021-01",
                        enddate = "2022-12")
list2env(mamdat, .GlobalEnv)
mam_perplotnight <- removeDups(mam_perplotnight, variables=variables_10072)
mam_pertrapnight <- removeDups(mam_pertrapnight, variables=variables_10072)
mam.f <- joinTableNEON(mam_perplotnight, mam_pertrapnight)


apc_allTabs <- loadByProduct(
  dpID='DP1.20072.001',
  check.size=F, 
  site = "all",
  package='expanded',
  startdate = '2021-07',
  enddate = '2021-07',
  token = Sys.getenv('NEON_TOKEN'))
list2env(apc_allTabs, envir=.GlobalEnv)
removeDups(data = apc_taxonomyRaw, variables = variables_20072)

View(apc_taxonomyRaw)


veg <- loadByProduct(dpID='DP1.10098.001', 
                     startdate='2019-01', enddate='2020-12',
                     check.size=F, token=Sys.getenv('NEON_TOKEN'),
                     include.provisional=T)
vdup <- removeDups(veg$vst_apparentindividual, variables=veg$variables_10098,
                   table='vst_apparentindividual')

veg2021 <- loadByProduct(dpID='DP1.10098.001', 
                     startdate='2021-01', enddate='2021-12',
                     check.size=F, token=Sys.getenv('NEON_TOKEN'),
                     include.provisional=T)
vdup2021 <- removeDups(veg2021$vst_apparentindividual, variables=veg2021$variables_10098,
                   table='vst_apparentindividual')

max(veg$vst_apparentindividual$date[which(!is.na(veg$vst_apparentindividual$tempStemID))])
length(which(!is.na(veg$vst_apparentindividual$tempStemID)))
nrow(veg$vst_apparentindividual)

max(veg$vst_apparentindividual$date[which(is.na(veg$vst_apparentindividual$tempStemID))])
temp <- veg$vst_apparentindividual[which(is.na(veg$vst_apparentindividual$tempStemID)),]


mam <- loadByProduct(dpID='DP1.10072.001', site=c('HARV','BART','SJER','SOAP','HEAL'),
                     startdate='2015-01', enddate='2021-12',
                     check.size=F, token=Sys.getenv('NEON_TOKEN'),
                     include.provisional=T)
mdup <- removeDups(mam$mam_pertrapnight, variables=mam$variables_10072,
                   table='mam_pertrapnight')

unique(mam$mam_pertrapnight$trapStatus)
gr <- mam$mam_pertrapnight[grep("X", mam$mam_pertrapnight$trapCoordinate),]
mult <- mam$mam_pertrapnight[grep("4", mam$mam_pertrapnight$trapStatus),]

