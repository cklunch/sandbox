library(httr)
library(jsonlite)
library(dplyr, quietly=T)
library(devtools)
options(stringsAsFactors = F)
req <- GET("https://data.neonscience.org/api/v0/products/DP1.20288.001")
avail <- fromJSON(content(req, as="text"), simplifyDataFrame=T, flatten=T)
months <- unlist(avail$data$siteCodes$availableDataUrls)

urls <- unlist(avail$data$siteCodes$availableDataUrls)
urls
fls <- GET(urls[grep("WLOU/2019-07", urls)])
list.files <- fromJSON(content(fls, as="text"))
head(list.files$data$files)
#brd.count <- read.delim(brd.files$data$files$url
#                        [intersect(grep("countdata", brd.files$data$files$name),
#                                   grep("basic", brd.files$data$files$name))], sep=",")
Sys.time()
downloader::download(list.files$data$files$url[grep("468000_7220000_image", list.files$data$files$name)],
         paste(getwd(), list.files$data$files$name[grep("468000_7220000_image", list.files$data$files$name)], sep="/"))
Sys.time()

library(downloader)
download(list.files$data$files$url[grep("waq_instantaneous", list.files$data$files$name, fixed=T)[1]],
        '/Users/clunch/Desktop/test.csv')

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
req <- httr::GET("http://data.neonscience.org/api/v0/locations/SCBI_006.basePlot.cfc")
jsonlite::fromJSON(httr::content(req, as="text"))
#req.par <- content(req, as="parsed")

req <- httr::GET("http://data.neonscience.org/api/v0/locations/SCBI")

# location on CERT
req <- GET("https://cert-data.ci.neoninternal.org/api/v0/locations/HARV_052.basePlot.vst")
jsonlite::fromJSON(content(req, as="text"))


# testing AOP problems

req.aop <- httr::GET("http://data.neonscience.org/api/v0/products/DP3.30006.001")
avail.aop <- fromJSON(content(req.aop, as="text"), simplifyDataFrame=T, flatten=T)
cam.urls <- unlist(avail.aop$data$siteCodes$availableDataUrls)
cam <- httr::GET(cam.urls[grep("ORNL/2017", cam.urls)])
cam.files <- fromJSON(content(cam, as="text"))
head(cam.files$data$files$name)
download(cam.files$data$files$url[grep("NEON_D17_SJER_DP1_256000_4113000_classified_point_cloud_colorized", cam.files$data$files$name)],
         paste(getwd(), "/ptcloud.laz", sep=""))
downloader::download(cam.files$data$files$url[1], "/Users/clunch/Desktop/ORNL_DP3_30006_test.h5")

# taxon
req <- GET("http://data.neonscience.org/api/v0/taxonomy?taxonTypeCode=BIRD&offset=0&limit=100")
req.tax <- jsonlite::fromJSON(content(req, as="text"))

req <- GET("http://data.neonscience.org/api/v0/taxonomy?family=Pinaceae")
req.tax <- content(req, as="parsed")

req <- GET("http://data.neonscience.org/api/v0/taxonomy?taxonTypeCode=BIRD&offset=0&limit=1000&verbose=T")
req.tax <- jsonlite::fromJSON(content(req, as="text"))


# CRAN downloads
install_github("metacran/cranlogs")
metD <- cran_downloads("metScanR", from="2017-01-01", to="last-day")
mean(metD$count)
sum(metD$count)

neoD <- cran_downloads("nneo", from="2017-06-15", to="last-day")
mean(neoD$count)
sum(neoD$count)

# sites
req <- GET("http://data.neonscience.org/api/v0/sites/NIWO")
req.site <- jsonlite::fromJSON(content(req, as="text"))

# testing http v https
req <- GET("http://data.neonscience.org/api/v0/products/DP1.10072.001")
avail <- fromJSON(content(req, as="text"), simplifyDataFrame=T, flatten=T)
months <- unlist(avail$data$siteCodes$availableDataUrls)

req.s <- GET("https://data.neonscience.org/api/v0/products/DP1.10072.001")
avail.s <- fromJSON(content(req.s, as="text"), simplifyDataFrame=T, flatten=T)
months.s <- unlist(avail.s$data$siteCodes$availableDataUrls)


# Christine's test
get_products <- function(ht="http"){
  pr <- jsonlite::fromJSON(txt = paste0(ht, "://data.neonscience.org/api/v0/products"))
  pr <- pr[["data"]]
  return(pr)
}

getURLs <- function(ulist){
  uvec <- character()
  for(i in 1:nrow(ulist))
  {
    uvec <- c(uvec, unlist(ulist$siteCodes[[i]]$availableDataUrls))
  }
  return(uvec)
}

pr_http <- get_products("http")
http_dataURLs <- getURLs(pr_http)

pr_https <- get_products("https")
https_dataURLs <- getURLs(pr_https)

in_http_not_https <- setdiff(http_dataURLs, https_dataURLs)
in_https_not_http <- setdiff(https_dataURLs, http_dataURLs)

write.csv(in_https_not_http, "~/Downloads/in_https_not_http.csv", row.names = F)
write.csv(in_http_not_https, "~/Downloads/in_http_not_https.csv", row.names = F)

