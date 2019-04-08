library(rhdf5)
library(neonUtilities)
library(ggplot2)
library(animation)
options(stringsAsFactors=F)

source('~/GitHub/sandbox/EC_HDF/H5ECtoDF.R')
source('~/GitHub/sandbox/EC_HDF/flattenH5EC.R')
source('~/GitHub/sandbox/EC_HDF/stackEC.R')

stack.co2.profile <- stackEC(filepath="/Users/clunch/Desktop/EC/NEON_eddy-flux",
                          site="UNDE", level="dp01", var="co2Stor", avg="30")

co2.profile <- stack.co2.profile[,c(grep("time", colnames(stack.co2.profile)),
                                    intersect(grep("rtioMoleDryCo2", 
                                                   colnames(stack.co2.profile)),
                                            grep("mean", 
                                                 colnames(stack.co2.profile))))]

co2Sub <- t(co2.profile[1:240,1:8])
co2Sub <- data.frame(co2Sub)
colnames(co2Sub) <- co2.profile$timeBgn[1:240]
level <- 1:6

# try out one time step
plot(level~co2Sub[3:8,1], type="b", pch=20)

# 5 days
ani.options(interval=0.4)

saveHTML({
  for(i in 1:240) {
    plot(level~co2Sub[3:8,i], type="b", pch=20, tck=0.01,
         xlab="CO2", ylab="Tower level", main=colnames(co2Sub)[i],
         xlim=c(380,510))
  }
})

