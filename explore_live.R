library(neonUtilities)
library(geoNEON)
library(raster)
library(rhdf5)

options(stringsAsFactors = F)

# stack data from portal
stackByTable("~/Downloads/NEON_par.zip")
stackByTable("~/Downloads/NEON_par", folder=T) # if unzipped

# download data with zipsByProduct()
zipsByProduct(dpID="DP1.10098.001", site="WREF", 
              package="expanded", check.size=T,
              savepath="~/Downloads")

# stack data from zipsByProduct
stackByTable("~/Downloads/filesToStack10098/", folder=T)

# download AOP data
byTileAOP(dpID="DP3.30015.001", site="WREF", year="2017",
          easting=580000, northing=5075000, savepath="~/Downloads")

# load par data
par30 <- read.delim("~/Downloads/NEON_par/stackedFiles/PARPAR_30min.csv", sep=",")
View(par30)

parvar <- read.delim("~/Downloads/NEON_par/stackedFiles/variables.csv", sep=",")
View(parvar)

par30$startDateTime <- as.POSIXct(par30$startDateTime, 
                                  format="%Y-%m-%d T %H:%M:%S Z", 
                                  tz="GMT")
head(par30)

plot(PARMean~startDateTime, 
     data=par30[which(par30$verticalPosition==80),],
     type="l")

# veg structure data
vegmap <- read.delim("~/Downloads/filesToStack10098/stackedFiles/vst_mappingandtagging.csv", 
                     sep=",")
View(vegmap)

vegind <- read.delim("~/Downloads/filesToStack10098/stackedFiles/vst_apparentindividual.csv",
                     sep=",")
View(vegind)

vegmap <- geoNEON::def.calc.geo.os(vegmap, "vst_mappingandtagging")

veg <- merge(vegind, vegmap, by=c("individualID", "namedLocation",
                                  "domainID","siteID","plotID"))

symbols(veg$adjEasting[which(veg$plotID=="WREF_085")],
        veg$adjNorthing[which(veg$plotID=="WREF_085")],
        circles=veg$stemDiameter[which(veg$plotID=="WREF_085")]/100,
        xlab="Easting", ylab="Northing", inches=F)

# AOP data
chm <- raster("~/Downloads/DP3.30015.001/2017/FullSite/D16/2017_WREF_1/L3/DiscreteLidar/CanopyHeightModelGtif/NEON_D16_WREF_DP3_580000_5075000_CHM.tif")

plot(chm, col=topo.colors(6))







#####
install.packages("httr")
install.packages("jsonlite")
install.packages("downloader")
library(httr)
library(jsonlite)
library(downloader)

req <- GET("http://data.neonscience.org/api/v0/products/DP1.10003.001")
req
req.content <- content(req, as="parsed")
req.content

available <- fromJSON(content(req, as="text"))
available
available$data$siteCodes

bird.urls <- unlist(available$data$siteCodes$availableDataUrls)
bird.urls

bird <- GET(bird.urls[grep("WOOD/2015-07", bird.urls)])
bird.files <- fromJSON(content(bird, as="text"))
bird.files

bird.count <- read.delim(bird.files$data$files$url[intersect(grep("countdata", 
                                                        bird.files$data$files$name),
                                                        grep("basic",
                                                             bird.files$data$files$name))],
                         sep=",")
View(bird.count)

loon.req <- GET("http://data.neonscience.org/api/v0/taxonomy/?family=Gaviidae")
loon.list <- fromJSON(content(loon.req, as="text"))
loon.list

loon.req <- GET("http://data.neonscience.org/api/v0/taxonomy/?family=Gaviidae&verbose=true")
loon.list <- fromJSON(content(loon.req, as="text"))
loon.list

