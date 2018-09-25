options(stringsAsFactors=F)

# OS ingest
osCountByDate <- function(stack, startDate, endDate) {
  
  data.call <- paste("http://", stack, "-os-ds-1.ci.neoninternal.org:8080/osDataService", 
                     "/activities?", 
                     "end-date-begin=", startDate, "&end-date-cutoff=", endDate, 
                     "&include-field-data=true&include-samples=true",
                     sep="")
  
  req <- httr::GET(data.call)
  req.x <- XML::xmlParse(httr::content(req, as="text", encoding = "UTF-8"))
  ct <- XML::xmlGetAttr(req.x[["//count"]], "count")
  
  return(ct)
}

dates <- paste("2013-0", 1:9, "-01T00:00:00.000Z", sep="")
dates <- c(dates, paste("2013-", 10:12, "-01T00:00:00.000Z", sep=""))
dates <- c(dates, gsub("2013","2014",dates), gsub("2013","2015",dates), gsub("2013","2016",dates), 
           gsub("2013","2017",dates), gsub("2013","2018",dates))
date.mat <- cbind(dates[-length(dates)], dates[-1])
colnames(date.mat) <- c("strt","ed")

ct.d <- cbind(date.mat[,1], numeric(length(date.mat[,1])))
for(i in 1:nrow(date.mat)) {
  ct.d[i,2] <- osCountByDate("prod", date.mat[i,1], date.mat[i,2])
}

ct.d <- data.frame(ct.d)
colnames(ct.d) <- c("startDate","count")
ct.d$count <- as.numeric(ct.d$count)
ct.d$startDate <- substring(ct.d$startDate, 1, 19)
ct.d$startDate <- as.POSIXct(ct.d$startDate, format="%Y-%m-%dT%H:%M:%S")

plot(ct.d$count~ct.d$startDate, type="l")
# cut off most recent months
ct.d <- ct.d[1:64,]
plot(ct.d$count~ct.d$startDate, type="l", tck=0.01, xlab="Date", ylab="Records of data collected",
     main="Observational (OS) Data by Collection Date",
     lwd=3, col="blue", cex.axis=1.5, cex.lab=2, cex.main=2)


