library(neonUtilities)  
soilData <- loadByProduct(site = c("LENO", "HARV", "WREF"), 
                          dpID = "DP1.10086.001", package = "basic", check.size = F)

devtools::install_github("NEONScience/NEON-Nitrogen-Transformations/neonNTrans", dependencies=TRUE)
library(neonNTrans)

out <- def.calc.ntrans(kclInt = soilData$ntr_internalLab, 
                       kclIntBlank = soilData$ntr_internalLabBlanks, 
                       kclExt = soilData$ntr_externalLab, 
                       soilMoist = soilData$sls_soilMoisture, 
                       dropAmmoniumFlags = "blanks exceed sample value", 
                       dropNitrateFlags = "blanks exceed sample value" )

devtools::install_github("NEONScience/NEON-Nitrogen-Transformations/neonNTrans", 
                         dependencies=TRUE, ref='NOx-contamination-correction')
library(neonNTrans)

out.corr <- def.calc.ntrans(kclInt = soilData$ntr_internalLab, 
                       kclIntBlank = soilData$ntr_internalLabBlanks, 
                       kclExt = soilData$ntr_externalLab, 
                       soilMoist = soilData$sls_soilMoisture, 
                       dropAmmoniumFlags = "blanks exceed sample value", 
                       dropNitrateFlags = "blanks exceed sample value" )

library(ggplot2)

gg <- ggplot(out$all_data, aes(x=netNitugPerGramPerDay, y=netNminugPerGramPerDay)) +
  geom_point() +
  facet_wrap(~siteID)
gg

gg <- ggplot(out.corr$all_data, aes(x=netNitugPerGramPerDay, y=netNminugPerGramPerDay, color=noxCorrection)) +
  geom_point() +
  facet_wrap(~siteID)
gg
