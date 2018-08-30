library(rhdf5)
library(neonUtilities)
options(stringsAsFactors = F)

stack.co2 <- stackEC(filepath="/Users/clunch/Desktop/EC/NEON_eddy-flux/",
                     site="UNDE", level="dp04", var="fluxCo2", avg=NA)

tmstmp <- substring(stack.co2$timeBgn, 1, 19)
tmstmp <- as.POSIXct(tmstmp, format="%Y-%m-%dT%H:%M:%S", tz="UTC")

plot(stack.co2$nsae.flux~tmstmp, pch=20, cex=0.5,
     xlim=c(tmstmp[1], tmstmp[200]), ylim=c(-40,20),
     tck=0.01, xlab="Date", ylab="Flux of CO2",
     lab=c(100, 7, 7))
lines(c(0,0)~c(tmstmp[1], tmstmp[200]), col="grey")

stackByTable("/Users/clunch/Desktop/NEON_par.zip")
par30 <- read.delim("/Users/clunch/Desktop/NEON_par/stackedFiles/PARPAR_30min.csv",
                    sep=",")

parTime <- as.POSIXct(par30$startDateTime, format="%Y-%m-%dT%H:%M:%SZ", tz="UTC")

parSub <- par30[which(par30$verticalPosition==60),]
parTimeSub <- parTime[which(par30$verticalPosition==60)]

plot(parSub$PARMean[1:200]~parTimeSub[1:200], type="l", col="goldenrod",
     xaxt="n", xlab=NA, ylab="Photosynthetically active radiation", tck=0.01)



plot(stack.co2$nsae.flux~tmstmp, pch=20, cex=0.5,
     xlim=c(tmstmp[1], tmstmp[2000]), ylim=c(-40,20),
     tck=0.01, xlab="Date", ylab="Flux of CO2")
lines(c(0,0)~c(tmstmp[1], tmstmp[2050]), col="grey")

plot(parSub$PARMean[1:2000]~parTimeSub[1:2000], type="l", col="goldenrod",
     xaxt="n", xlab=NA, ylab="Photosynthetically active radiation", tck=0.01)
# not useful, peaks don't change much & can't see shorter days

stackByTable("/Users/clunch/Desktop/NEON_obs-phenology-plant.zip")
pheno <- read.delim("/Users/clunch/Desktop/NEON_obs-phenology-plant/stackedFiles/phe_statusintensity.csv",
                    sep=",")

yesno <- function(x) {
  out <- length(which(x=="yes"))/length(x)
  return(out)
}

pheno.pct <- aggregate(pheno, by=list(pheno$date, pheno$phenophaseName), FUN=yesno)
names(pheno.pct)[1:2] <- c("collectDate","phenophase")

ph.date <- as.POSIXct(pheno.pct$collectDate, format="%Y-%m-%d")

plot(pheno.pct$phenophaseStatus[which(pheno.pct$phenophase=="Leaves")]~
       ph.date[which(pheno.pct$phenophase=="Leaves")], 
     type="l", col="green", lwd=2, lab=c(5, 5, 7),
     xlab="Date", ylab="Phenophase prevalence", tck=0.01)
lines(pheno.pct$phenophaseStatus[which(pheno.pct$phenophase=="Falling leaves")]~
        ph.date[which(pheno.pct$phenophase=="Falling leaves")], 
      col="orange", lwd=2)

