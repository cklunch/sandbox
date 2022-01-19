# load required packages
library(neonUtilities)
library(ggplot2)

# download Surface water microbe group abundances data, using the neonUtilities package
sg <- loadByProduct(dpID='DP1.20278.001', site=c('OKSR', 'PRIN', 'MART', 'BLDE', 'WALK'),
                    startdate=c('2018-01'), enddate='2018-12')
# what are the names of the data and metadata tables in the download?
names(sg)
# let's look at the data table
View(sg$mga_swGroupAbundances)
# the variables file contains descriptions of the variables in the data table
View(sg$variables_20278)

# use base R function to convert the data records from long to wide
sg.wide <- reshape(sg$mga_swGroupAbundances, direction="wide",
                   timevar="targetTaxonGroup", idvar=c('siteID','geneticSampleID'))
# look at the wide version of the table - now paired fungi and bacteria from the same sample are on the same row
View(sg.wide)
# calculate fungal-to-bacterial ratio
sg.wide$fbr <- sg.wide$meanCopyNumber.fungi/sg.wide$`meanCopyNumber.bacteria and archaea`

# plot fungal-to-bacterial ratio at each of the 5 sites
g <- ggplot(data=sg.wide,
            aes(x=siteID, y=fbr)) +
  geom_violin()
g

# Download Chemical properties of surface water data
sc <- loadByProduct(dpID='DP1.20093.001', site=c('OKSR', 'PRIN', 'MART', 'BLDE', 'WALK'),
                    startdate=c('2018-01'), enddate='2018-12', check.size=F)
# check out the data and metadata tables - metadata tables have common names across data products
names(sc)
# take a look at the data table containing the chemical analytes
View(sc$swc_externalLabDataByAnalyte)

# make a subset data table containing only the total dissolved nitrogen records
scN <- sc$swc_externalLabDataByAnalyte[which(sc$swc_externalLabDataByAnalyte$analyte=='TDN'),]
# take a look at the subset table
View(scN)

# the sampleIDs in the microbe and chemistry data can be matched if we trim off the suffixes
scN$joinID <- substring(scN$sampleID, 1, 16)
sg.wide$joinID <- substring(sg.wide$geneticSampleID, 1, 16)

# use the trimmed version of the sample identifiers to join the two tables
gcN <- merge(sg.wide, scN, by=c('siteID','joinID'), all.x=T, all.y=F)
# take a look at the joined table - now we have microbe and chemical data together
View(gcN)

# plot fungal-to-bacterial ratio as a function of nitrogen concentration
g <- ggplot(data=gcN,
            aes(x=analyteConcentration, y=fbr, col=siteID)) +
  geom_point()
g
