
if (file.exists('/Users/kthibault/')){
  mypathtoCKL <- '/Users/kthibault/Documents/GitHub/sandbox'
}

options(stringsAsFactors=F)

library(dplyr)
library(stringr)
library(tidyr)
library(readxl)

dat <- read_excel(paste(mypathtoCKL, 'Latency.xlsx', sep = '/'), sheet = 1, na = "NA")

statusByDp <- dat %>% group_by(`Data Product ID`, `Data Product Name`) %>% summarise(meanStatus = round(mean(`Legacy ingest status (%)`),0), minStatus = round(min(`Legacy ingest status (%)`),0), maxStatus = round(max(`Legacy ingest status (%)`),0))

delayByDp <- dat %>% group_by(`Data Product ID`, `Data Product Name`, `Legacy delay driver`) %>% filter(!is.na(`Legacy delay driver`)) %>% summarise(completionDate = max(`Expected Legacy Ingest Completion`))

completedDp <- dat %>% filter(`Legacy ingest status (%)` == 100) %>% distinct(`Data Product ID`, `Data Product Name`)

