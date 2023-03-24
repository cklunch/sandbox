library(neonUtilities)
library(ggplot2)
fsp <- loadByProduct(dpID='DP1.30012.001', site='WREF', package='expanded')
sp1 <- fsp$per_sample[which(fsp$per_sample$spectralSampleID=='FSP_WREF_20190716_1104'),]
sp1$wavelength <- as.numeric(sp1$wavelength)
sp1$reflectance <- as.numeric(sp1$reflectance)

gg <- ggplot(sp1, aes(wavelength, reflectance, 
                      group=reflectanceCondition, color=reflectanceCondition)) +
  geom_line() +
  theme_linedraw()
gg
