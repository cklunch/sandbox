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

# get sampling initiation schedule
mat <- read.delim("~/sandbox/data_availability/firstCollection.csv", sep=",", header=T)
#mat <- mat[1:180,1:85]

# precip wrangling
precip <- apply(t(mat[which(mat$Code=="DP1.00006"),4:84]), 
                2, as.numeric)
precip <- apply(precip, 1, min)
mat <- mat[-which(mat$Code=="DP1.00006"),]
mat <- rbind(mat, c("Precipitation", "DP1.00006", "TIS", precip))

mat$Code <- paste(mat$Code, "001", sep=".")

# remove MDP and itemized EC products
mat <- mat[which(!mat$Code %in% c("DP4.50036.001","DP1.00007.001","DP1.00010.001",
                                              "DP1.00034.001","DP1.00035.001","DP1.00036.001",
                                              "DP1.00036.001","DP1.00037.001","DP1.00099.001",
                                              "DP1.00100.001","DP2.00008.001","DP2.00009.001",
                                              "DP2.00024.001","DP3.00008.001","DP3.00009.001",
                                              "DP3.00010.001","DP4.00002.001","DP4.00007.001",
                                              "DP4.00067.001","DP4.00137.001","DP4.00201.001")),]

mat <- mat[order(mat$Supplier, mat$Code),]

# make matching matrix with 1's and 0's for availability
avail <- mat

for(i in colnames(mat)[4:84]) {
  for(j in mat$Code) {
    cur.val <- current[which(current$DPID==j), which(colnames(current)==i)]
    if(length(cur.val)==0) {
      print(paste("Data product", j, " not found"))
    } else {
      if(cur.val==0 | cur.val==1) {
        avail[which(avail$Code==j), which(colnames(avail)==i)] <- cur.val
      } else {
        print(paste("Data product ", j, " at ", i, " not found in availability matrix", sep=""))
      }
    }
  }
}

# hard code 1's for AQU AOP data
for(i in 4:38) {
  avail[which(avail$Supplier=="AOP" & avail$Code!="DP1.30012.001"),i] <- 
    ifelse(mat[which(avail$Supplier=="AOP" & avail$Code!="DP1.30012.001"),i] < 2017, 1, 0)
}

# convert NAs to string "NA" for write to xlsx
mat[is.na(mat)] <- "NA"

# make an xlsx workbook and color cells according to availability
wb <- createWorkbook()
addWorksheet(wb, "currentAvailability")
writeData(wb, 1, mat)
setColWidths(wb, 1, cols=1:ncol(mat), widths="auto")
colorStyle <- createStyle(fgFill="#1aff1a")
availInd <- which(avail==1, arr.ind=T)
availInd[,1] <- availInd[,1]+1
addStyle(wb, 1, colorStyle, rows=availInd[,1], cols=availInd[,2])
saveWorkbook(wb, "/Users/clunch/sandbox/data_availability/all_status.xlsx", overwrite=T)



