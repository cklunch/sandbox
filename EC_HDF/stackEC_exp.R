filepath <- "/Users/clunch/Desktop/filesToStack00200/"
level <- "dp01"
var <- "rtioMoleDryCo2"
avg <- 30

lst <- rhdf5::h5ls(paste(filepath, files[1], sep="/"))
lst[intersect(grep(level, lst$group), grep(var, lst$name)),]

# from def.hdf5.extr()
rpt <- list()
listObj <- rhdf5::h5ls(paste(filepath, files[1], sep="/"))
listObjName <- base::paste(listObj$group, listObj$name, sep = "/")
listDataObj <- listObj[listObj$otype == "H5I_DATASET",]
listDataName <- base::paste(listDataObj$group, listDataObj$name, sep = "/")

rpt$listData <- base::lapply(listDataName, rhdf5::h5read, file = paste(filepath, files[1], sep="/"))
base::names(rpt$listData) <- listDataName
