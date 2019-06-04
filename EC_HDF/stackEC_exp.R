library(neonUtilities)
zipsByProduct(dpID="DP4.00200.001", package="basic", site="BONA",
              savepath="/Users/clunch/Desktop", check.size=F)
# level, var, and avg are the defaults here
nsae <- stackEC(filepath="/Users/clunch/Desktop/filesToStack00200/",
                    level="dp04", var=c("nsae","stor","turb"), avg=NA)

