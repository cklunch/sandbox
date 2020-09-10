library(neonstore)
library(neonUtilities)

Sys.setenv(NEONSTORE_HOME = '/Users/clunch/Dropbox/data/neonstore/')
neon_dir()

neon_download(product='DP1.10026.001', type='expanded', .token=Sys.getenv('NEON_TOKEN'))
neon_download(product='DP4.00200.001', type='basic', start_date='2020-04-01', 
              site=c('TOOL','WREF'), .token=Sys.getenv('NEON_TOKEN'))

neon_index()

# manually modified publication dates on DP1.10026.001 SJER 2019-03 data files
# to try to prompt re-downloading
neon_download(product='DP1.10026.001', type='expanded', site='SJER',
              .token=Sys.getenv('NEON_TOKEN'))

# re-run with no modification of files
neon_download(product='DP4.00200.001', type='basic', start_date='2020-04-01', 
              site=c('TOOL','WREF'), .token=Sys.getenv('NEON_TOKEN'))
