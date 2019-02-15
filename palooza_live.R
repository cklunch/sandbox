install.packages("neonUtilities")
library(neonUtilities)
stackByTable("/Users/clunch/Desktop/NEON_par-quantum-line.zip")
## step 1 - download data from website
zipsByProduct(dpID="DP1.10026.001", site="all", package="expanded", 
              savepath="/Users/clunch/Desktop")

## step 2 - combine the multiple zip files
stackByTable("/Users/clunch/Desktop/filesToStack10026/", folder=T)

## step 3 - read combined data into R session -- this is where the stacked files are
data = read.csv("/Users/clunch/Desktop/filesToStack10026/file_name.csv")

### Alternate method for accessing data
### Download data directly from API (without manually configuring files)
cfc <- loadByProduct(dpID="DP1.10026.001", site="all", package="expanded")
