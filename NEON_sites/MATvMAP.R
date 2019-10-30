options(stringsAsFactors = F)

m <- read.delim('https://www.neonscience.org/science-design/field-sites/export', sep=',')
mat <- data.frame(matrix(unlist(strsplit(m$Mean.Annual.Temperature, '/', fixed=T)), ncol=2, byrow=T))
mat[,1] <- gsub('C', '', mat[,1])
mat <- mat[,1]
mat <- as.numeric(mat)

map <- gsub(' mm', '', m$Mean.Annual.Precipitation)
map <- as.numeric(map)

plot(map~mat, pch=20, tck=0.01, xlab='Mean Annual Temperature (C)',
     ylab='Mean Annual Precipitation (mm)', col='blue')
points(map[which(m$Site.Subtype=='')]~mat[which(m$Site.Subtype=='')], 
       pch=20, col='green')

plot(map~mat, tck=0.01, xlab='Mean Annual Temperature (C)',
     ylab='Mean Annual Precipitation (mm)', pch=NA)
text(map[which(m$Site.Subtype!='')]~mat[which(m$Site.Subtype!='')], 
     labels=m$Site.ID[which(m$Site.Subtype!='')], cex=0.5, col='blue')
text(map[which(m$Site.Subtype=='')]~mat[which(m$Site.Subtype=='')], 
     labels=m$Site.ID[which(m$Site.Subtype=='')], cex=0.5, col='olivedrab')

