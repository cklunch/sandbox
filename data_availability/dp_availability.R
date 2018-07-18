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
mat <- read.delim("~/sandbox/data_availability/Master_product_siteMatrix.csv", sep=",", skip=5)
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
      print(id)
      print(i)
      cur.val <- current[which(current$DPID==id), which(colnames(current)==i)]
      if(cur.val==0) {
        current[which(current$DPID==id), which(colnames(current)==i)] <- NA
      } else {
        print(paste("Data available for ", id, " at ", i, " but not in matrix", sep=""))
      }
    }
  }
}

# adding in 'have we ever sampled there'
samp <- read.delim("~/sandbox/data_availability/NEON-OS-DataAvailabilityBySiteByYear-v20170918.csv", sep=",")
samp$DPID <- paste(substring(samp$DPID, 2, 10), ".001", sep="")

# find blank rows in samp spreadsheet
samp.y <- samp[,grep("X", colnames(samp), fixed=T)]
ind <- which(apply(samp.y, 1, FUN=function(x){all(x=="")}))
dp.s <- cbind(samp$DPID[ind], samp$Data.Product.Name[ind], samp$Site[ind])
write.table(dp.s, "~/sandbox/data_availability/blank.lines.csv", sep=",", row.names=F)

# subset to only OS products
current.os <- current[which((substring(current$DPID, 5, 5) %in% c(1,2) | 
                              current$DPID %in% c("DP1.00101.001","DP1.00013.001","DP1.00038.001",
                                                  "DP4.00131.001","DP4.00132.001","DP4.00133.001",
                                                  "DP1.00096.001","DP1.00097.001")) 
                            & !current$DPID %in% c("DP1.20002.001","DP1.20004.001","DP1.20015.001",
                                                   "DP1.20016.001","DP1.20032.001","DP1.20033.001",
                                                   "DP1.20042.001","DP1.20046.001","DP1.20053.001",
                                                   "DP1.20059.001","DP1.20100.001","DP1.20217.001",
                                                   "DP1.20261.001","DP1.20264.001","DP1.20271.001",
                                                   "DP1.20288.001")),]

# 1 if there are data on portal, YEAR of future sampling if it hasn't happened yet, 
# 0 if sampling has happened but data aren't available, NA if never sampled
for(i in current.os$DPID) {
  if(length(which(samp$DPID==i))==0) {
    print(paste("No sampling info for", i, current.os$DPName[which(current.os$DPID==i)], sep=" "))
  } else {
    for(j in colnames(current.os)[3:83]) {
      #print(paste(i, j))
      cur.val <- current.os[which(current.os$DPID==i), which(colnames(current.os)==j)]
      if(is.na(cur.val) | cur.val==1) {
        next
      } else {
        samp.dp <- samp[which(samp$DPID==i & samp$Site==j),]
        samp.sub <- samp.dp[,grep("X", colnames(samp.dp), fixed=T)]
        if(all(is.na(samp.sub) | samp.sub=="")) {
          next
        } else {
          if(nrow(samp.sub)>1) {
            yr <- colnames(samp.sub)[min(which(samp.sub=="Y", arr.ind=T)[,2], na.rm=T)]
          } else {
            yr <- colnames(samp.sub)[min(which(samp.sub=="Y"), na.rm=T)]
          }
          if(as.numeric(substring(yr, 2, 5)) <= 2017) {
            next
          } else {
            current.os[which(current.os$DPID==i), which(colnames(current.os)==j)] <- substring(yr, 2, 5)
          }
        }
      }
  }
  }
}


# write out status table
write.table(current.os, "~/sandbox/data_availability/os_status.csv", row.names=F, sep=",")


# for operations latency: import transition wait times google sheet
tran <- read.delim("~/sandbox/data_availability/Transition_wait_times.csv", sep=",")

# max transition time by product
tranByProd <- ddply(tran, "DPName", summarise, latency=max(Transition.wait.time, na.rm=T))
tranByProd$latency[which(tranByProd$latency==-Inf)] <- NA

# remove re-pub rows
tran <- tran[-which(tran$rePub.=="Y"),]
tran <- tran[,-which(colnames(tran)=="rePub.")]
write.table(tran, "~/sandbox/data_availability/ongoing_latency.csv", row.names=F, sep=",")

