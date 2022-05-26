library(neonUtilities)
mos <- loadByProduct(dpID='DP1.10043.001', site=c('TOOL','BARR','HEAL','DEJU','BONA'), 
                     package='expanded', check.size=F, token=Sys.getenv('NEON_TOKEN'))

mossp <- aggregate(mos$mos_expertTaxonomistIDProcessed$individualCount, 
                   by=list(mos$mos_expertTaxonomistIDProcessed$scientificName), 
                   FUN=sum, na.rm=T)
names(mossp) <- c('scientificName','totalIndividualCount')
mossp <- mossp[order(mossp$totalIndividualCount, decreasing=T),]

mosspr <- aggregate(mos$mos_expertTaxonomistIDRaw$individualCount, 
                   by=list(mos$mos_expertTaxonomistIDRaw$scientificName), 
                   FUN=sum, na.rm=T)
names(mosspr) <- c('scientificName','totalIndividualCount')
mosspr <- mosspr[order(mosspr$totalIndividualCount, decreasing=T),]
# makes no difference

write.table(mossp, '/Users/clunch/Desktop/AK_mos_sp.csv', sep=',', row.names=F)

asp <- mos$mos_expertTaxonomistIDProcessed[which(mos$mos_expertTaxonomistIDProcessed$scientificName=='Aedes sp.'),]
asp$year <- lubridate::year(asp$collectDate)
ay <- aggregate(asp$individualCount, by=list(asp$siteID, asp$year), FUN=sum)


# calculate total # individuals
mos.all <- merge(mos$mos_expertTaxonomistIDProcessed, mos$mos_sorting, 
                 by=c('subsampleID','subsampleCode','domainID','siteID','plotID'))
mos.all$totalCount <- mos.all$individualCount*(mos.all$totalWeight/mos.all$subsampleWeight)

# vegetation?
mos.all <- merge(mos.all, mos$mos_trapping, 
                 by=c('sampleID','sampleCode','domainID','siteID','plotID'))
plot(mos.all$totalCount~mos.all$elevation, pch=20)
