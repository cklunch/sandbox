dum <- readTableNEON('/Users/clunch/Desktop/filesToStack10026/stackedFiles/cfc_chlorophyll.csv',
                     '/Users/clunch/Desktop/filesToStack10026/stackedFiles/variables.csv')
dumdum <- readTableNEON('/Users/clunch/Desktop/NEON_par copy/stackedFiles/PARPAR_30min.csv',
                        '/Users/clunch/Desktop/NEON_par copy/stackedFiles/variables.csv')

cfc.CN <- read.csv('/Users/clunch/Desktop/filesToStack10026/stackedFiles/cfc_carbonNitrogen.csv')
cfc.var <- read.csv('/Users/clunch/Desktop/filesToStack10026/stackedFiles/variables.csv')
cfCN <- readTableNEON(cfc.CN, cfc.var)

par30 <- read.csv('/Users/clunch/Desktop/NEON_par copy/stackedFiles/PARPAR_30min.csv')
parvar <- read.csv('/Users/clunch/Desktop/NEON_par copy/stackedFiles/variables.csv')
parD <- readTableNEON(par30, parvar)

# !!!! to integrate into stackByTable(savepath=='envt'), need to load in 
# variables, validation, readme, and sensor positions first, then data tables
# check and see what changes Nate has made to stackByTable/loadByProduct first

# to add publication time stamp, just need to add to makePosColumns. But need 
# to see how this will work with OS data
# and also need to check against Nate's changes
