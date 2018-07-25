library(httr)
library(jsonlite)
library(dplyr, quietly=T)
library(devtools)
req <- GET("http://data.neonscience.org/api/v0/products/DP1.10098.001")
avail <- fromJSON(content(req, as="text"), simplifyDataFrame=T, flatten=T)
avail
avail$data$siteCodes
urls <- unlist(avail$data$siteCodes$availableDataUrls)
urls
fls <- GET(urls[grep("TEAK", urls)])
list.files <- fromJSON(content(fls, as="text"))
list.files$data$files
#brd.count <- read.delim(brd.files$data$files$url
#                        [intersect(grep("countdata", brd.files$data$files$name),
#                                   grep("basic", brd.files$data$files$name))], sep=",")
downloader::download(list.files$data$files$url[grep("NEON_D17_TEAK_DP3_316000_4106000_DTM", list.files$data$files$name)],
         paste(getwd(), list.files$data$files$name[grep("NEON_D17_TEAK_DP3_316000_4106000_DTM", list.files$data$files$name)], sep="/"))


#library(downloader)
#download(aop.files$data$files$url[grep("20170328192931", aop.files$data$files$name, fixed=T)],
#         paste(getwd(), "/image.tif", sep=""))

# downloader
req <- httr::GET("http://data.neonscience.org/api/v0/data/DP1.10055.001/TALL/2016-07")
avail <- jsonlite::fromJSON(httr::content(req, as="text"))
downloader::download(avail$data$files$url[grep("zip", avail$data$files$name, fixed=T)[1]], 
                     paste(getwd(), "test.zip", sep="/"), mode="wb")

download.file(avail$data$files$url[grep("zip", avail$data$files$name, fixed=T)[1]], 
              paste(getwd(), "test.zip", sep="/"), method="libcurl")


downloader::download("https://neon-prod-pub-1.s3.data.neonscience.org/NEON.DOM.SITE.DP1.10055.001/PROV/TALL/20160701T000000--20160801T000000/basic/NEON.D08.TALL.DP1.10055.001.2016-07.basic.20170727T183203Z.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20171127T221754Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=pub-internal-read%2F20171127%2Fdata%2Fs3%2Faws4_request&X-Amz-Signature=ffaa8a0a045cb3538bb7cda8fd05cdc0f9de2a0d17a88193f13a218b82ccfa79", 
                     paste(getwd(), "test.zip", sep="/"))


# location
req <- GET("http://data.neonscience.org/api/v0/locations/HARV_052.basePlot.vst")
jsonlite::fromJSON(content(req, as="text"))
#req.par <- content(req, as="parsed")

# location on CERT
req <- GET("https://cert-data.ci.neoninternal.org/api/v0/locations/HARV_052.basePlot.vst")
jsonlite::fromJSON(content(req, as="text"))


# testing AOP problems

req.aop <- GET("http://data.neonscience.org/api/v0/products/DP1.30003.001")
avail.aop <- fromJSON(content(req.aop, as="text"), simplifyDataFrame=T, flatten=T)
cam.urls <- unlist(avail.aop$data$siteCodes$availableDataUrls)
cam <- GET(cam.urls[grep("SJER/2017-03", cam.urls)])
cam.files <- fromJSON(content(cam, as="text"))
head(cam.files$data$files$name)
download(cam.files$data$files$url[grep("NEON_D17_SJER_DP1_256000_4113000_classified_point_cloud_colorized", cam.files$data$files$name)],
         paste(getwd(), "/ptcloud.laz", sep=""))


# taxon
req <- GET("http://data.neonscience.org/api/v0/taxonomy?taxonTypeCode=BIRD&offset=0&limit=100")
req.tax <- content(req, as="parsed")

req <- GET("http://data.neonscience.org/api/v0/taxonomy?family=Pinaceae")
req.tax <- content(req, as="parsed")


# CRAN downloads
install_github("metacran/cranlogs")
metD <- cran_downloads("metScanR", from="2017-01-01", to="last-day")
mean(metD$count)
sum(metD$count)

neoD <- cran_downloads("nneo", from="2017-06-15", to="last-day")
mean(neoD$count)
sum(neoD$count)


