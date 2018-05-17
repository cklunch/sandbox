
if (file.exists('/Users/kthibault/')){
  mypathtoCKL <- '/Users/kthibault/Documents/GitHub/sandbox'
}

options(stringsAsFactors=F)

library(dplyr)
library(stringr)
library(tidyr)
library(readxl)
library(lubridate)
library(ggplot2)

dat <- read_excel(paste(mypathtoCKL, 'Latency.xlsx', sep = '/'), sheet = 1, na = "NA")

statusByDp <- dat %>% group_by(`Data Product ID`, `Data Product Name`) %>% summarise(meanStatus = round(mean(`Legacy ingest status (%)`),0), minStatus = round(min(`Legacy ingest status (%)`),0), maxStatus = round(max(`Legacy ingest status (%)`),0))

delaysByDp <- dat %>% group_by(`Data Product ID`, `Data Product Name`, `Legacy delay driver`) %>% filter(!is.na(`Legacy delay driver`)) %>% summarise(completionDate = max(`Expected Legacy Ingest Completion`))

delayByDp <- delaysByDp[1,]
for (i in unique(delaysByDp$`Data Product ID`)){
  temp  <- delaysByDp %>% filter(`Data Product ID` == i)
  if (nrow(temp) > 1){
    latestDate <- max(temp$completionDate)
    temp2 <- temp %>% filter(completionDate == latestDate)
    delayByDp <- rbind(delayByDp, temp2)
  } else {
    delayByDp <- rbind(delayByDp, temp)
  }
}
delayByDp <- delayByDp[-1,]

datByDp <- left_join(statusByDp, delayByDp, by = "Data Product ID")
datByDp <- datByDp %>% select(-`Data Product Name.y`)
datByDp$mo <- month(datByDp$completionDate)
datByDp$`Legacy delay driver` <- ifelse(is.na(datByDp$`Legacy delay driver`), "no delay - complete", datByDp$`Legacy delay driver`)
datByDp$mo <- ifelse(is.na(datByDp$mo), 4, datByDp$mo)

ggplot(datByDp, aes(reorder(`Legacy delay driver`, completionDate, length))) + geom_bar() + coord_flip() + ylab("Number of OS Data Products") + xlab("Legacy Data Delay Driver") + theme_bw()

ggsave("legacyDataDrivers.png")

summaryDat <- datByDp %>% group_by(mo) %>% count()
a = 1
for (i in min(summaryDat$mo):max(summaryDat$mo)){
  if(i %in% summaryDat$mo){
    summaryDat$cumN[a] <- sum(summaryDat$n[1:a])
    a = a + 1
  } else {
      mo <- i
      n <- 0
      cumN = summaryDat$cumN[summaryDat$mo == (i-1)]
      summaryDat <- bind_rows(summaryDat, c(mo = mo, n = n, cumN = cumN))
  }
}

summaryDat <- summaryDat[order(summaryDat$mo),]
summaryDat$month <- factor(summaryDat$mo, levels = summaryDat$mo[order(summaryDat$mo)])

ggplot(summaryDat, aes(x = month, y = ((cumN/82)*100))) + geom_col() + ylab("% of OS Data Products Up to Date") + theme_economist_white()+ scale_x_discrete(name = "Month of 2018", breaks = as.character(summaryDat$mo), labels = c("4" = "Apr", "5" = "May", "6"= "Jun", "7" = "Jul", "8" = "Aug","9" = "Sept","10" ="Oct", "11" = "Nov", "12" = "Dec"))

ggsave('osDpTimeline.png')

##histograms of latency
external <- dat %>% filter(Location == 'External' & `Latency category` != "OT")

ggplot(external, aes(`Transition wait time`)) + stat_bin(aes(y = (..count..)/sum(..count..)*100), binwidth = 40, color = "black", fill = "#CCCCCC") + theme_bw() + scale_y_continuous("% of OS data tables") + xlab("Latency (days since field collection)")

ggsave("externalLabLatency.png", width = 3, height = 2)

field <- dat %>% filter(Location == 'Field')

ggplot(field, aes(`Fulcrum load delay`)) + stat_bin(aes(y = (..count..)/sum(..count..)*100), binwidth = 25, color = "black", fill = "#CCCCCC") + theme_bw() + scale_y_continuous("% of OS data tables") + xlab("Latency (days since field collection)")

ggsave("fieldDataLatency.png", width = 3, height = 2)

domain <- dat %>% filter(Location == 'Domain')

ggplot(field, aes(`Fulcrum load delay`)) + stat_bin(aes(y = (..count..)/sum(..count..)*100), binwidth = 25, color = "black", fill = "#CCCCCC") + theme_bw() + scale_y_continuous("% of OS data tables") + xlab("Latency (days since field collection)")

ggsave("fieldDataLatency.png", width = 3, height = 2)
