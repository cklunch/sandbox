library(httr)
library(jsonlite)
library(plyr)

options(stringsAsFactors=F)

# get availability list
req <- GET("http://data.neonscience.org/api/v0/products")
ls <- fromJSON(content(req, as="text"))

# get site list
s.req <- GET("http://data.neonscience.org/api/v0/sites")
sites <- fromJSON(content(s.req, as="text"))

# set up data frame
current <- data.frame(matrix(0, nrow=180, ncol=83))
colnames(current)[1:2] <- c("DPID","DPName")
colnames(current)[3:83] <- sites[[1]]$siteCode
current$DPID <- ls[[1]]$productCode
current$DPName <- ls[[1]]$productName

# populate with 1 for availability, 0 for no
for(i in 1:nrow(current)) {
  dp.sites <- ls[[1]]$siteCodes[[i]]$siteCode
  current[i,which(colnames(current) %in% dp.sites)] <- 1
}

# next up: include NAs for sites that won't ever have product
mat <- read.delim("~/sandbox/Master_product_siteMatrix.csv", sep=",", skip=5)
mat <- mat[1:180,1:85]

# precip wrangling
precip <- apply(t(mat[which(mat$Identification.Code=="NEON.DOM.SITE.DP1.00006.001"),5:85]), 
                2, as.numeric)
precip <- apply(precip, 1, sum)
mat <- mat[-which(mat$Identification.Code=="NEON.DOM.SITE.DP1.00006.001"),]
mat <- rbind(mat, c("Precipitation", "NEON.DOM.SITE.DP1.00006.001", "TIS", "", precip))

for(i in colnames(mat)[5:85]) {
  for(j in mat$Identification.Code) {
    mat.val <- mat[which(mat$Identification.Code==j), which(colnames(mat)==i)]
    if(mat.val > 0) {
      next
    } else {
      id <- substring(j, 15, 27)
      cur.val <- current[which(current$DPID==id), which(colnames(current)==i)]
      if(cur.val==0) {
        current[which(current$DPID==id), which(colnames(current)==i)] <- NA
      } else {
        print(paste("Data available for ", id, " at ", i, " but not in matrix", sep=""))
      }
    }
  }
}

# for latency: import transition wait times google sheet
tran <- read.delim("~/sandbox/Transition_wait_times.csv", sep=",")

# max transition time by product
tranByProd <- ddply(tran, "DPName", summarise, latency=max(Transition.wait.time, na.rm=T))
tranByProd$latency[which(tranByProd$latency==-Inf)] <- NA



