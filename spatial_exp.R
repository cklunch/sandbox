f <- footRaster('/Users/clunch/Desktop/expanded00200/NEON.D16.WREF.DP4.00200.001.nsae.2019-07-17.expanded.20221209T034753Z.h5')
raster::filledContour(f$WREF.summary, xlim=c(580000, 582000), ylim=c(5073000, 5075000), col=topo.colors(16))
raster::filledContour(f$WREF.summary, col=topo.colors(16))

terra::contour(f$WREF.summary, filled=T, col=topo.colors(16))
terra::contour(f$WREF.summary, filled=T, xlim=c(580000, 582000), ylim=c(5073000, 5075000), col=topo.colors(16))

chm <- terra::rast('/Users/clunch/Desktop/NEON_struct-ecosystem/NEON.D17.TEAK.DP3.30015.001.2021-07.basic.20230505T132747Z.RELEASE-2023/NEON_D17_TEAK_DP3_315000_4097000_CHM.tif')
terra::plot(chm)


a <- f$X.Users.clunch.Desktop.expanded00200.NEON.D16.WREF.DP4.00200.001.nsae.2019.07.17.expanded.20221209T034753Z.WREF.dp04.data.foot.grid.turb.20190717T000000Z
b <- f$X.Users.clunch.Desktop.expanded00200.NEON.D16.WREF.DP4.00200.001.nsae.2019.07.17.expanded.20221209T034753Z.WREF.dp04.data.foot.grid.turb.20190717T010000Z
c <- c(a,b)


epsg.z <- relevant_EPSG$code[grep(paste("+proj=utm +zone=", 
                                        "10", " ", sep=""), 
                                  relevant_EPSG$prj4, fixed=T)]
# old coordinate conversion
LatLong <- data.frame(X = -121.95191, Y = 45.82049)
sp::coordinates(LatLong) <- ~ X + Y
raster::crs(LatLong) <- sp::CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")
utmTow <- sp::spTransform(LatLong, sp::CRS(paste("+init=epsg:", epsg.z, sep='')))

# new coordinate conversion
LL <- cbind(longitude = -121.95191, latitude = 45.82049)
LL <- terra::vect(LL, crs="+proj=longlat +datum=WGS84")

U <- sf::st_transform(sf::st_as_sf(LL), crs=sf::st_crs(terra::crs(paste("EPSG:", epsg.z, sep=""))))

terra::ext(masterRaster) <- c(xmn = terra::xmin(utmTow) - 150.5*locAttr$distReso, 
                                        xmx = terra::xmax(utmTow) + 150.5*locAttr$distReso,
                                      ymn = terra::ymin(utmTow) - 150.5*locAttr$distReso, 
                                        ymx = terra::ymax(utmTow) + 150.5*locAttr$distReso)
terra::crs(masterRaster) <- paste("EPSG:", epsg.z, sep="")

