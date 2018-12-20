# testing removeDups()
options(stringsAsFactors=F)

cfc <- read.delim("/Users/clunch/GitHub/sandbox/cfc_lignin_dups.csv", sep=",")
cfc.var <- read.delim("/Users/clunch/GitHub/biogeochemistryIPT/canopyFoliar/defData/PublicationWorkbook_Plant foliar physical and chemical properties.txt", sep="\t")

variables <- cfc.var
table <- "cfc_lignin_pub"
data <- cfc

source('~/GitHub/how-to-make-a-data-product/Publication workbook OS/removeDups.R')

data.rem <- removeDups(data=cfc, variables=cfc.var, table='cfc_lignin_pub')

pb <- utils::txtProgressBar(style=3)
utils::setTxtProgressBar(pb,0)
for(i in 1:100) {
  Sys.sleep(1)
  utils::setTxtProgressBar(pb, i/100)
}

  