library(devtools)
setwd("/Users/clunch/GitHub/NEON-utilities/neonUtilities")
#install_github('NEONScience/NEON-utilities/neonUtilities', ref='master')

install('.')
library(neonUtilities)
check()
options(stringsAsFactors = F)

setwd("~/GitHub/utilities-test-suite/testUtilities")
test()


# DOIs
dois <- getNeonDOI()
dois <- getNeonDOI(dpID='DP1.10003.001')
dois <- getNeonDOI(dpID='DP1.10098.001', release='RELEASE-2022')


# LATEST accessible?
fsp <- loadByProduct(dpID='DP1.30012.001', package='basic', release='LATEST', 
                     token=Sys.getenv('LATEST_TOKEN'), check.size=F)

brd <- loadByProduct(dpID='DP1.10003.001', release='LATEST',
                     startdate='2019-01', enddate='2020-12',
                     site=c('HARV','LAJA','RMNP','TEAK','SJER','WREF'),
                     token=Sys.getenv('LATEST_TOKEN'), check.size=F)

pr <- loadByProduct(dpID='DP1.00024.001', release='LATEST',
                     startdate='2022-09', enddate='2022-10',
                     site=c('ABBY','BIGC'),
                     token=Sys.getenv('LATEST_TOKEN'), check.size=F)

swss <- loadByProduct(dpID='DP1.00094.001', release='LATEST',
                    startdate='2022-07', enddate='2022-08',
                    site=c('DSNY','CPER'),
                    token=Sys.getenv('LATEST_TOKEN'), check.size=F)


# science review flags
ql <- loadByProduct(dpID='DP1.00066.001', release='LATEST',
                    startdate='2022-09', enddate='2022-10',
                    site=c('SERC','WREF'),
                    token=Sys.getenv('LATEST_TOKEN'), check.size=F)

pcp <- loadByProduct(dpID='DP1.00006.001', release='LATEST',
                    startdate='2022-07', enddate='2022-10',
                    site=c('DSNY','HARV'),
                    token=Sys.getenv('LATEST_TOKEN'), check.size=F)

rad <- loadByProduct(dpID='DP1.00023.001', release='LATEST',
                    startdate='2022-05', enddate='2022-10',
                    site=c('BLDE','WREF'),
                    token=Sys.getenv('LATEST_TOKEN'), check.size=F)

st <- loadByProduct(dpID='DP1.20053.001', release='LATEST',
                     startdate='2022-01', enddate='2022-02',
                     site=c('BLDE','ARIK'),
                     token=Sys.getenv('LATEST_TOKEN'), check.size=F)

eos <- loadByProduct(dpID='DP1.20016.001', release='LATEST',
                    startdate='2022-01', enddate='2022-01',
                    site=c('BIGC','WLOU'),
                    token=Sys.getenv('LATEST_TOKEN'), check.size=F)


# other LATEST
mos <- loadByProduct(dpID='DP1.10043.001', release='LATEST',
                    startdate='2019-01', enddate='2021-12',
                    token=Sys.getenv('LATEST_TOKEN'), check.size=F)

asc_LATEST <- neonUtilities::loadByProduct(
  dpID='DP1.20194.001',
  check.size=F,
  startdate = "2018-01",
  enddate = "2020-12",
  site = "all",
  package='expanded',
  release = "LATEST",
  token = token)

downloader::download("https://data.neonscience.org/api/v0/data/package/DP1.30012.001/GRSM/2015-08?package=basic&release=LATEST", 
                     destfile='/Users/clunch/Desktop/test.zip',
                     mode="wb", quiet=T, 
                     headers = c('X-API-Token'= Sys.getenv('LATEST_TOKEN')))

dpID <- 'DP1.30012.001'
package <- 'basic'
release <- 'LATEST'
token <- Sys.getenv('LATEST_TOKEN')
site <- 'all'
startdate <- NA
enddate <- NA
timeIndex <- 'all'
tabl <- 'all'




deflag <- stackEddy('/Users/clunch/Desktop/deflagging/', level='dp01', var='isoCo2', avg=30)

df <- loadByProduct(dpID = 'DP1.20206.001', site = 'ARIK', 
                    startdate = '2021-05', enddate = '2021-05', 
                    check.size = FALSE, package='expanded', 
                    token = Sys.getenv('NEON_TOKEN'))

a<-data.frame(x=1:10,y=1:10)
test<-function(z){
  nm <-deparse(substitute(z))
  print(nm)
  }

# files with release tags
stackByTable('/Users/clunch/Desktop/NEON_temp-soil.zip') # working
st <- stackByTable('/Users/clunch/Desktop/NEON_temp-soil.zip', savepath='envt') # working!
csd <- stackByTable('/Users/clunch/Desktop/NEON_discharge-stream-l4.zip', savepath='envt') # working
cfc <- stackByTable('/Users/clunch/Desktop/NEON_chem-phys-foliar.zip', savepath='envt') # working
stackByTable('/Users/clunch/Desktop/NEON_chem-phys-foliar.zip') # working
stackByTable('/Users/clunch/Desktop/NEON_discharge-stream-l4.zip') # working
stackByTable('/Users/clunch/Desktop/filesToStack00002/')
gch <- stackByTable('/Users/clunch/Desktop/NEON_chem-groundwater.zip', savepath='envt')
stackByTable('/Users/clunch/Desktop/NEON_count-beetles.zip')
bt <- stackByTable('/Users/clunch/Desktop/NEON_temp-bio.zip', savepath='envt')
stackByTable('/Users/clunch/Desktop/NEON_traits-foliar.zip')
stackByTable('/Users/clunch/Desktop/NEON_par.zip')
p <- stackByTable('/Users/clunch/Desktop/NEON_par.zip', savepath='envt')
stackByTable('/Users/clunch/Desktop/NEON_clip-plant-aqu.zip')
aq <- stackByTable('/Users/clunch/Desktop/NEON_clip-plant-aqu.zip', savepath='envt')


# download by release
brd <- loadByProduct(dpID='DP1.10003.001', check.size=F, 
                     release='PROVISIONAL',
                     token=Sys.getenv('NEON_TOKEN'))

inv <- loadByProduct(dpID='DP1.20120.001', package='expanded', 
                     release='RELEASE-2021',
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))

# no data in release for parameters:
brd.no <- loadByProduct(dpID='DP1.10003.001', check.size=F, 
                     release='RELEASE-2021', startdate='2020-01',
                     token=Sys.getenv('NEON_TOKEN'))


# time test
wind <- stackByTable('/Users/clunch/Desktop/NEON_wind-2d.zip', savepath='envt')

# download single table
zipsByProduct(dpID='DP1.10026.001', tabl='cfc_carbonNitrogen',
              savepath='/Users/clunch/Desktop',
              check.size=F, token=Sys.getenv('NEON_TOKEN'))
cfc.n <- stackByTable('/Users/clunch/Desktop/filesToStack10026', savepath='envt')

cfcc <- loadByProduct(dpID='DP1.10026.001', tabl='cfc_chlorophyll',
                      check.size=F, token=Sys.getenv('NEON_TOKEN'))

ltr_CN <- loadByProduct(dpID = "DP1.10033.001", 
                        tabl = 'ltr_litterCarbonNitrogen', 
                        release='RELEASE-2021',
                        check.size=F, token=Sys.getenv('NEON_TOKEN'))

sls_collect <- loadByProduct(dpID = "DP1.10086.001", tabl = 'sls_soilCoreCollection', 
                              check.size=F, token=Sys.getenv('NEON_TOKEN'))

veg <- loadByProduct(dpID='DP1.10098.001', tabl='vst_mappingandtagging',
                     site=c('WREF','SJER'),
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))

vn <- loadByProduct(dpID='DP1.10098.001', tabl='vst_non-woody',
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))
vnl <- loadByProduct(dpID='DP1.10098.001', tabl='vst_non-woody',
                     release='LATEST', check.size=F, token=Sys.getenv('LATEST_TOKEN'))
nst <- loadByProduct(dpID='DP1.10045.001', tabl='vst_perplotperyear',
                     release='RELEASE-2021', check.size=F, token=Sys.getenv('LATEST_TOKEN'))
nst <- loadByProduct(dpID='DP1.10045.001', tabl='nst_perindividual',
                     release='current', check.size=F, token=Sys.getenv('LATEST_TOKEN'))

# lab table error
brdp <- loadByProduct(dpID='DP1.10003.001', tabl='brd_personnel',
                      package='expanded', site=c('HARV','BLAN','MLBS','LAJA'),
                      check.size=F, token=Sys.getenv('NEON_TOKEN'))

# table in wrong product error
veg <- loadByProduct(dpID='DP1.10098.001', tabl='bgc_CNiso_externalSummary',
                     site=c('WREF','SJER'),
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))

# bad table name
veg <- loadByProduct(dpID='DP1.10098.001', tabl='garbage', site=c('WREF','SJER'),
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))

dpID <- 'DP1.20093.001'
site <- c('ARIK','POSE','KING')
package <- "expanded"
startdate <- NA
enddate <- NA
tabl <- 'swc_domainLabData'
token <- Sys.getenv('NEON_TOKEN')

dpID <- 'DP1.10003.001'
site <- c('HARV','BLAN','MLBS','LAJA')
package <- "expanded"
startdate <- NA
enddate <- NA
tabl <- 'brd_personnel'
token <- Sys.getenv('NEON_TOKEN')

# time test
Sys.time()
swc <- loadByProduct(dpID='DP1.00094.001', site='RMNP', startdate='2017-05',
                     enddate='2017-08', check.size=F, token=Sys.getenv('NEON_TOKEN'),
                     nCores=5)
Sys.time()

# memory test
zipsByProduct(dpID='DP1.00094.001', site='RMNP', 
              savepath='/Users/clunch/Desktop',
              check.size=F, token=Sys.getenv('NEON_TOKEN'))
stackByTable('/Users/clunch/Desktop/filesToStack00094/')
stackByTable('/Users/clunch/Desktop/filesToStack00094/', nCores=4, saveUnzippedFiles = T)
# with 2.0, crashes at 72% of 1 min table
# 1.3.8 crashes at 79% of table. hahahaha
# 2.0 with 4 cores: crashes at 79% - wasn't actually parallelizing
# with parallelization, crashes at 87%

# testing stack set of files
stackByTable(list.files('/Users/clunch/Desktop/filesToStack10053/', full.names = T), saveUnzippedFiles = T)
stackByTable(list.dirs('/Users/clunch/Desktop/filesToStack10053/', full.names = T), saveUnzippedFiles = T)
cfi <- stackByTable(list.dirs('/Users/clunch/Desktop/filesToStack10053/', full.names = T), 
                    saveUnzippedFiles = T, savepath='envt')
# should fail, file paths incomplete
stackByTable(list.files('/Users/clunch/Desktop/filesToStack10053/'), saveUnzippedFiles = T)


# testing stackEddy() on set of files
dum <- stackEddy(c('/Users/clunch/Desktop/filesToStack00200/NEON.D01.HARV.DP4.00200.001.nsae.2018-06.basic.h5',
                   '/Users/clunch/Desktop/filesToStack00200/NEON.D01.HARV.DP4.00200.001.nsae.2018-07.basic.h5',
                   '/Users/clunch/Desktop/filesToStack00200/NEON.D13.NIWO.DP4.00200.001.nsae.2018-06.basic.h5',
                   '/Users/clunch/Desktop/filesToStack00200/NEON.D13.NIWO.DP4.00200.001.nsae.2018-07.basic.h5'))

dum2 <- stackEddy(c('/Users/clunch/Desktop/filesToStack00200/NEON.D01.HARV.DP4.00200.001.2018-06.basic.20190521T201956Z.zip',
                    '/Users/clunch/Desktop/filesToStack00200/NEON.D01.HARV.DP4.00200.001.2018-07.basic.20190521T201600Z.zip'))

clbj <- stackEddy(c('/Users/clunch/Desktop/NEON.D11.CLBJ.DP4.00200.001.nsae.2021-08-18.expanded.20220511T190125Z.h5.gz',
                    '/Users/clunch/Desktop/NEON.D11.CLBJ.DP4.00200.001.nsae.2021-08-19.expanded.20220511T190309Z.h5.gz'))

clbj <- stackEddy(c('/Users/clunch/Desktop/NEON.D11.CLBJ.DP4.00200.001.nsae.2021-08-18.expanded.20220511T190125Z.h5',
                    '/Users/clunch/Desktop/NEON.D11.CLBJ.DP4.00200.001.nsae.2021-08-19.expanded.20220511T190309Z.h5'))

foot <- footRaster(c('/Users/clunch/Desktop/NEON.D11.CLBJ.DP4.00200.001.nsae.2021-08-18.expanded.20220511T190125Z.h5',
                     '/Users/clunch/Desktop/NEON.D11.CLBJ.DP4.00200.001.nsae.2021-08-19.expanded.20220511T190309Z.h5'))



# Steph incomplete data problem
apl_allTabs <- loadByProduct(dpID = "DP1.20066.001",
                             site = "TOOK",
                             package = "expanded",
                             startdate = "2019-07",
                             enddate = "2019-07",
                             check.size = FALSE)



# testing stackFromStore()
library(neonstore)

neon_download(product="DP1.10026.001", 
              type="expanded",
              site=c("TOOL","WREF","GUAN"))

Sys.setenv(NEONSTORE_HOME = '/Users/clunch/Dropbox/data/neonstore')
neon_download(product="DP1.10026.001",
              type="expanded",
              site=c("BONA","CLBJ","DCFS","DELA","GRSM","KONZ","LENO","MOAB","NOGP","SOAP","UKFS"))
cfcStore <- stackFromStore('/Users/clunch/Dropbox/data/neonstore', dpID='DP1.10026.001', 
                           site=c('DELA','SOAP','NOGP'), pubdate='2020-12-19',
                           package='expanded', zipped=F, load=T)

temp <- stackFromStore(filepaths='/Users/clunch/data/neonstore',
                       dpID="DP1.00002.001", 
                       startdate="2019-03",
                       enddate="2019-04",
                       package="basic",
                       site=c("TOOL","WREF"))

cfc <- stackFromStore(filepaths='/Users/clunch/data/neonstore',
                      dpID='DP1.10026.001',
                      package='expanded')

cfc <- stackFromStore(filepaths='/Users/clunch/data/neonstore',
                      dpID='DP1.10026.001',
                      package='expanded',
                      site=c('TOOL','WREF'))


cfc <- stackFromStore('/Users/clunch/Dropbox/data/neonstore', dpID='DP1.10026.001', 
               site=c('CLBJ','NOGP'), package='expanded', zipped=T, load=T)
cfc <- stackFromStore('/Users/clunch/Dropbox/data/neonstore', dpID='DP1.10026.001', 
                      site=c('KONZ','DELA','LENO','SOAP','BONA'), pubdate='2020-10-09',
                      package='expanded', zipped=F, load=T)
cfc <- stackFromStore('/Users/clunch/Dropbox/data/neonstore', dpID='DP1.10026.001', 
                      site=c('UNDE','KONA','JERC'), zipped=F, load=T, timeIndex=60)
cfc <- stackByTable(c('/Users/clunch/Dropbox/data/neonstore/NEON.D02.SERC.DP1.10026.001.2016-07.expanded.20200323T154228Z.zip',
                      '/Users/clunch/Dropbox/data/neonstore/NEON.D05.STEI.DP1.10026.001.2017-08.expanded.20200504T151826Z.zip'),
                    saveUnzippedFiles = T)
dst <- stackFromStore('/Users/clunch/Dropbox/data/neonstore', dpID='DP1.00017.001',
                      package='expanded', zipped=T, load=T) # not working
dst <- stackFromStore('/Users/clunch/Dropbox/data/neonstore', dpID='DP1.00017.001',
                      package='expanded', zipped=F, load=T)
dst <- stackFromStore('/Users/clunch/Dropbox/data/neonstore', dpID='DP1.00017.001',
                      package='expanded', timeIndex=60, zipped=F, load=T)

mam <- stackFromStore(neon_dir(), dpID='DP1.10072.001', package='expanded')

neon_download(product='DP1.10003.001', type='expanded', dir=neon_dir())
brd <- stackFromStore(neon_dir(), dpID='DP1.10003.001', package='expanded')
# confirm same
bird <- loadByProduct(dpID='DP1.10003.001', package='expanded')

flux <- stackFromStore('/Users/clunch/GitHub/utilities-test-suite/testUtilities/inst/extdata/neonstore/', 
                       dpID='DP4.00200.001', 
                       site='TOOL',
                       package='basic', zipped=F, load=T, level='dp04')

iso <- stackFromStore('/Users/clunch/GitHub/utilities-test-suite/testUtilities/inst/extdata/neonstore/', dpID='DP4.00200.001', 
                       package='basic', zipped=F, load=T, level='dp01', timeIndex=30,
                       var='dlta13CCo2')


filepaths <- '/Users/clunch/Dropbox/data/neonstore'
dpID <- 'DP1.10026.001'
site <- c('KONZ','DELA','LENO','SOAP','BONA')
zipped <- F
load <- T
pubdate <- "2020-10-07"
package <- "expanded"
startdate <- NA
enddate <- NA

# new download structure for SAE
flux <- stackEddy('/Users/clunch/Desktop/NEON_eddy-flux.zip', level='dp04')
flux <- stackEddy('/Users/clunch/Desktop/PROD_eddy-flux.zip', level='dp04')

flux <- stackEddy('/Users/clunch/Desktop/NEON.D18.TOOL.DP4.00200.001.nsae.2018-07-19.expanded.h5', 
                  level='dp04')
iso <- stackEddy('/Users/clunch/Desktop/NEON.D18.TOOL.DP4.00200.001.nsae.2018-07-19.expanded.h5',
                 level="dp01", avg=30, var=c("dlta13CCo2","dlta18OH2o"))

del <- stackEddy('/Users/clunch/Desktop/filesToStack00200PUUMAprMay/', 
                 var = 'dlta18OH2oRefe', avg = 9, level = 'dp01')

wnd <- stackEddy(list.files('/Users/clunch/Desktop/filesToStack00200/', pattern='.h5$',
                            full.names=T), 
                 var = 'soni', avg = 30, level = 'dp01')

filepath <- '/Users/clunch/Desktop/NEON_eddy-flux.zip'
level <- 'dp04'
var <- NA
avg <- NA

# .gz files for SAE
zipsByProduct("DP4.00200.001", site = "PUUM",
              startdate = "2021-06",
              enddate = "2021-08",
              release='LATEST',
              savepath = "/Users/clunch/Desktop",
              check.size = FALSE, 
              token=Sys.getenv('LATEST_TOKEN'))

zipsByProduct("DP4.00200.001", site = c("MOAB","PUUM"),
              startdate = "2021-05",
              enddate = "2021-07",
              release = "LATEST",
              savepath = "/Users/clunch/Desktop",
              check.size = FALSE, 
              token=Sys.getenv('LATEST_TOKEN'))

flux <- stackEddy('/Users/clunch/Desktop/filesToStack00200/', level='dp04')
flux <- stackEddy('/Users/clunch/Desktop/PUUM_flux_files/', level='dp04')
flux <- stackEddy(filepath = list.files('/Users/clunch/Desktop/filesToStack00200/', 
                                        pattern='[.]h5', full.names = T))
dp1 <- stackEddy('/Users/clunch/Desktop/filesToStack00200/', level='dp01', avg=2, var='co2Stor')
dp1$HARV$hour <- paste(lubridate::date(dp1$HARV$timeBgn), lubridate::hour(dp1$HARV$timeBgn), sep=".")

# fancy figures for ambassadors
g <- ggplot(subset(dp1$HARV, !verticalPosition %in% c("co2Zero","co2Med","co2Low","co2High") & 
                     timeBgn < as.POSIXct("2021-06-03", format="%Y-%m-%d")),
            aes(y=verticalPosition)) + 
  geom_path(aes(x=data.co2Stor.rtioMoleDryCo2.mean,
                group=hour, col=hour)) + 
  theme(legend.position="none") + 
  xlab("CO2") + ylab("Tower level")
g

g <- ggplot(subset(flux$HARV, flux$HARV$timeBgn < as.POSIXct("2021-06-05", format="%Y-%m-%d")),
            aes(y=data.fluxCo2.nsae.flux, x=timeBgn)) +
  geom_point(size=0.7) +
  ylim(-35,20)
g

lhflux <- stackEddy("/Users/clunch/Desktop/filesToStack00200", avg = 30)
lhflux2 <- stackEddy("/Users/clunch/Desktop/filesToStack00200_half_unzipped/", avg = 30)

alldp01 <- stackEddy("/Users/clunch/Desktop/filesToStack00200", level='dp01', avg = 9)


zipsByProduct(site = "SJER", 
              dpID = "DP4.00200.001", 
              startdate = "2019-06", 
              enddate = "2019-07", 
              package = "basic", 
              check.size = F, 
              savepath = '/Users/clunch/Desktop')

isoTest <- stackEddy(filepath = '/Users/clunch/Desktop/filesToStack00200/', 
                     level = "dp01", 
                     var = c("dlta13CCo2","dlta18OH2o"), 
                     avg = "09")

storTest <- stackEddy(filepath = '/Users/clunch/Desktop/filesToStack00200/', 
                     level = "dp01", 
                     var = c("rtioMoleDryCo2","rtioMoleDryH2o"), 
                     avg = "02")

zipsByProduct(site = "WREF", 
              dpID = "DP4.00200.001", 
              startdate = "2019-06", 
              enddate = "2019-07", 
              package = "basic", 
              check.size = F, 
              savepath = '/Users/clunch/Desktop')

isoTestW <- stackEddy(filepath = '/Users/clunch/Desktop/filesToStack00200/', 
                     level = "dp01", 
                     var = c("dlta13CCo2","dlta18OH2o"), 
                     avg = "09")


# expanded
zipsByProduct(site = "BONA", 
              dpID = "DP4.00200.001", 
              startdate = "2020-06", 
              enddate = "2020-06", 
              package = "expanded", 
              check.size = F, 
              savepath = '/Users/clunch/Desktop')

flux <- stackEddy('/Users/clunch/Desktop/NEON.D03.OSBS.DP4.00200.001.2019-03.expanded.20210118T143742Z/', 
                  level='dp04')
foot <- footRaster('/Users/clunch/Desktop/filesToStack00200/NEON.D19.BONA.DP4.00200.001.2020-06.expanded.20210123T023002Z.RELEASE-2021/NEON.D19.BONA.DP4.00200.001.nsae.2020-06-06.expanded.20201105T040628Z.h5')
raster::filledContour(foot$BONA.summary, col=topo.colors(24), 
                      levels=0.001*0:24)
raster::filledContour(foot$X.Users.clunch.Desktop.filesToStack00200.NEON.D19.BONA.DP4.00200.001.2020.06.expanded.20210123T023002Z.RELEASE.2021.NEON.D19.BONA.DP4.00200.001.nsae.2020.06.06.expanded.20201105T040628Z.BONA.dp04.data.foot.grid.turb.20200606T093000Z, 
                      col=topo.colors(24), 
                      levels=0.001*0:24,
                      xlim=c(475000,478000),
                      ylim=c(7224000,7227000))

stackByTable('/Users/clunch/Desktop/NEON_par-quantum-line.zip')
stackByTable('/Users/clunch/Desktop/NEON_gp.zip')
stackByTable('/Users/clunch/Downloads/NEON_pressure-air (1).zip')


wq <- loadByProduct(dpID = 'DP1.20288.001', 
              site = c('SYCA'), startdate = '2019-01-01', 
              enddate = '2020-01-01', check.size = F,
              token=Sys.getenv('NEON_TOKEN'))

zipsByProduct(dpID = 'DP1.20288.001', 
              site = c('SYCA'), startdate = '2020-02', 
              enddate = '2020-09', check.size = F,
              savepath='/Users/clunch/Desktop',
              token=Sys.getenv('NEON_TOKEN'))
# modified file to mimic changing a field name
wq <- stackByTable('/Users/clunch/Desktop/filesToStack20288',
             savepath='envt')

# token testing
waq <- loadByProduct(dpID='DP1.20288.001', site=c('ARIK','HOPB'), 
                     startdate='2017-03', enddate='2018-03', 
                     package='expanded', check.size=F, token=Sys.getenv('NEON_TOKEN'))

byTileAOP(dpID = "DP3.30015.001", site = "WREF", year = "2017", 
          easting = c(571000,743000,578000), 
          northing = c(5079000,3984000,5080000), 
          savepath='/Users/clunch/Desktop', check.size = FALSE,
          token=Sys.getenv('NEON_TOKEN'))

byTileAOP(dpID = "DP3.30006.001", site = "WREF", year = "2017", 
          easting = c(571000,578000), 
          northing = c(5079000,5080000), 
          savepath='/Users/clunch/Desktop', check.size = FALSE)

# fake dpID
byTileAOP(dpID = "DP3.30467.001", site = "WREF", year = "2017", 
          easting = c(571000,743000,578000), 
          northing = c(5079000,3984000,5080000), 
          savepath='/Users/clunch/Desktop', check.size = FALSE,
          token=Sys.getenv('NEON_TOKEN'))

# multiple months per year
byFileAOP(dpID='DP3.30015.001', site='KONZ', year=2019, 
          savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))

# multiple months per year
byTileAOP(dpID='DP3.30015.001', site='CPER', year=2020, 
          easting = c(523300,519700), 
          northing = c(4513400,4518400), 
          savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))

byFileAOP(dpID='DP3.30015.001', site='SJER', year=2017, 
          savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))

byFileAOP(dpID='DP3.30025.001', site='SCBI', year=2017, 
          savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))

byFileAOP(dpID='DP1.30006.001', site='SJER', year=2021, 
          savepath='/Users/clunch/Dropbox/data/NEON data/AOP/', token=Sys.getenv('NEON_TOKEN'))

zipsByProduct(dpID='DP1.10098.001', site=c('WREF','ABBY'), startdate='2019-01',
              savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))
stackByTable('/Users/clunch/Desktop/filesToStack10098')

# test Aqu shared site code
pcp <- loadByProduct(dpID='DP1.00006.001', site=c('KING','BLDE','ARIK','MCRA','PRPO'),
                     startdate='2019-07', enddate='2019-08', timeIndex=30,
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))

part <- loadByProduct(dpID='DP1.00024.001', site=c('KING','BLWA','ARIK','MCRA','TOMB'),
                     startdate='2019-07', enddate='2019-08', timeIndex=30,
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))
# should not alert anything:
part <- loadByProduct(dpID='DP1.00024.001', site=c('KING','ARIK','MCRA'),
                      startdate='2019-07', enddate='2019-08', timeIndex=30,
                      check.size=F, token=Sys.getenv('NEON_TOKEN'))

# test chem bundle handling
root <- loadByProduct(dpID='DP1.10102.001') # should error
ntrans <- loadByProduct(dpID='DP1.10078.001', check.size=F, token=Sys.getenv('NEON_TOKEN'))


# 2D wind table name
wind <- loadByProduct(dpID='DP1.00001.001', site='NIWO', 
                      startdate='2020-05', enddate='2020-07',
                      check.size=F, token=Sys.getenv('NEON_TOKEN'))


# DATA_FRAME handling
scc <- loadByProduct(dpID = 'DP1.10081.001',
                            startdate = '2018-06',
                            enddate = '2019-06',
                            check.size = FALSE,
                            token = Sys.getenv('NEON_TOKEN'),
                            package = 'expanded')

bcc <- loadByProduct(dpID = 'DP1.20086.001',
                     startdate = '2018-06',
                     enddate = '2019-06',
                     check.size = FALSE,
                     token = Sys.getenv('NEON_TOKEN'),
                     package = 'expanded')

wcc <- loadByProduct(dpID = 'DP1.20141.001',
                     startdate = '2018-06',
                     enddate = '2018-12',
                     check.size = FALSE,
                     token = Sys.getenv('NEON_TOKEN'),
                     package = 'expanded')

fsp <- loadByProduct(dpID='DP1.30012.001',
                     check.size=F,
                     package='expanded',
                     token = Sys.getenv('NEON_TOKEN'))


# more with microbes
smg <- loadByProduct(dpID='DP1.10107.001', startdate='2018-05', enddate='2018-07',
                     package='expanded', check.size=F, token=Sys.getenv('NEON_TOKEN'))



# LOV files
rea <- loadByProduct(dpID='DP1.20190.001', site='WALK', check.size=F)
zipsByProduct(dpID='DP1.20190.001', savepath='/Users/clunch/Desktop')

tpth <- loadByProduct(dpID='DP1.10092.001', site=c('KONZ','KONA'), startdate='2015-01',
                      enddate='2019-12', check.size=F, token=Sys.getenv('NEON_TOKEN'))

waq <- loadByProduct(dpID='DP1.20288.001', site=c('ARIK','HOPB'), 
                     startdate='2020-09', enddate='2020-12', 
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
byTileAOP(dpID='DP3.30025.001', site='SUGG', year=2018, 
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
# with token
byFileAOP(dpID='DP1.30006.001', site='HARV', year=2017, check.size=F, 
          savepath='/Users/clunch/Desktop', token=Sys.getenv('NEON_TOKEN'))

# test for data download that should take >1 hour
Sys.time()
zipsByProduct(dpID='DP4.00200.001', site='all', check.size=F, 
          savepath='/Users/clunch/Desktop')


csd <- loadByProduct(dpID='DP4.00130.001', site=c('WLOU','BLUE'),
                     startdate='2019-04', enddate='2020-03',
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))

st <- loadByProduct(dpID='DP1.20206.001', token=Sys.getenv('NEON_TOKEN'))
st <- loadByProduct(dpID='DP1.20206.001', startdate='2017-01', 
                    enddate='2017-12', token=Sys.getenv('NEON_TOKEN'),
                    check.size=F)

fs <- loadByProduct(dpID='DP1.30012.001', check.size=F)

pr <- loadByProduct(dpID='DP1.00024.001', site=c('WREF','ABBY'),
              startdate='2019-12', enddate='2020-08')

saat <- loadByProduct(dpID='DP1.00002.001', site=c('CPER','NIWO'),
                      startdate='2020-10', enddate='2020-12',
                      check.size=F)

tick <- loadByProduct(dpID='DP1.10093.001', site=c('WREF','ABBY'),
                    startdate='2019-07', enddate='2020-08', check.size=F)

brd <- loadByProduct(dpID='DP1.10003.001', check.size=F, token=Sys.getenv('NEON_TOKEN'))

ltr <- loadByProduct(dpID='DP1.10033.001', 
                     startdate='2020-02', enddate='2022-12',
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))

div <- loadByProduct(dpID='DP1.10058.001', 
                     startdate='2020-02', enddate='2022-12',
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))

veg <- loadByProduct(dpID='DP1.10098.001', 
                     startdate='2020-02', enddate='2022-12',
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))

cfc <- loadByProduct(dpID='DP1.10026.001', package='expanded', 
                     check.size=F, nCores=1, token=Sys.getenv('NEON_TOKEN'))

cfc <- loadByProduct(dpID='DP1.10026.001', package='expanded', 
                     startdate='2020-01', enddate='2022-12',
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))

gwe <- loadByProduct(dpID='DP1.20100.001', site=c('MART','WLOU'),
                    startdate='2019-07', enddate='2019-09', check.size=F, nCores=3)

swe <- loadByProduct(dpID='DP1.20016.001', site=c('MART','WLOU'),
                     startdate='2019-07', enddate='2019-09', check.size=F, nCores=2)

wch <- loadByProduct(dpID='DP1.20093.001', site=c('ARIK','POSE'),
                     package='expanded', check.size=F)

nst <- loadByProduct(dpID='DP1.10045.001', package='expanded',
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))

wdp <- loadByProduct(dpID='DP1.00013.001', site=c('RMNP','NIWO'),
                     package='expanded', check.size=F)

wdp <- loadByProduct(dpID='DP1.00013.001', check.size=F, token=Sys.getenv('NEON_TOKEN'))

dst <- loadByProduct(dpID='DP1.00017.001', site=c('RMNP','CPER','ONAQ'),
                     startdate='2019-01', enddate='2019-10', check.size=F,
                     avg=60)
dst <- loadByProduct(dpID='DP1.00017.001', site=c('RMNP','CPER','ONAQ'),
                     startdate='2019-01', enddate='2019-10', check.size=F,
                     timeIndex=60)

dst <- loadByProduct(dpID='DP1.00017.001', site='CPER',
                     startdate='2016-05', enddate='2018-06', check.size=F,
                     timeIndex=60)

rh <- loadByProduct(dpID='DP1.00098.001', site='SCBI', startdate='2020-01',
                    enddate='2020-12', check.size=F, 
                    package='expanded',
                    token=Sys.getenv('NEON_TOKEN'))

alg <- loadByProduct(dpID='DP1.20166.001', check.size=F)
alg.exp <- loadByProduct(dpID='DP1.20166.001', package='expanded', token='garbage')

alg <- loadByProduct(dpID='DP1.20166.001', startdate='2017-05', enddate='2018-08',
                     site=c('MAYF','PRIN'), package='expanded',
                     check.size=F, token='garbage')

veg <- loadByProduct(dpID='DP1.10098.001', site='ABBY', 
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))

# no data
veg <- loadByProduct(dpID='DP1.10098.001', site='LAJA', package='expanded',
                     startdate='2018-01', enddate='2018-12',
                     check.size=F, token=Sys.getenv('NEON_TOKEN'))

wqCheck <- neonUtilities::loadByProduct(dpID = "DP1.20288.001",
                                        site = c("LEWI","MART"),
                                        startdate = "2020-07",
                                        check.size = FALSE,
                                        token=Sys.getenv('NEON_TOKEN'))

nitrate <- loadByProduct(dpID="DP1.20033.001", site="BLDE", startdate="2020-04", enddate="2020-08",
                       package="expanded", check.size = F)

sms <- loadByProduct(dpID='DP1.00094.001', startdate='2018-06', enddate='2018-07',
                     site='NIWO', check.size=F)

buoyT <- loadByProduct(dpID='DP1.20046.001', site='BARC',
                     check.size=F)

sls <- loadByProduct(dpID='DP1.10086.001', site='TALL',
                     package='expanded', token=Sys.getenv('NEON_TOKEN'),
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



zipsByProduct(dpID = "DP1.20288.001",
              site = "LEWI",
              startdate = "2020-07",
              check.size = FALSE,
              token=Sys.getenv('NEON_TOKEN'),
              savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack20288')
stackByTable('/Users/clunch/Desktop/NEON_water-quality.zip')

zipsByProduct(dpID='DP1.00041.001', site=c('WREF','ABBY'),
              startdate='2019-07', enddate='2019-09',
              savepath='/Users/clunch/Desktop',
              check.size=F)
pr <- stackByTable('/Users/clunch/Desktop/filesToStack00041', nCores=1,
                   saveUnzippedFiles=T, savepath='envt')
stackByTable('/Users/clunch/Desktop/filesToStack00041')

zipsByProduct(dpID='DP1.00002.001', site=c('ARIK','CPER'),
              #startdate='2019-07', enddate='2019-08',
              savepath='/Users/clunch/Desktop',
              avg=30, check.size=F)
stackByTable('/Users/clunch/Desktop/filesToStack00002', nCores=1)

saat <- loadByProduct(dpID='DP1.00002.001', site=c('ARIK','CPER'),
                      check.size=F)
zipsByProduct(dpID='DP1.00002.001', site=c('ARIK','CPER'),
              startdate='2019-10', enddate='2020-03',
              savepath='/Users/clunch/Desktop', check.size=F)

# zipsByURI()
zipsByProduct(dpID='DP1.10108.001', site='CPER',
              startdate='2018-07', enddate='2018-07',
              savepath='/Users/clunch/Desktop',
              package='expanded', check.size=F)
stackByTable('/Users/clunch/Desktop/filesToStack10108')
zipsByURI('/Users/clunch/Desktop/filesToStack10108/stackedFiles')

zipsByProduct(dpID='DP1.10107.001', site='YELL',
              startdate='2018-07', enddate='2018-07',
              savepath='/Users/clunch/Desktop',
              package='expanded', check.size=F)
stackByTable('/Users/clunch/Desktop/filesToStack10107')
zipsByURI('/Users/clunch/Desktop/filesToStack10107/stackedFiles')

zipsByProduct(dpID="DP4.00131.001", package="expanded", 
              savepath="/Users/clunch/Desktop", check.size=F)
stackByTable("/Users/clunch/Desktop/filesToStack00131")
zipsByURI("/Users/clunch/Desktop/filesToStack00131/stackedFiles")

# new loadByProduct() -> zipsByURI workflow
bath <- loadByProduct('DP4.00132.001', site=c('TOOK','PRLA'),
                      package='expanded', check.size=F, token=Sys.getenv('NEON_TOKEN'))
zipsByURI(bath, savepath='/Users/clunch/Desktop/bath_zips/')
zipsByURI(bath)

zipsByProduct(dpID='DP1.10098.001', site=c('WREF','ABBY'),
              savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack10098')

zipsByProduct(dpID='DP1.10026.001', site=c('SCBI','WOOD'),
              savepath='/Users/clunch/Desktop', package='expanded',
              check.size=F, token=Sys.getenv('NEON_TOKEN'))
stackByTable('/Users/clunch/Desktop/filesToStack10026', saveUnzippedFiles = T)

zipsByProduct(dpID='DP1.10053.001', site=c('SCBI','WOOD','ONAQ'),
              savepath='/Users/clunch/Desktop', package='expanded',
              check.size=F, token=Sys.getenv('NEON_TOKEN'))

zipsByProduct(dpID='DP1.20288.001',
              savepath='/Users/clunch/Desktop', package='expanded')
stackByTable('/Users/clunch/Desktop/filesToStack20288', nCores=5)

zipsByProduct(dpID='DP1.10092.001', site='KONZ',
              savepath='/Users/clunch/Desktop',
              check.size=F, token=Sys.getenv('NEON_TOKEN'))
stackByTable('/Users/clunch/Desktop/filesToStack10092')
# check release tag usage
zipsByProduct(dpID='DP1.10092.001', site='KONZ',
              savepath='/Users/clunch/Desktop',
              release='RELEASE-2022',
              check.size=F, token=Sys.getenv('NEON_TOKEN'))
zipsByProduct(dpID='DP1.10092.001', site='KONZ',
              savepath='/Users/clunch/Desktop',
              release='garbage',
              check.size=F, token=Sys.getenv('NEON_TOKEN'))


zipsByProduct(dpID='DP1.10081.001', site='KONZ',
              savepath='/Users/clunch/Desktop',
              startdate='2018-01', enddate='2018-12',
              package='expanded',
              check.size=F, token=Sys.getenv('NEON_TOKEN'))

zipsByProduct(dpID='DP1.20126.001', site='TOOK',
              savepath='/Users/clunch/Desktop',
              package='expanded',
              release='LATEST',
              check.size=F, token=Sys.getenv('LATEST_TOKEN'))
stackByTable('/Users/clunch/Desktop/filesToStack20066')

zipsByProduct(dpID='DP1.00017.001', site=c('RMNP','CPER','ONAQ'),
              startdate='2019-01', enddate='2019-10', check.size=F,
              avg=60, savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack00017')
dst <- readTableNEON('/Users/clunch/Desktop/filesToStack00017/stackedFiles/dpsd_60_minutes.csv',
              '/Users/clunch/Desktop/filesToStack00017/stackedFiles/variables_00017.csv')

zipsByProduct(dpID='DP1.20099.001', savepath='/Users/clunch/Desktop')

zipsByProduct(dpID='DP1.10017.001', savepath='/Users/clunch/Desktop',
              site=c('STER','ABBY'), token=Sys.getenv('NEON_TOKEN'))
# expanded - should error
zipsByProduct(dpID='DP1.10017.001', savepath='/Users/clunch/Desktop',
              site=c('STER','ABBY'), token=Sys.getenv('NEON_TOKEN'),
              package='expanded')

zipsByProduct(dpID='DP4.00200.001', site='TEAK', startdate='2018-06', enddate='2018-09',
              savepath='/Users/clunch/Desktop')
flux <- stackEddy('/Users/clunch/Desktop/filesToStack00200TEAK/')

flux <- stackEddy('/Users/clunch/Desktop/NEON_eddy-flux.zip')

pres <- stackEddy(filepath='/Users/clunch/Desktop/filesToStack00200/', 
                  level = "dp01", var = "presAtm", avg = 30, metadata=T)

carb <- stackEddy(filepath='/Users/clunch/Desktop/filesToStack00200/', 
                  level = "dp01", var = "co2Turb", avg = 1, metadata=T)


pres <- loadByProduct(dpID = "DP1.00004.001", site = "PUUM", 
                      startdate = '2021-01', enddate = '2021-12', 
                      timeIndex = 30, package = "basic", check.size = F)

# test SAE expanded package and footprint
zipsByProduct(dpID='DP4.00200.001', site='WREF', startdate='2019-07', enddate='2019-09',
              savepath='/Users/clunch/Desktop', package='expanded',
              token=Sys.getenv('NEON_TOKEN'))
flux <- stackEddy('/Users/clunch/Desktop/expanded00200')
flux <- stackEddy('/Users/clunch/Desktop/expanded00200', metadata=T)
carb <- stackEddy(filepath='/Users/clunch/Desktop/expanded00200/', 
                  level = "dp01", var = "co2Turb", avg = 1, metadata=T)

foot <- footRaster('/Users/clunch/Desktop/NEON.D18.TOOL.DP4.00200.001.nsae.2018-07-19.expanded.h5')
raster::filledContour(foot$TOOL.summary, col=topo.colors(24), 
                      levels=0.001*0:24)

# footRaster() on zipped files (not actually designed for this, only works on first pass):
foot <- footRaster('/Users/clunch/Desktop/NEON.D18.BARR.DP4.00200.001.2020-08.expanded.20201207T231300Z.PROVISIONAL')

# footRaster() on portal files
foot <- footRaster('/Users/clunch/Desktop/NEON_eddy-flux.zip')

# footRaster() on zipsByProduct() files:
zipsByProduct(dpID='DP4.00200.001', site='WREF', startdate='2019-09', enddate='2019-09',
              savepath='/Users/clunch/Desktop', package='expanded',
              token=Sys.getenv('NEON_TOKEN'))
foot <- footRaster('/Users/clunch/Desktop/filesToStack00200/')
raster::filledContour(foot$WREF.summary, col=topo.colors(24), 
                      levels=0.001*0:24)

# transposed?
win <- loadByProduct(dpID='DP1.00001.001', site='WREF', 
                     startdate='2019-09', enddate='2019-09',
                     check.size=F, timeIndex=30)
names(win)[1] <- "wsd"
plot(win$wsd$windDirMean[which(win$wsd$verticalPosition=='070')]~win$wsd$endDateTime[which(win$wsd$verticalPosition=='070')], 
     pch=20, xlim=c(as.POSIXct('2019-09-07 00:00'), as.POSIXct('2019-09-07 23:59')))
foot <- footRaster('/Users/clunch/Desktop/filesToStack00200WREF/NEON.D16.WREF.DP4.00200.001.nsae.2019-09-07.expanded.20201011T021357Z.h5')
raster::filledContour(foot$WREF.summary, col=topo.colors(24), 
                      levels=0.001*0:24,
                      xlim=c(580000,583000),
                      ylim=c(5073000,5076000))
raster::filledContour(foot$X.Users.clunch.Desktop.filesToStack00200WREF.NEON.D16.WREF.DP4.00200.001.nsae.2019.09.07.expanded.20201011T021357Z.WREF.dp04.data.foot.grid.turb.20190907T123000Z, col=topo.colors(24), 
                      levels=0.001*0:24,
                      xlim=c(580000,583000),
                      ylim=c(5073000,5076000))
ft <- rhdf5::h5read('/Users/clunch/Desktop/filesToStack00200WREF/NEON.D16.WREF.DP4.00200.001.nsae.2019-09-07.expanded.20201011T021357Z.h5',
              name='/WREF/dp04/data/foot/grid/turb/20190907T123000Z')
filled.contour(ft)
ft1230 <- raster(ft)
raster::filledContour(ft1230)
win$wsd$windDirMean[which(win$wsd$verticalPosition=='070' &
                            win$wsd$endDateTime==as.POSIXct('2019-09-07 12:30'))]
filled.contour(z=ft, xlim=c(0.4,0.6), ylim=c(0.4,0.6))
raster::filledContour(ft1230, xlim=c(0.4,0.6), ylim=c(0.4,0.6))

zvals <- which(ft!=0, arr.ind=T)
summary(zvals)


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


getPackage(dpID='DP1.10003.001', site_code='WREF', year_month = '2019-06', savepath='/Users/clunch/Desktop')



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

testmessage <- function(x) {
  if(curl::has_internet()==TRUE) {
    message('yes')
    return(invisible())
  }
  2+2
}


neonDomains <- readOGR("/Users/clunch/data/NEONDomains_0", layer="NEON_Domains")
plot(neonDomains)
neonSites <- read.csv("/Users/clunch/data/field-sites.csv")
points(neonSites$Latitude~neonSites$Longitude, pch=20)


waterChemList <-
  neonUtilities::loadByProduct(
    dpID = "DP1.20093.001",
    site = "GUIL",
    package = 'expanded',
    check.size = FALSE
  )

zipsByProduct(dpID = "DP1.20093.001",
              site = "GUIL",
              package = 'expanded',
              check.size = FALSE,
              savepath='/Users/clunch/Desktop')
stackByTable('/Users/clunch/Desktop/filesToStack20093', saveUnzippedFiles = T)

ECoreFile <- data.table::fread('/Users/clunch/Desktop/filesToStack20093/NEON.D04.GUIL.DP1.20093.001.2015-01.expanded.20220120T173946Z.RELEASE-2022/NEON.EcoCore_CSU.swc_externalLabSummaryData.20211221T195713Z.csv')
FIUFile <- data.table::fread('/Users/clunch/Desktop/filesToStack20093/NEON.D04.GUIL.DP1.20093.001.2020-08.expanded.20220131T153018Z.PROVISIONAL/NEON.Florida_International_University.swc_externalLabSummaryData.20220131T153014Z.csv')
allFile <- data.table::rbindlist(list(ECoreFile, FIUFile), fill=T)
allFile <- data.table::rbindlist(list(FIUFile, ECoreFile), fill=T)

ECoreFile$labSpecificEndDate <- as.POSIXct(ECoreFile$labSpecificEndDate, tz="UTC") # does not enable rbind

# Huggins footRaster -> byTileAOP problem
zipsByProduct(dpID='DP4.00200.001', site='TEAK', startdate='2020-06', enddate='2020-07',
              package='expanded', check.size=F, savepath='/Users/clunch/Desktop', 
              token=Sys.getenv('NEON_TOKEN'))
ft <- footRaster('/Users/clunch/Desktop/filesToStack00200/NEON.D17.TEAK.DP4.00200.001.2020-07.expanded.20220120T173946Z.RELEASE-2022/NEON.D17.TEAK.DP4.00200.001.nsae.2020-07-19.expanded.20211214T215846Z.h5')
raster::extent(ft)


# API errors
req <- httr::GET('https://data.neonscience.org/api/v0/data/DP1.30003.001/TREE/2022-06')
av <- jsonlite::fromJSON(httr::content(req, as='text'))
length(grep('\\s', av$data$files$name))
length(av$data$files$name)
for(i in 1:nrow(av$data$files)) {
  res <- try(httr::HEAD(av$data$files$url[i]), silent=T)
  if(inherits(res, 'try-error')) {
    print(av$data$files$name[i])
  }
}


