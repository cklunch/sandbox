options(stringsAsFactors = F)
library(neonUtilities)

zipsByProduct(dpID="DP4.00200.001", package="basic",
              site=c("NIWO","HARV"),
              startdate="2018-06", enddate="2018-07",
              savepath="/Users/clunch/Downloads",
              check.size=F)

flux <- stackEddy(filepath="/Users/clunch/Desktop/filesToStack00200/",
                  level="dp04")

names(flux)
View(flux$NIWO)

term <- unlist(strsplit(names(flux$NIWO), split=".", fixed=T))
flux$objDesc[which(flux$objDesc$Object %in% term),]

View(flux$variables)

timeB <- substring(flux$NIWO$timeBgn, 1, nchar(flux$NIWO$timeBgn)-4)
timeB <- strptime(timeB, format="%Y-%m-%dT%H:%M:%S", tz="GMT")
timeB <- as.POSIXct(timeB)

flux$NIWO <- cbind(timeB, flux$NIWO)

plot(flux$NIWO$data.fluxCo2.nsae.flux~timeB, pch=".",
     xlab="Date", ylab="CO2 flux", format="%Y-%m-%d")


pr <- stackByTable(filepath="/Users/clunch/Desktop/filesToStack00024",
             folder=T, savepath="envt")
View(pr$PARPAR_30min)

zipsByProduct(dpID="DP4.00200.001", site="HARV", check.size=F, 
              savepath="/Users/clunch/Downloads")

