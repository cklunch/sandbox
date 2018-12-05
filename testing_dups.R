# testing removeDups()
options(stringsAsFactors=F)

cfc <- read.delim("/Users/clunch/GitHub/sandbox/cfc_lignin_dups.csv", sep=",")
cfc.var <- read.delim("/Users/clunch/GitHub/biogeochemistryIPT/canopyFoliar/defData/cfc_datapub_L1.txt", sep="\t")

variables <- cfc.var
table <- "cfc_lignin_pub"
data <- cfc

source('~/GitHub/how-to-make-a-data-product/Publication workbook OS/removeDups.R')

data.rem <- removeDups(data=cfc, variables=cfc.var, table='cfc_lignin_pub')
# flagging is working on case 1 but not case 2 - ie working on resolveable dups,
# but not on unresolveable dups. and failing to resolve when only remarks and uid differ

# dplyr
data.d <- dplyr::distinct(cfc, cfc$ligninSampleID, cfc$analyticalRepNumber, .keep_all=T)
# doesn't treat variables as a key, treats them as the only variables to be considered
# in determining what's a duplicate

# data.table
data.t <- data.table(cfc, key=key)
data.tr <- data.t[,.N,by=key(data.t)]
# same behavior as distinct()

