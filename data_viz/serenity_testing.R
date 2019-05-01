library(neonUtilities)
library(serenity.viz)

options(stringsAsFactors=F)

# get canopy chemistry data
cfc <- loadByProduct(dpID="DP1.10026.001", check.size=F)

# join tables
leafchem <- merge(cfc$cfc_fieldData, cfc$cfc_carbonNitrogen, 
                  by=c("namedLocation","domainID","siteID","plotID",
                       "plotType","collectDate","sampleID","sampleCode"), 
                  all=T)
leafchem <- merge(leafchem, cfc$cfc_elements,
                  by=c("namedLocation","domainID","siteID","plotID",
                       "plotType","collectDate","sampleID","sampleCode"),
                  all=T)

# subset to reasonable variables and send to serenity
leafsub <- leafchem[,c("siteID","plotType","nlcdClass","taxonID",
                       "nitrogenPercent","carbonPercent","CNratio",
                       "dryMass","foliarPhosphorusConc","foliarPotassiumConc",
                       "foliarCalciumConc","foliarMagnesiumConc","foliarSulfurConc",
                       "foliarManganeseConc","foliarIronConc","foliarCopperConc",
                       "foliarBoronConc","foliarZincConc")]
serenity.viz(dataset=leafsub)

