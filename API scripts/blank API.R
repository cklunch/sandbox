library(httr)
library(jsonlite)
library(dplyr, quietly=T)
library(devtools)
library(downloader)
options(stringsAsFactors = F)
req <- GET("https://data.neonscience.org/api/v0/products/DP1.00094.001")
avail <- fromJSON(content(req, as="text"), simplifyDataFrame=T, flatten=T)
months <- unlist(avail$data$siteCodes$availableDataUrls)

urls <- unlist(avail$data$siteCodes$availableDataUrls)
urls
fls <- GET(urls[grep("MOAB/2017-03", urls)])
list.files <- fromJSON(content(fls, as="text"))
list.files$data$files$name[grep('.zip', list.files$data$files$name)]

head(list.files$data$files)
#brd.count <- read.delim(brd.files$data$files$url
#                        [intersect(grep("countdata", brd.files$data$files$name),
#                                   grep("basic", brd.files$data$files$name))], sep=",")
Sys.time()
downloader::download(list.files$data$files$url[grep("468000_7220000_image", list.files$data$files$name)],
         paste(getwd(), list.files$data$files$name[grep("468000_7220000_image", list.files$data$files$name)], sep="/"))
Sys.time()


# new "package" section in response
req <- GET("https://cert-data.neonscience.org/api/v0/products/DP1.10003.001")
avail <- fromJSON(content(req, as="text"), simplifyDataFrame=T, flatten=T)
months <- unlist(avail$data$siteCodes$availableDataUrls)

urls <- unlist(avail$data$siteCodes$availableDataUrls)
head(urls)
fls <- GET(urls[grep("ABBY/2019-05", urls)])
list.files <- fromJSON(content(fls, as="text"))
head(list.files)
list.files$data$packages
list.files$data$packages$type

# what does no files look like?
fls <- GET("https://cert-data.neonscience.org/api/v0/data/DP1.10003.001/ABBY/2017-07")
list.files <- fromJSON(content(fls, as="text"))
list.files$data$packages
length(list.files$data$packages)
download(list.files$data$packages$url[which(list.files$data$packages$type=='basic')],
         '/Users/clunch/Desktop')

con <- curl::curl("https://cert-data.neonscience.org/api/v0/data/package/DP1.10022.001/ABBY/2019-05?package=basic")
jsonlite::prettify(readLines(con)) #no

req <- curl::curl_fetch_memory("https://cert-data.neonscience.org/api/v0/data/package/DP1.10022.001/ABBY/2019-05?package=basic")
fromJSON(content(req, as="text")) #no

curl::curl_download("https://cert-data.neonscience.org/api/v0/data/package/DP1.10022.001/ABBY/2019-05?package=basic",
                    destfile='/Users/clunch/Desktop')

h <- curl::new_handle()
curl::handle_getheaders(h) # in help file, but not an exported function

base::curlGetHeaders("https://cert-data.neonscience.org/api/v0/data/package/DP1.10022.001/ABBY/2019-05?package=basic")
# yahtzee
h <- base::curlGetHeaders("https://cert-data.neonscience.org/api/v0/data/package/DP1.10022.001/ABBY/2019-05?package=basic")

reh <- httr::HEAD("https://int-data.neonscience.org/api/v0/data/package/DP1.00001.001/OAES/2017-02?package=basic")
httr::headers(reh)

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

req <- httr::GET("http://data.neonscience.org/api/v0/locations/CFGLOC113784")
jsonlite::fromJSON(httr::content(req, as="text"))

"http://data.neonscience.org/api/v0/locations/TALL_001.basePlot.div.32.4.10"

# location on CERT
req <- GET("https://cert-data.ci.neoninternal.org/api/v0/locations/HARV_052.basePlot.vst")
req <- GET("https://cert-data.ci.neoninternal.org/api/v0/locations/HARV_047.basePlot.ltr")
jsonlite::fromJSON(content(req, as="text"))

req <- httr::GET("http://cert-data.neonscience.org/api/v0/locations/SCBI")

req <- GET("https://cert-data.neonscience.org/api/v0/products/DP1.20288.001")


# testing AOP problems

req.aop <- httr::GET("http://data.neonscience.org/api/v0/products/DP3.30026.001")
avail.aop <- fromJSON(content(req.aop, as="text"), simplifyDataFrame=T, flatten=T)
cam.urls <- unlist(avail.aop$data$siteCodes$availableDataUrls)
cam <- httr::GET(cam.urls[grep("SCBI/2017", cam.urls)])
cam.files <- fromJSON(content(cam, as="text"))
head(cam.files$data$files$name)
download(cam.files$data$files$url[grep("NEON_D17_SJER_DP1_256000_4113000_classified_point_cloud_colorized", cam.files$data$files$name)],
         paste(getwd(), "/ptcloud.laz", sep=""))
downloader::download(cam.files$data$files$url[1], "/Users/clunch/Desktop/ORNL_DP3_30006_test.h5")
downloader::download(cam.files$data$files$url[10], "/Users/clunch/Desktop/test_file.zip")

t <- tryCatch(
  {
    suppressWarnings(downloader::download(cam.files$data$files$url[11], 
                                          destfile='/Users/clunch/Desktop/test_file.pdf',
                                          mode="wb", quiet=T))
  }, error = function(e) { e } )

h <- httr::HEAD(cam.files$data$files$url[10])
headers(h)

h1 <- httr::HEAD(cam.files$data$files$url[11])
headers(h1)

hh <- httr::HEAD("https://neon-aop-products.s3.data.neonscience.org/2017/FullSite/D02/2017_SCBI_2/Metadata/Spectrometer/Reports/2017_SCBI_2_L3_spectrometer_processing.pdf?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20210212T145942Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=pub-internal-read%2F20210212%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Signature=175216e88875c945c084b47ee3b080715c29a2643c9e89632613c22ef6361637")
headers(hh)

# taxon
req <- GET("http://data.neonscience.org/api/v0/taxonomy?taxonTypeCode=BIRD&offset=0&limit=100")
req.tax <- jsonlite::fromJSON(content(req, as="text"))

req <- GET("http://data.neonscience.org/api/v0/taxonomy?family=Pinaceae")
req.tax <- content(req, as="parsed")

req <- GET("http://data.neonscience.org/api/v0/taxonomy?taxonTypeCode=BIRD&offset=0&limit=1000&verbose=T")
req.tax <- jsonlite::fromJSON(content(req, as="text"))

req <- GET("http://data.neonscience.org/api/v0/taxonomy?scientificname=Viburnum%20lantanoides%20Michx.")
req.tax <- content(req, as="parsed")


# testing
req <- httr::GET("http://data.neonscience.org/api/v0/data/DP1.20166.001/PRLA/2017-09")
avail <- jsonlite::fromJSON(httr::content(req, as="text"))



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

for(i in 1:nrow(fsp)) {
  fsp.samp <- get.os.sample(tag=fsp$sampleID[i])
  if(length(fsp.samp)>0) {
    print(fsp$sampleID[i])
  }
}
length(unique(fsp$sampleID))
