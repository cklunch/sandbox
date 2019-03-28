# We're going to do a demo without you following along, then we have time for you to 
# try stuff with us here to help.

# load packages
install.packages("neonUtilities")
library(neonUtilities)

# first show what data files look like when you unzip
# on data browse page, download quantum line PAR from BONA and STEI
stackByTable(file.choose())
stackByTable("/Users/clunch/Desktop/NEON_par-quantum-line.zip")
# open 30-min file

# go back to data browse page
# filter by nitrogen (N)
# get dpID of plant foliar: DP1.10026.001
zipsByProduct(dpID="DP1.10026.001", site="all", package="expanded", savepath="/Users/clunch/Desktop")
stackByTable("/Users/clunch/Desktop/filesToStack10026", folder=T)
# show files
# open elements table

# Alternate way to get data
# load directly to R
cfc <- loadByProduct(dpID="DP1.10026.001", site="all", package="expanded")
names(cfc)
View(cfc$cfc_fieldData)

