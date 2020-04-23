library(neonUtilities)
options(stringsAsFactors = F)

m <- read.delim('https://www.neonscience.org/science-design/field-sites/export', sep=',')
mat <- data.frame(matrix(unlist(strsplit(m$Mean.Annual.Temperature, '/', fixed=T)), ncol=2, byrow=T))
mat[,1] <- gsub('C', '', mat[,1])
mat <- mat[,1]
mat <- as.numeric(mat)

map <- gsub(' mm', '', m$Mean.Annual.Precipitation)
map <- as.numeric(map)

mm <- cbind(m$Site.ID, mat, map)
mm <- data.frame(mm)
names(mm) <- c('siteID','mat','map')

scc <- loadByProduct(dpID='DP1.10008.001', package='expanded', check.size=F)
sch <- scc$spc_biogeochem

sch <- merge(sch, mm, by='siteID', all.x=T)
sch$carbonTot <- as.numeric(sch$carbonTot)
sch$mat <- as.numeric(sch$mat)
sch$map <- as.numeric(sch$map)

par(mfrow=c(1,2))
plot(sch$carbonTot~sch$mat, pch=20, 
     xlab='Mean annual temperature',
     ylab='Total soil carbon', tck=0.01)
plot(sch$carbonTot~sch$map, pch=20,
     xlab='Mean annual precipitation',
     ylab='Total soil carbon', tck=0.01)

plot(sch$nitrogenTot~sch$mat, pch=20)
plot(sch$nitrogenTot~sch$map, pch=20)

plot(sch$carbonTot[grep('O', sch$horizonName, invert=T)]~sch$mat[grep('O', sch$horizonName, invert=T)], pch=20)
plot(sch$carbonTot[grep('O', sch$horizonName, invert=T)]~sch$map[grep('O', sch$horizonName, invert=T)], pch=20)

sc <- aggregate(cbind(sch$carbonTot, sch$mat, sch$map), 
                by=list(sch$siteID, sch$horizonName), FUN=mean, na.rm=T)
names(sc) <- c('site','horizon','carbonTot','mat','map')

plot(sc$carbonTot~sc$mat, pch=20)
plot(sc$carbonTot~sc$map, pch=20)

sp <- aggregate(cbind(sch$carbonTot, sch$mat, sch$map), 
                by=list(sch$siteID, sch$plotID), FUN=mean, na.rm=T)
names(sp) <- c('site','plot','carbonTot','mat','map')

plot(sp$carbonTot~sp$mat, pch=20)
plot(sp$carbonTot~sp$map, pch=20)



