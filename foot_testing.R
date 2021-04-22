# wind direction
win <- loadByProduct(dpID='DP1.00001.001', site='WREF', 
                     startdate='2019-09', enddate='2019-09',
                     check.size=F, timeIndex=30)
names(win)[1] <- "wsd"
plot(win$wsd$windDirMean[which(win$wsd$verticalPosition=='070')]~win$wsd$endDateTime[which(win$wsd$verticalPosition=='070')], 
     pch=20, xlim=c(as.POSIXct('2019-09-07 00:00'), as.POSIXct('2019-09-07 23:59')))
win$wsd$windDirMean[which(win$wsd$verticalPosition=='070' &
                            win$wsd$endDateTime==as.POSIXct('2019-09-07 12:30'))]
# 172.81

# footprint data
foot <- footRaster('/Users/clunch/Desktop/filesToStack00200WREF/NEON.D16.WREF.DP4.00200.001.nsae.2019-09-07.expanded.20201011T021357Z.h5')
raster::filledContour(foot$X.Users.clunch.Desktop.filesToStack00200WREF.NEON.D16.WREF.DP4.00200.001.nsae.2019.09.07.expanded.20201011T021357Z.WREF.dp04.data.foot.grid.turb.20190907T123000Z, col=topo.colors(24), 
                      levels=0.001*0:24,
                      xlim=c(580000,583000),
                      ylim=c(5073000,5076000))
ft <- rhdf5::h5read('/Users/clunch/Desktop/filesToStack00200WREF/NEON.D16.WREF.DP4.00200.001.nsae.2019-09-07.expanded.20201011T021357Z.h5',
                    name='/WREF/dp04/data/foot/grid/turb/20190907T123000Z')
filled.contour(z=ft, xlim=c(0.4,0.6), ylim=c(0.4,0.6))
ft1230 <- raster(ft)
raster::filledContour(ft1230, xlim=c(0.4,0.6), ylim=c(0.4,0.6))


# where are the data in the original array?
zvals <- which(ft!=0, arr.ind=T)
summary(zvals)
### comment block
row             col       
Min.   :117.0   Min.   :118.0  
1st Qu.:127.0   1st Qu.:134.0  
Median :135.0   Median :145.0  
Mean   :135.2   Mean   :144.4  
3rd Qu.:143.0   3rd Qu.:154.0  
Max.   :158.0   Max.   :170.0  
### matches upper left quadrant, with longer range vertically than horizontally, as in raster images


# fake data
d <- cbind(c(1,0,0,0,0,0),c(1,0,0,0,0,0),c(0,1,0,0,0,0),
           c(0,1,0,0,0,0),c(0,0,1,0,0,0),c(0,0,1,0,0,0))
d
filled.contour(d)
dr <- raster(d)
filledContour(dr)



