library(devtools)
setwd("/Users/clunch/GitHub/NEON-utilities/neonUtilities")
#install_github('NateMietk/NEON-utilities/neonUtilities', ref='master')
#setwd("/Users/clunch/GitHub/NateFork/NEON-utilities/neonUtilities")

install('.')
library(neonUtilities)
check()
options(stringsAsFactors = F)

setwd("~/GitHub/utilities-test-suite/testUtilities")
test()

stackByTable('/Users/clunch/Desktop/NEON_par-quantum-line.zip')
stackByTable('/Users/clunch/Desktop/NEON_gp.zip')
stackByTable('/Users/clunch/Downloads/NEON_pressure-air (1).zip')

# token testing
waq <- loadByProduct(dpID='DP1.20288.001', site=c('ARIK','HOPB'), 
                     startdate='2017-03', enddate='2018-03', 
                     package='expanded', check.size=F, token=Sys.getenv('NEON_TOKEN'))

byTileAOP(dpID = "DP3.30015.001", site = "WREF", year = "2017", 
          easting = c(571000,743000,578000), 
          northing = c(5079000,3984000,5080000), 
          savepath='/Users/clunch/Desktop', check.size = FALSE,
          token=Sys.getenv('NEON_TOKEN'))

# fake dpID
byTileAOP(dpID = "DP3.30467.001", site = "WREF", year = "2017", 
          easting = c(571000,743000,578000), 
          northing = c(5079000,3984000,5080000), 
          savepath='/Users/clunch/Desktop', check.size = FALSE,
          token=Sys.getenv('NEON_TOKEN'))

byFileAOP(dpID='DP3.30015.001', site='SJER', year=2017, check.size=F, 
          savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))

zipsByProduct(dpID='DP1.10098.001', site=c('WREF','ABBY'), startdate='2019-01',
              savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))
stackByTable('/Users/clunch/Desktop/filesToStack10098')


# LOV files
rea <- loadByProduct(dpID='DP1.20190.001', site='WALK', check.size=F)
zipsByProduct(dpID='DP1.20190.001', savepath='/Users/clunch/Desktop')


waq <- loadByProduct(dpID='DP1.20288.001', site=c('ARIK','HOPB'), 
                     startdate='2017-03', enddate='2018-03', 
                     package='expanded', check.size=F)

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
          savepath='/Users/clunch/Desktop', 
          check.size = FALSE, token=Sys.getenv('NEON_TOKEN'))

byTileAOP(dpID = "DP3.30025.001", site = "WREF", year = "2017", 
          easting = c(571000,578000), 
          northing = c(5079000,5080000), 
          savepath='/Users/clunch/Desktop', 
          check.size = FALSE, token='garbage')

byFileAOP(dpID='DP3.30015.001', site='SJER', year=2017, check.size=F, 
          savepath='/Users/clunch/Desktop')

byFileAOP(dpID='DP3.30019.001', site='OAES', year=2019, check.size=F, 
          savepath='/Users/clunch/Desktop')

# sites that are flown under another site's name
byFileAOP(dpID='DP3.30015.001', site='TREE', year=2017, check.size=F, 
          savepath='/Users/clunch/Desktop')

# sites that are flown under another site's name
byTileAOP(dpID='DP3.30025.001', site='SUGG', year=2018, check.size=F, 
          easting=c(401890,401930), northing=c(3284680,3284690),
          savepath='/Users/clunch/Desktop')



# test for Blandy UTM zones
veg <- loadByProduct(dpID='DP1.10098.001', site='BLAN', check.size=F)
veg.loc <- geoNEON::getLocTOS(veg$vst_mappingandtagging, 'vst_mappingandtagging')
ea <- veg.loc$adjEasting[which(!is.na(veg.loc$adjEasting))]
no <- veg.loc$adjNorthing[which(!is.na(veg.loc$adjNorthing))]
byTileAOP(dpID='DP3.30015.001', site='BLAN', year=2017, 
          easting=ea, northing=no, buffer=10, savepath='/Users/clunch/Desktop')

# test for data download that should take >1 hour
Sys.time()
byFileAOP(dpID='DP1.30006.001', site='HARV', year=2017, check.size=F, 
          savepath='/Users/clunch/Desktop')

# test for data download that should take >1 hour
Sys.time()
zipsByProduct(dpID='DP4.00200.001', site='all', check.size=F, 
          savepath='/Users/clunch/Desktop')


st <- loadByProduct(dpID='DP1.20206.001', token=Sys.getenv('NEON_TOKEN'))
st <- loadByProduct(dpID='DP1.20206.001', startdate='2017-01', 
                    enddate='2017-12', token=Sys.getenv('NEON_TOKEN'),
                    check.size=F)

fs <- loadByProduct(dpID='DP1.30012.001', check.size=F)

pr <- loadByProduct(dpID='DP1.00024.001', site=c('WREF','ABBY'),
              startdate='2019-07', enddate='2019-08')

tick <- loadByProduct(dpID='DP1.10093.001', site=c('WREF','ABBY'),
                    startdate='2019-07', enddate='2019-08')

cfc <- loadByProduct(dpID='DP1.10026.001', package='expanded', 
                     check.size=F, nCores=1, token=Sys.getenv('NEON_TOKEN'))

cfc <- loadByProduct(dpID='DP1.10026.001', package='expanded', 
                     startdate='2019-01', enddate='2019-12',
                     check.size=F, nCores=1, token=Sys.getenv('NEON_TOKEN'))

gwe <- loadByProduct(dpID='DP1.20100.001', site=c('MART','WLOU'),
                    startdate='2019-07', enddate='2019-09', check.size=F, nCores=5)

swe <- loadByProduct(dpID='DP1.20016.001', site=c('MART','WLOU'),
                     startdate='2019-07', enddate='2019-09', check.size=F, nCores=5)

wch <- loadByProduct(dpID='DP1.20093.001', site=c('ARIK','POSE'),
                     package='expanded', check.size=F)

wdp <- loadByProduct(dpID='DP1.00013.001', site=c('RMNP','NIWO'),
                     package='expanded', check.size=F)

wdp <- loadByProduct(dpID='DP1.00013.001', check.size=F, token=Sys.getenv('NEON_TOKEN'))

dst <- loadByProduct(dpID='DP1.00017.001', site=c('RMNP','CPER','ONAQ'),
                     startdate='2019-01', enddate='2019-10', check.size=F,
                     avg=60)

dst <- loadByProduct(dpID='DP1.00017.001', site='CPER',
                     startdate='2016-05', enddate='2018-06', check.size=F,
                     avg=60)

rh <- loadByProduct(dpID='DP1.00098.001', site='HARV', startdate='2019-06',
                    avg=30, check.size=F)

alg <- loadByProduct(dpID='DP1.20166.001', check.size=F)
alg.exp <- loadByProduct(dpID='DP1.20166.001', package='expanded', token='garbage')

alg <- loadByProduct(dpID='DP1.20166.001', startdate='2017-05', enddate='2018-08',
                     site=c('MAYF','PRIN'), package='expanded',
                     check.size=F, token='garbage')

nitrate <- loadByProduct(dpID="DP1.20033.001", site="BLDE", startdate="2020-01", enddate="2020-04",
                       package="expanded", check.size = F)

sms <- loadByProduct(dpID='DP1.00094.001', startdate='2018-06', enddate='2018-07',
                     site='NIWO', check.size=F)

buoyT <- loadByProduct(dpID='DP1.20046.001', site='BARC',
                     check.size=F)

bat <- loadByProduct(dpID='DP4.00132.001', startdate='2017-05',
                     enddate='2018-08', check.size=F)

div <- loadByProduct(dpID='DP1.10058.001', startdate='2018-01', 
                     enddate='2018-12', token=Sys.getenv('NEON_TOKEN'),
                     check.size=F)
length(which(div$div_10m2Data100m2Data$additionalSpecies=='N'))
length(which(div$div_10m2Data100m2Data$additionalSpecies=='Y'))
div$div_10m2Data100m2Data[which(div$div_10m2Data100m2Data$additionalSpecies=='N'),]

divsub <- div$div_1m2Data[which(div$div_1m2Data$plotID=='SERC_022'),]
divbigsub <- div$div_10m2Data100m2Data[which(div$div_10m2Data100m2Data$plotID=='SERC_022'),]

div <- stackByTable('/Users/clunch/Desktop/NEON_presence-cover-plant.zip', savepath='envt')
setdiff(unique(div$div_1m2Data$plotID), unique(div$div_10m2Data100m2Data$plotID))

# should display message about avg= and download all data
waq <- loadByProduct(dpID='DP1.20288.001', site=c('ARIK','MCRA'),
                     avg=5, check.size=F)

# should fail with informative message
sae <- loadByProduct(dpID='DP4.00200.001', site='WREF', check.size=F)


zipsByProduct(dpID='DP1.00024.001', site=c('WREF','ABBY'),
              startdate='2019-07', enddate='2019-09',
              savepath='/Users/clunch/Desktop',
              check.size=F)
pr <- stackByTable('/Users/clunch/Desktop/filesToStack00024', nCores=1,
                   saveUnzippedFiles=T, savepath='envt')

zipsByProduct(dpID='DP1.00002.001', site=c('ABBY','CPER'),
              startdate='2019-07', enddate='2019-08',
              savepath='/Users/clunch/Desktop',
              avg=30, check.size=F)
stackByTable('/Users/clunch/Desktop/filesToStack00002', nCores=1)

# zipsByURI()
zipsByProduct(dpID='DP1.10108.001', site='CPER',
              startdate='2016-07', enddate='2016-07',
              savepath='/Users/clunch/Desktop',
              package='expanded', check.size=F)
stackByTable('/Users/clunch/Desktop/filesToStack10108')
zipsByURI('/Users/clunch/Desktop/filesToStack10108/stackedFiles')


zipsByProduct(dpID='DP1.10098.001', site=c('WREF','ABBY'),
              savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack10098')

zipsByProduct(dpID='DP1.10026.001', site=c('SCBI','WOOD'),
              savepath='/Users/clunch/Desktop', package='expanded')
stackByTable('/Users/clunch/Desktop/filesToStack10026', nCores=1)

zipsByProduct(dpID='DP1.20288.001',
              savepath='/Users/clunch/Desktop', package='expanded')
stackByTable('/Users/clunch/Desktop/filesToStack20288', nCores=5)

zipsByProduct(dpID='DP1.00017.001', site=c('RMNP','CPER','ONAQ'),
              startdate='2019-01', enddate='2019-10', check.size=F,
              avg=60, savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack00017')
dst <- readTableNEON('/Users/clunch/Desktop/filesToStack00017/stackedFiles/dpsd_60_minutes.csv',
              '/Users/clunch/Desktop/filesToStack00017/stackedFiles/variables_00017.csv')

zipsByProduct(dpID='DP1.20099.001', savepath='/Users/clunch/Desktop',
              check.size=F)

zipsByProduct(dpID='DP4.00200.001', site='TEAK', startdate='2018-06', enddate='2018-09',
              savepath='/Users/clunch/Desktop')
flux <- stackEddy('/Users/clunch/Desktop/filesToStack00200TEAK/')

foot <- footRaster('/Users/clunch/Desktop/filesToStack00200WREF/NEON.D16.WREF.DP4.00200.001.nsae.2018-07-04.expanded.h5')

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


# checking for special characters in table_types

checkConv <- function(x) enc2utf8(x)!=x
dum <- apply(table_types, c(1,2), checkConv)
which(dum==TRUE, arr.ind=T)

d <- apply(table_types, c(1,2), Encoding)
which(d=='UTF-8', arr.ind=T)

tools::showNonASCII(table_types)
dum <- apply(table_types, 1, tools::showNonASCII)

checkAscii <- function(x) grepl("[^ -~]", x)
dum <- apply(table_types, c(1,2), checkAscii)
which(dum==TRUE, arr.ind=T)

