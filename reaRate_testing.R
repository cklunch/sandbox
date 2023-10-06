library(devtools)
install_github('NEONScience/NEON-utilities/neonUtilities')
install_github('NEONScience/NEON-reaeration/reaRate')
library(neonUtilities)
library(reaRate)

# following exampleScript.R from NEON-reaeration repo
siteID <- "GUIL"
plotPath <- paste0("~/reaOutputs/",siteID,"/QAQC_plots")

reaDPID <- "DP1.20190.001"
dscDPID <- "DP1.20048.001"
wqDPID <- "DP1.20288.001"

# modified from script - use file downloaded from INT portal
reaInputList <- stackByTable('/Users/clunch/Desktop/NEON_reaeration.zip', savepath='envt')

rea_backgroundFieldCondDataIn <- reaInputList$rea_backgroundFieldCondData
rea_backgroundFieldSaltDataIn <- reaInputList$rea_backgroundFieldSaltData
rea_fieldDataIn <- reaInputList$rea_fieldData
rea_plateauMeasurementFieldDataIn <- reaInputList$rea_plateauMeasurementFieldData
rea_plateauSampleFieldDataIn <- reaInputList$rea_plateauSampleFieldData
rea_externalLabDataSaltIn <- reaInputList$rea_externalLabDataSalt
rea_externalLabDataGasIn <- reaInputList$rea_externalLabDataGas
rea_widthFieldDataIn <- reaInputList$rea_widthFieldData

qInputList <- neonUtilities::loadByProduct(dpID = dscDPID, site = siteID, check.size = FALSE)

dsc_fieldDataIn <- qInputList$dsc_fieldData
dsc_individualFieldDataIn <- qInputList$dsc_individualFieldData
dsc_fieldDataADCPIn <- qInputList$dsc_fieldDataADCP

sensorData <- neonUtilities::loadByProduct(dpID = wqDPID, 
                                           site = siteID,
                                           check.size = FALSE)
waq_instantaneousIn <- sensorData$waq_instantaneous

reaFormatted <- reaRate::def.format.reaeration(rea_backgroundFieldCondData = rea_backgroundFieldCondDataIn,
                                               rea_backgroundFieldSaltData = rea_backgroundFieldSaltDataIn,
                                               rea_fieldData = rea_fieldDataIn,
                                               rea_plateauMeasurementFieldData = rea_plateauMeasurementFieldDataIn,
                                               rea_plateauSampleFieldData = rea_plateauSampleFieldDataIn,
                                               rea_externalLabDataSalt = rea_externalLabDataSaltIn,
                                               rea_externalLabDataGas = rea_externalLabDataGasIn,
                                               rea_widthFieldData = rea_widthFieldDataIn,
                                               dsc_fieldData = dsc_fieldDataIn,
                                               dsc_individualFieldData = dsc_individualFieldDataIn,
                                               dsc_fieldDataADCP = dsc_fieldDataADCPIn,
                                               waq_instantaneous = waq_instantaneousIn)

reaFormatted$backgroundSensorCond[reaFormatted$backgroundSensorCond < 105] <- NA
reaFormatted$platSensorCond[reaFormatted$platSensorCond < 105] <- NA

plotsOut <- reaRate::gas.loss.rate.plot(inputFile = reaFormatted,
                                        savePlotPath = plotPath)
reaRate::bkgd.salt.conc.plot(inputFile = plotsOut,
                             savePlotPath = plotPath)

# modification to get back to correct format
hobo <- merge(reaInputList$rea_conductivityFieldData, reaInputList$rea_conductivityRawData, 
              by.x="hoboSampleID", by.y="hoboSampleId")

reaRatesTrvlTime <- reaRate::def.calc.trvl.time(inputFile = plotsOut,
                                                loggerData = hobo,
                                                plot = TRUE,
                                                savePlotPath = plotPath)

reaRatesCalc <- reaRate::def.calc.reaeration(inputFile = reaRatesTrvlTime,
                                             lossRateSF6 = "slopeClean",
                                             outputSuffix = "clean")
