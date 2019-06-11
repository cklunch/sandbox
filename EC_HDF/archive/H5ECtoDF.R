##############################################################################################
#' @title Convert lists of data frames to a single data frame, for HDF5 EC data

#' @author
#' Claire Lunch \email{clunch@battelleecology.org}

#' @description
#' Given a list of NEON eddy covariance HDF5 data, convert to tabular format.

#' @param dat.list The list of data frames

#' @return A single data frame of the available data.

#' @references
#' License: GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007

# Changelog and author contributions / copyrights
#   2018-05-25 (Claire Lunch): Original creation
##############################################################################################

H5ECtoDF <- function(dat.list) {

  # figure out how deeply nested the lists are, then unlist
  if(class(dat.list[[1]])=="NULL") {
    stop("No data found.")
  }
  if(class(dat.list)=="data.frame") {
    dat.df <- dat.list
  }
  if(class(dat.list)!="data.frame") {
    if(class(dat.list[[1]])=="data.frame") {
      dat.df.list <- dat.list
    }
    if(class(dat.list[[1]][[1]])=="data.frame") {
      dat.df.list <- unlist(dat.list, recursive=F)
    }
    
    # append variable names to column names
    for(i in 1:length(dat.df.list)) {
      colnames(dat.df.list[[i]]) <- paste(names(dat.df.list)[i], colnames(dat.df.list[[i]]), sep=".")
      colnames(dat.df.list[[i]])[grep("timeBgn", colnames(dat.df.list[[i]]))] <- "timeBgn"
      colnames(dat.df.list[[i]])[grep("timeEnd", colnames(dat.df.list[[i]]))] <- "timeEnd"
    }
    
    # join into one data frame
    dat.df <- plyr::join_all(dat.df.list, by=c("timeBgn","timeEnd"))
  }
  
  return(dat.df)
  
}
