# CRAN downloads
install_github("metacran/cranlogs")
metD <- cran_downloads("metScanR", from="2017-01-01", to="last-day")
mean(metD$count)
sum(metD$count)

neoD <- cran_downloads("nneo", from="2017-06-15", to="last-day")
mean(neoD$count)
sum(neoD$count)




install.packages("nneo")
library(nneo)
dat <- nneo_data("DP1.00098.001","HEAL","2016-05")
dat$data$files
datfil <- nneo_file("DP1.00098.001","HEAL","2016-05",filename=dat$data$files$name[1], verbose=TRUE)
# doesn't work

dat <- nneo_wrangle(site_code="NIWO", time_start="2017-07-01", time_end="2017-11-01", 
                    data_var="dust",
                    time_agr=30, package="basic")



install.packages("metScanR")
library(metScanR)




