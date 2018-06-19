##############################################################################################
#' @title Sequentially extract elements from NEON EC HDF files and merge into one table

#' @author
#' Claire Lunch \email{clunch@battelleecology.org}

#' @description
#' Given a list of NEON EC files, pass to tabular conversion function, then merge into one table.

#' @param filepath The folder containing the H5 files [character]
#' @param site The NEON site of the data [character]
#' @param level The level of data to extract; one of dp01, dp02, dp03, dp04, dp0p [character]
#' @param var The variable set to extract, e.g. co2Turb [character]
#' @param avg The averaging interval to extract, in minutes [numeric]

#' @return A data frame of the available data for the specified variable.

#' @references
#' License: GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007

# Changelog and author contributions / copyrights
#   2018-06-15 (Claire Lunch): Original creation
##############################################################################################

stackEC <- function(filepath, site, level, var, avg) {
  
  # get list of files
  files <- list.files(filepath, recursive=T)
  files <- files[grep(".h5", files)]
  
  # pass to flattenH5EC() and merge - this section adapted from stackDataFiles()
  # would be better to allocate space up front, for now using rbind
  # set up progress bar
  writeLines(paste0("Extracting ", var, " data"))
  pb <- utils::txtProgressBar(style=3)
  utils::setTxtProgressBar(pb, 0)
  utils::setTxtProgressBar(pb, 1/length(files))
  
  # extract first file
  df <- flattenH5EC(paste(filepath, files[1], sep="/"), site=site, level=level, var=var, avg=avg)
  
  # iterate through files and extract the variable(s) requested
  for(i in 2:length(files)) {
    i.df <- flattenH5EC(paste(filepath, files[i], sep="/"), site=site, level=level, var=var, avg=avg)
    df <- rbind(df, i.df, fill=T)
    utils::setTxtProgressBar(pb, i/length(files))
  }
  
  utils::setTxtProgressBar(pb, 1)
  close(pb)
  
  return(df)
}
