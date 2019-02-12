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
mat <- read.delim("~/GitHub/sandbox/data_availability/firstCollection.csv", sep=",", header=T)
#mat <- mat[1:180,1:85]

# precip wrangling
precip <- apply(t(mat[which(mat$Code=="DP1.00006"),4:84]), 
                2, as.numeric)
precip <- apply(precip, 1, min, na.rm=T)
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

## get AQU AOP availability
# first, get full file list for mosaicked DPs
file.list <- vector("list", 17)
names(file.list) <- current$DPID[151:167]
ind <- 0
for(j in 151:167) {
  ind <- ind+1
  urls <- unlist(ls[[1]]$siteCodes[[j]]$availableDataUrls)
  if(length(urls)==0) {
    file.list[[ind]] <- NA
    next
  } else {
    for(k in 1:length(urls)) {
      a.req <- GET(urls[k])
      files <- fromJSON(content(a.req, as="text"))$data$files$name
      file.list[[ind]] <- c(file.list[[ind]], files)
    }
  }
}

# get locations for AQU sites and look for coordinates in mosaic files
for(i in 4:38) {

  # get site locations - approx center of sampling reach
  site <- names(avail)[i]
  site.req <- GET(paste("http://data.neonscience.org/api/v0/locations/", site, sep=""))
  site.loc <- fromJSON(content(site.req, as="text"))
  
  # these should be the coordinates of the tile where the center of the reach appears
  easting <- floor(site.loc$data$locationUtmEasting/1000)*1000
  northing <- floor(site.loc$data$locationUtmNorthing/1000)*1000
  
  # look for these coordinates in mosaicked DPs
  for(j in names(file.list)) {
    flag <- intersect(grep(easting, file.list[[j]]), grep(northing, file.list[[j]]))
    if(length(flag)==0) {
      avail[which(avail$Code==j),i] <- 0
    } else {
      if(length(flag)>0) {
        avail[which(avail$Code==j),i] <- 1
      }
    }
  }
  
  # extrapolate from mosaicked DPs to flightlines
  for(k in avail$Code[which(avail$Supplier=="AOP" & !(avail$Code %in% names(file.list)))]) {
    ksub <- k
    substring(ksub, 3, 3) <- "3"
    if(ksub %in% avail$Code & k!= "DP1.30012.001") {
      avail[which(avail$Code==k),i] <- avail[which(avail$Code==ksub),i]
    } else {
      if(k=="DP1.30012.001") {
        next
      }
      if(k=="DP1.30001.001") {
        next
      }
      if(k=="DP1.30008.001") {
        avail[which(avail$Code==k),i] <- avail[which(avail$Code=="DP3.30006.001"),i]
      }
      if(k=="DP1.30003.001") {
        avail[which(avail$Code==k),i] <- avail[which(avail$Code=="DP3.30024.001"),i]
      }
    }
  }
}


# convert NAs to string "NA" for write to xlsx
mat[mat=="Inf"] <- NA
mat[is.na(mat)] <- "NA"

# make an xlsx workbook and color cells according to availability
# make workbook
wb <- createWorkbook()
addWorksheet(wb, "Current Availability")
addWorksheet(wb, "Legend")

# add availability data
writeData(wb, 1, mat)
setColWidths(wb, 1, cols=1:ncol(mat), widths="auto")
colorStyle <- createStyle(fgFill="#1aff1a")
availInd <- which(avail==1, arr.ind=T)
availInd[,1] <- availInd[,1]+1
addStyle(wb, 1, colorStyle, rows=availInd[,1], cols=availInd[,2])

# make legend tab
leg <- data.frame(cbind(c("Legend","NA","20XX","20XX"), 
                        c("","Data collection is not planned for this site and data product combination",
                          "Earliest year in which data have been or will be collected",
                          "Earliest year in which data have been or will be collected; partial or full data are currently available for download")))
writeData(wb, 2, leg, colNames=F)
setColWidths(wb, 2, cols=1:ncol(leg), widths="auto")
addStyle(wb, 2, colorStyle, rows=4, cols=1)

saveWorkbook(wb, "/Users/clunch/GitHub/sandbox/data_availability/all_status.xlsx", overwrite=T)



