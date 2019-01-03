library(httr)
library(jsonlite)
library(plyr)
library(openxlsx)

options(stringsAsFactors=F)

# get availability list
req <- GET("http://data.neonscience.org/api/v0/products")
ls <- fromJSON(content(req, as="text"))

# get site list
s.req <- GET("http://data.neonscience.org/api/v0/sites")
sites <- fromJSON(content(s.req, as="text"))

# set up data frame
current <- data.frame(matrix(0, nrow=179, ncol=83))
colnames(current)[1:2] <- c("DPID","DPName")
colnames(current)[3:83] <- sites[[1]]$siteCode
current$DPID <- ls[[1]]$productCode
current$DPName <- ls[[1]]$productName

# populate with 1 for available, 0 for no data on portal
for(i in 1:nrow(current)) {
  dp.sites <- ls[[1]]$siteCodes[[i]]$siteCode
  current[i,which(colnames(current) %in% dp.sites)] <- 1
}

# next up: include NAs for sites that won't ever have product
mat <- read.delim("~/GitHub/sandbox/data_availability/Master_product_siteMatrix.csv", sep=",", skip=5)
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
      if(length(cur.val)==0) {
        print(paste("Data product", id, " not found"))
      } else {
        if(cur.val==0) {
          current[which(current$DPID==id), which(colnames(current)==i)] <- NA
        } else {
          print(paste("Data available for ", id, " at ", i, " but not in matrix", sep=""))
        }
      }
    }
  }
}

# adding in 'have we ever sampled there'
samp <- read.delim("~/GitHub/sandbox/data_availability/NEON-OS-DataAvailabilityBySiteByYear-v20170918.csv", sep=",")
samp$DPID <- paste(substring(samp$DPID, 2, 10), ".001", sep="")


# remove MDP and itemized EC products
current <- current[which(!current$DPID %in% c("DP4.50036.001","DP1.00007.001","DP1.00010.001",
                                              "DP1.00034.001","DP1.00035.001","DP1.00036.001",
                                              "DP1.00036.001","DP1.00037.001","DP1.00099.001",
                                              "DP1.00100.001","DP2.00008.001","DP2.00009.001",
                                              "DP2.00024.001","DP3.00008.001","DP3.00009.001",
                                              "DP3.00010.001","DP4.00002.001","DP4.00007.001",
                                              "DP4.00067.001","DP4.00137.001","DP4.00201.001")),]


# make matrix of first year sampled
first <- current
for(i in first$DPID) {
  if(length(which(samp$DPID==i))==0) {
    print(paste("No sampling info for", i, first$DPName[which(first$DPID==i)], sep=" "))
  } else {
    for(j in colnames(first)[3:83]) {
      #print(paste(i, j))
      first.val <- first[which(first$DPID==i), which(colnames(first)==j)]
      if(is.na(first.val)) {
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
          first[which(first$DPID==i), which(colnames(first)==j)] <- substring(yr, 2, 5)
        }
      }
  }
  }
}

# make an xlsx workbook and color cells according to availability
wb <- createWorkbook()
addWorksheet(wb, "currentAvailability")
writeData(wb, 1, current)
setColWidths(wb, 1, cols=1:ncol(current), widths="auto")
colorStyle <- createStyle(fgFill="#1aff1a")
avail <- which(current==1, arr.ind=T)
avail[,1] <- avail[,1]+1
addStyle(wb, 1, colorStyle, rows=avail[,1], cols=avail[,2])
saveWorkbook(wb, "/Users/clunch/Desktop/all_status.xlsx")



