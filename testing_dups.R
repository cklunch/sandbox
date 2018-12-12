# testing removeDups()
options(stringsAsFactors=F)

cfc <- read.delim("/Users/clunch/GitHub/sandbox/cfc_lignin_dups.csv", sep=",")
cfc.var <- read.delim("/Users/clunch/GitHub/biogeochemistryIPT/canopyFoliar/defData/PublicationWorkbook_Plant foliar physical and chemical properties.txt", sep="\t")

variables <- cfc.var
table <- "cfc_lignin_pub"
data <- cfc

source('~/GitHub/how-to-make-a-data-product/Publication workbook OS/removeDups.R')

data.rem <- removeDups(data=cfc, variables=cfc.var, table='cfc_lignin_pub')



  