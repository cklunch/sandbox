library(httr)
library(jsonlite)
library(plyr)
library(openxlsx)

options(stringsAsFactors=F)

# read in OS sampling spreadsheet
samp <- read.delim("/Users/clunch/GitHub/sandbox/data_availability/OS_sampling.csv", sep=",")

# read in availability spreadsheet
mat <- read.delim("~/GitHub/sandbox/data_availability/firstCollection.csv", sep=",", header=T)

# precip wrangling
precip <- apply(t(mat[which(mat$Code=="DP1.00006"),4:84]), 
                2, as.numeric)
precip <- apply(precip, 1, min, na.rm=T)
mat <- mat[-which(mat$Code=="DP1.00006"),]
mat <- rbind(mat, c("Precipitation", "DP1.00006", "TIS", precip))

# write out with cleaned up precip
write.table(mat, "~/GitHub/sandbox/data_availability/firstCollectionClean.csv", row.names=F, sep=",")

# convert sampling spreadsheet to availability style
for(i in mat$Code) {
  if(length(grep(i, samp$Data.Product.Name.ID))==0) {
    print(paste("No sampling info for", i, mat$Name[which(mat$Code==i)], sep=" "))
  } else {
    for(j in colnames(mat)[4:84]) {
      #print(paste(i, j))
      cur.val <- mat[which(mat$Code==i), which(colnames(mat)==j)]
      samp.dp <- samp[intersect(which(samp$Site==j), grep(i, samp$Data.Product.Name.ID)),]
      if(nrow(samp.dp)==0) {
        print(paste("No sampling info for", i, j))
      } else {
        samp.sub <- samp.dp[,grep("X", colnames(samp.dp), fixed=T)]
        if(all(is.na(samp.sub) | samp.sub=="")) {
          mat[which(mat$Code==i), which(colnames(mat)==j)] <- NA
        } else {
          if(nrow(samp.sub)>1) {
            yr <- colnames(samp.sub)[min(which(samp.sub=="Y", arr.ind=T)[,2], na.rm=T)]
          } else {
            yr <- colnames(samp.sub)[min(which(samp.sub=="Y"), na.rm=T)]
          }
          mat[which(mat$Code==i), which(colnames(mat)==j)] <- substring(yr, 2, 5)
          }
        }
      }
    }
}

write.table(mat, "~/GitHub/sandbox/data_availability/updated_avail.csv", row.names=F, sep=",")

