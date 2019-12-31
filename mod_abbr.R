library(devtools)
setwd("~/GitHub/NEON-utilities/neonUtilities")
load("~/GitHub/NEON-utilities/neonUtilities/R/sysdata.rda")
mod <- tidyr::separate(table_types, col='tableName', into=c('mod', 'nm', 'nm2'), sep='_', fill='right')

dpmods <- unique(mod[,c('productID','mod')])
moddups <- dpmods[union(which(duplicated(dpmods$mod)), which(duplicated(dpmods$mod, fromLast=T))),]
moddups <- moddups[order(moddups$mod),]
