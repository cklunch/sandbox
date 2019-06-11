##############################################################################################
#' @title Extract elements of a NEON eddy covariance HDF5 file and convert to tabular format

#' @author
#' Claire Lunch \email{clunch@battelleecology.org}

#' @description
#' Given a NEON eddy covariance HDF5 file, convert to tabular format for the variable and averaging interval selected.

#' @param filepath The location of the HDF5 file [character]
#' @param site The NEON site of the data [character]
#' @param level The level of data to extract; one of dp01, dp02, dp03, dp04, dp0p [character]
#' @param var The variable set to extract, e.g. co2Turb [character]
#' @param avg The averaging interval to extract, in minutes [numeric]

#' @return A data frame of the available data for the specified variable.

#' @references
#' License: GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007

# Changelog and author contributions / copyrights
#   2018-05-25 (Claire Lunch): Original creation
##############################################################################################

flattenH5EC <- function(filepath, site, level, var, avg) {
  
  # read in data
  dat.list <- rhdf5::h5read(filepath, paste(paste("/", site, sep=""), level, "data", var, sep="/"))
  q.list <- rhdf5::h5read(filepath, paste(paste("/", site, sep=""), level, "qfqm", var, sep="/"))
  if(length(grep(paste(paste("/", site, sep=""), level, "ucrt", var, sep="/"), h5ls(filepath)))>0) {
    u.list <- rhdf5::h5read(filepath, paste(paste("/", site, sep=""), level, "ucrt", var, sep="/"))
  } else {
    u.list <- NULL
  }
  
  # get index of components with selected avg interval and subset
  # this workflow means if you don't put in an avg when there are multiple options, they'll be merged
  if(!is.na(avg)) {
    ind <- grep(paste(avg, "m", sep=""), names(dat.list))
    dat.list <- dat.list[ind]
    q.list <- q.list[ind]
    if(!is.null(u.list)) {
      u.list <- u.list[ind]
    }
  }
  
  data.df <- H5ECtoDF(dat.list)
  qfqm.df <- H5ECtoDF(q.list)
  if(length(u.list)==0 | is.null(u.list)) {
    ucrt.df <- data.frame(timeBgn=character(), timeEnd=character())
  } else {
    ucrt.df <- H5ECtoDF(u.list)
  }
  
  all.df <- plyr::join_all(list(data.df, qfqm.df, ucrt.df), by=c("timeBgn","timeEnd"))
  
}
