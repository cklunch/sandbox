library(rhdf5)
library(terra)

getDateRaster <- function(filepath) {
  
  site <- regmatches(filepath,
                     regexpr('[.][A-Z]{4}[.]', 
                             filepath))
  site <- gsub('[.]', '', site)
  dataSelectIndex <- h5read(paste(site,
                                  '/Reflectance/Metadata/Ancillary_Imagery/Data_Selection_Index',
                                  sep=''), 
                            file=filepath, read.attributes=T)
  dataSelectLookup <- attributes(dataSelectIndex)$Data_Files
  dataSelectLookupSplit <- unlist(strsplit(dataSelectLookup, split=','))
  
  dateLookup <- regmatches(dataSelectLookupSplit,
                           regexpr('20[0-9]{2}[0-9]{4}', 
                                   dataSelectLookupSplit))
  
  epsg <- h5read(paste(site, '/Reflectance/Metadata/Coordinate_System/EPSG Code',
                       sep=''), file=filepath)
  xmin <- as.numeric(regmatches(filepath, regexpr('[0-9]{3}000', filepath)))
  ymin <- as.numeric(regmatches(filepath, regexpr('[0-9]{4}000', filepath)))
  
  dateRaster <- dataSelectIndex
  for(i in 1:ncol(dataSelectIndex)) {
    for(j in 1:nrow(dataSelectIndex)) {
      dateRaster[i,j] <- dateLookup[dataSelectIndex[i,j]]
    }
  }
  
  dateRaster <- rast(dateRaster, crs=paste('EPSG:', epsg, sep=''),
                     extent=ext(c(xmin, xmin+1000, ymin, ymin+1000)))
  
  return(dateRaster)
  
}
