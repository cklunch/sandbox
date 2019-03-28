# start by installing neonUtilities package, if you haven't already
install.packages("neonUtilities")
library(neonUtilities)

# stack downloaded data
stackByTable(file.choose())
stackByTable("/Users/clunch/Desktop/NEON_par-quantum-line.zip")

# download data directly
zipsByProduct(dpID="DP1.10026.001", site="all", package="expanded",
              savepath="/Users/clunch/Desktop")
stackByTable("/Users/clunch/Desktop/filesToStack10026", folder=T)

# download data into R
cfc <- loadByProduct(dpID="DP1.10026.001", site="all", package="expanded")
names(cfc)
View(cfc$cfc_carbonNitrogen)



