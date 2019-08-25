library(devtools)
setwd("~/GitHub/NEON-utilities/neonUtilities")
install('.')
library(neonUtilities)
source('~/GitHub/NEON-utilities/neonUtilities/R/footRaster.R')

ft <- footRaster('/Users/clunch/Desktop/expandedWREF/filesToStack00200/NEON.D16.WREF.DP4.00200.001.2018-08.expanded.20190718T193727Z/NEON.D16.WREF.DP4.00200.001.nsae.2018-08-03.expanded.h5')
raster::plot(ft[[1]], xlim=c(0.4,0.6), ylim=c(0.4,0.6), col=topo.colors(24))
raster::filledContour(ft[[1]], col=topo.colors(24), 
                      xlim=c(0.4,0.6), ylim=c(0.4,0.6),
                      levels=0.001*0:24)

library(raster)
library(gtools)
library(purrr)
library(magick)

setwd("~/GitHub/sandbox/animation/gif_layers/")

make.png <- function(x) {
  
  for (i in 1:nlayers(x)) {
    par(bty='n')
    png(filename=paste0('x_',i,'.png'), bg='white', height=1024, width=1224, res=200)
    #plot(x[[i]], main=substring(names(x)[i],84,103), colNA='white', col=topo.colors(24))
    raster::filledContour(x[[i]], col=topo.colors(41), 
                          xlim=c(0.42,0.58), ylim=c(0.42,0.58),
                          levels=0.001*0:40,
                          main=substring(names(x)[i],84,103))
    # need to suppress axes but not legend scale
    dev.off()
  }
}

make.png(ft[[2:48]])

gif.create <- function(names='.png', file.out='x.gif', clear=c(TRUE,FALSE)) {
  
  mixedsort(list.files(path=getwd(), pattern=names)) %>%
    map(image_read) %>% # reads each path file
    image_join() %>% # join images
    image_animate(fps=2) %>% # animate
    image_write(file.out) # write to file
  
  if (clear==TRUE) {
    unlink('*.png') # delete individual png files
  }
}

gif.create(clear=F)


