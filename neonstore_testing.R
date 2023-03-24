library(neonstore)
library(neonUtilities)

Sys.setenv(NEONSTORE_HOME = '/Users/clunch/Dropbox/data/neonstore/')
Sys.setenv(NEONSTORE_HOME = '/Users/clunch/data/neonstore/')
neon_dir()

neon_download(product='DP1.10026.001', type='expanded', .token=Sys.getenv('NEON_TOKEN'), unzip=F)
neon_download(product='DP4.00200.001', type='basic', start_date='2020-04-01', 
              site='TOOL', .token=Sys.getenv('NEON_TOKEN'))
neon_download(product='DP1.00017.001', type='expanded', site=c('MOAB','NIWO','ONAQ'),
              .token=Sys.getenv('NEON_TOKEN'), unzip=T)

neon_index()


# test database creation
neon_download(product='DP1.10026.001', type='expanded', 
              .token=Sys.getenv('NEON_TOKEN'), unzip=T)
cfcn <- neon_read(table='cfc_carbonNitrogen-basic') # no expanded for this table
neon_store(table='cfc_carbonNitrogen-basic')

# run quick start
neon_download("DP1.10003.001")
brds <- neon_read("brd_countdata-expanded")
brdrefs <- neon_read("brd_references-expanded")

# compare site-all output - confirmed PUUM has different pub date
brd <- loadByProduct(dpID='DP1.10003.001', package='expanded', 
                     check.size = F, token=Sys.getenv('NEON_TOKEN'))
setdiff(brdrefs$uid, brd$brd_references$uid)

# AOP download
neon_download(product="DP1.30006.001",
              site='SJER',
              type="expanded",
              start_date='2021-01-01',
              end_date='2021-12-31',
              .token=Sys.getenv('NEON_TOKEN'))

# need to find product with several pub dates and table types
veg <- loadByProduct(dpID='DP1.10098.001', check.size=F, token=Sys.getenv('NEON_TOKEN'))
neon_download("DP1.10098.001")
veg_app <- neon_read('vst_apparentindividual')
setdiff(veg_app$uid, veg$vst_apparentindividual$uid)
setdiff(veg$vst_apparentindividual$uid, veg_app$uid)

# what does it do when the same table is in multiple products, e.g. mapping and tagging?
veg_map <- neon_read('vst_mappingandtagging') # this throws an error message, because
  # mapping and tagging is an expanded package table in CFC, but basic in VST
veg_map <- neon_read('vst_mappingandtagging-basic') # so this returns the VST version
setdiff(veg_map$uid, veg$vst_mappingandtagging$uid) # 393 mismatched values
setdiff(veg$vst_mappingandtagging$uid, veg_map$uid) # none here
nrow(veg_map)
nrow(veg$vst_mappingandtagging)
vegmap_mis <- veg_map[which(veg_map$uid %in% 
                              setdiff(veg_map$uid, 
                                      veg$vst_mappingandtagging$uid)),]
unique(vegmap_mis$siteID)
min(vegmap_mis$date)

# all from ORNL
length(which(veg$vst_mappingandtagging$siteID=='ORNL'))
unique(veg$vst_mappingandtagging$publicationDate
       [which(veg$vst_mappingandtagging$siteID=='ORNL')])
max(veg$vst_mappingandtagging$publicationDate)
unique(veg$vst_mappingandtagging$date[which(veg$vst_mappingandtagging$siteID=='ORNL')])

library(neonOS)
vars <- veg$variables_10098[-which(veg$variables_10098$fieldName=='publicationDate'),]
vegdup <- removeDups(data=veg_map, variables=vars, table='vst_mappingandtagging')
dups.only <- vegdup[which(vegdup$duplicateRecordQF==1),]
View(dups.only)
length(which(dups.only$siteID=='ORNL'))



veg <- loadByProduct(dpID='DP1.10098.001', check.size=F, site=c('ORNL','SJER','WREF','ONAQ'),
                     token=Sys.getenv('NEON_TOKEN'))



# manually modified publication dates on DP1.10026.001 SJER 2019-03 data files
# to try to prompt re-downloading
neon_download(product='DP1.10026.001', type='expanded', site='SJER',
              .token=Sys.getenv('NEON_TOKEN'))

# re-run with no modification of files
neon_download(product='DP4.00200.001', type='basic', start_date='2020-04-01', 
              site=c('TOOL','WREF'), .token=Sys.getenv('NEON_TOKEN'))
