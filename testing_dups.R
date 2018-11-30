# testing removeDups()
options(stringsAsFactors=F)

cfc <- read.delim("/Users/clunch/Desktop/filesToStack10026/stackedFiles/cfc_lignin.csv", sep=",")
cfc.var <- read.delim("/Users/clunch/GitHub/biogeochemistryIPT/canopyFoliar/defData/cfc_datapub_L1.txt", sep="\t")

variables <- cfc.var
table <- "cfc_lignin_pub"
data <- cfc

