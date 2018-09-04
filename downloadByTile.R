library(neonUtilities)
library(geoNEON)
library(httr)
library(jsonlite)
library(downloader)
options(stringsAsFactors=F)

# Download & stack plant data - canopy foliar & veg structure
zipsByProduct(dpID="DP1.10026.001", site="all", package="expanded", 
              savepath="/Users/clunch/Dropbox/data")
zipsByProduct(dpID="DP1.10098.001", site="all", package="basic", 
              savepath="/Users/clunch/Dropbox/data")

stackByTable("/Users/clunch/Dropbox/data/filesToStack10026", folder=T)
stackByTable("/Users/clunch/Dropbox/data/filesToStack10098", folder=T)

# Load data & merge tables; subset veg structure data to cfc plants
cfcField <- read.delim("/Users/clunch/Dropbox/data/filesToStack10026/stackedFiles/cfc_fieldData.csv", sep=",")
cfcCN <- read.delim("/Users/clunch/Dropbox/data/filesToStack10026/stackedFiles/cfc_carbonNitrogen.csv", sep=",")
cfcLignin <- read.delim("/Users/clunch/Dropbox/data/filesToStack10026/stackedFiles/cfc_lignin.csv", sep=",")

cfc <- merge(cfcField, cfcCN, by=c("sampleID", "namedLocation", "domainID", "siteID", "plotID"))
cfc <- merge(cfc, cfcLignin, by=c("sampleID", "namedLocation", "domainID", "siteID", "plotID"))

vegmap <- read.delim("/Users/clunch/Dropbox/data/filesToStack10098/stackedFiles/vst_mappingandtagging.csv", sep=",")
vegmap <- vegmap[which(vegmap$siteID %in% unique(cfc$siteID)),]

# Get precise locations of tagged individuals
vegmap <- def.calc.geo.os(vegmap, "vst_mappingandtagging")

# Merge cfc & vst data
# NOTE: THIS CODE COVERS ONLY THE FOLIAR DATA FROM WOODY INDIVIDUALS
# THE geoNEON PACKAGE DOES NOT YET COVER HERBACEOUS FOLIAR CHEMISTRY LOCATIONS
cfc <- cfc[,which(names(cfc) %in% c("sampleID", "namedLocation", "domainID", "siteID", "plotID", "subplotID", 
                                    "collectDate", "tagID", "individualID", "taxonID", "clipCellNumber", "clipID", 
                                    "clipLength", "clipWidth", "percentCoverClip", "nitrogenPercent", 
                                    "carbonPercent", "dryMass", "ligninPercent", "cellulosePercent"))]
cfc <- merge(cfc, vegmap, by=c("individualID", "domainID", "siteID", "plotID"))

# Download AOP data

# First figure out the tiles needed
cfc$tileEasting <- floor(cfc$adjEasting/1000)*1000
cfc$tileNorthing <- floor(cfc$adjNorthing/1000)*1000
utms <- data.frame(cbind(cfc$tileEasting, cfc$tileNorthing))
colnames(utms) <- c("easting", "northing")
tiles <- unique(utms)
tiles <- tiles[which(!is.na(tiles$easting) & !is.na(tiles$northing)),]

# Get URLs for veg indices
n.req <- httr::GET("http://data.neonscience.org/api/v0/products/DP3.30026.001")
avail <- jsonlite::fromJSON(httr::content(n.req, as="text"))
urls <- unlist(avail$data$siteCodes$availableDataUrls)

# Download the relevant tiles
for(i in unique(cfc$siteID)) {
  print(i)
  ind <- grep(i, urls)
  if(length(ind)==0) {
    next
  }
  for(j in 1:length(ind)) {
    print(j)
    fls <- httr::GET(urls[ind[j]])
    list.files <- jsonlite::fromJSON(httr::content(fls, as="text"))
    for(k in 1:nrow(tiles)) {
      print(tiles[k,])
      if(length(intersect(intersect(grep(tiles$easting[k], list.files$data$files$name), 
                                    grep(tiles$northing[k], list.files$data$files$name)),
                          grep("VegIndices", list.files$data$files$name)))>0) {
        downloader::download(list.files$data$files$url[intersect(intersect(grep(tiles$easting[k], 
                                                                                list.files$data$files$name), 
                                                                           grep(tiles$northing[k], 
                                                                                list.files$data$files$name)),
                                                                 grep("VegIndices",
                                                                      list.files$data$files$name))],
                             paste("/Users/clunch/Dropbox/data/AOP", 
                                   list.files$data$files$name[intersect(intersect(grep(tiles$easting[k], 
                                                                                       list.files$data$files$name), 
                                                                                  grep(tiles$northing[k], 
                                                                                       list.files$data$files$name)),
                                                                        grep("VegIndices",
                                                                             list.files$data$files$name))], 
                                   sep="/"), mode="wb")
      } else {
        next
      }
    }
  }
}
