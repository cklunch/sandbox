# testing removeDups()
options(stringsAsFactors=F)

cfc <- read.delim("/Users/clunch/GitHub/sandbox/cfc_lignin_dups.csv", sep=",")
cfc.var <- read.delim("/Users/clunch/GitHub/biogeochemistryIPT/canopyFoliar/defData/cfc_datapub_L1.txt", sep="\t")

variables <- cfc.var
table <- "cfc_lignin_pub"
data <- cfc

source('~/GitHub/how-to-make-a-data-product/Publication workbook OS/removeDups.R')

data.rem <- removeDups(data=cfc, variables=cfc.var, table='cfc_lignin_pub')

# testing on beetle data - can't, because this doesn't correspond to a single table
bet.var <- 
bet.rem <- removeDups(data=bet_all_records, variables=cfc.var, table='cfc_lignin_pub')


  