library(devtools)
library(neonUtilities)
library(neonOS)
library(neonPlants)
setwd("/Users/clunch/GitHub/neonPlants")
install('.')
check()
test()
load_all()

div <- loadByProduct('DP1.10058.001', site=c('GRSM','CPER'), 
                     package='basic', check.size=F,
                     token=Sys.getenv('NEON_TOKEN'))
pppc <- stackPlantPresence(div)
plottot <- aggregate(pppc$taxonID, by=list(pppc$plotID, pppc$subplotID), FUN=length)
plottot <- plottot[order(plottot$Group.1),]
# test number of taxa
rawtot <- unique(c(unique(div$div_1m2Data$taxonID), unique(div$div_10m2Data100m2Data$taxonID)))
ppptot <- unique(pppc$taxonID)
setdiff(rawtot, ppptot)
setdiff(ppptot, rawtot)

phe <- loadByProduct('DP1.10055.001', site=c('WREF','HARV'),
                     package='basic', check.size=F,
                     token=Sys.getenv('NEON_TOKEN'))
#pheind <- removeDups(phe$phe_perindividual, phe$variables_10055, 'phe_perindividual')
#pheind <- pheind[-c(451,452,454,455,460),]
phetran <- estimatePheTransByTag(phe)

phedur <- estimatePheDurationByTag(inputStatus = phe$phe_statusintensity, inputTags = phe$phe_perindividual)
any(phedur$duration<0)
negdur <- phedur[which(phedur$duration<0),]

negtran <- phetran[which(phetran$individualID %in% negdur$individualID),]
negraw <- phe$phe_statusintensity[which(phe$phe_statusintensity$individualID %in% negdur$individualID &
                                          phe$phe_statusintensity$phenophaseName %in% negdur$phenophaseName),]

phe <- loadByProduct('DP1.10055.001', site=c('GUAN','SRER'),
                     package='basic', check.size=F,
                     token=Sys.getenv('NEON_TOKEN'))
phedur <- estimatePheDurationByTag(inputStatus = phe$phe_statusintensity, inputTags = phe$phe_perindividual)
any(phedur$duration<0)
any(lubridate::year(phedur$dateTransitionStart) != lubridate::year(phedur$dateTransitionEnd))
phedx <- phedur[which(lubridate::year(phedur$dateTransitionStart) != lubridate::year(phedur$dateTransitionEnd)),]

phetran <- estimatePheTransByTag(phe)
phecx <- phetran[which(lubridate::year(phetran$dateIntervalStart) != lubridate::year(phetran$dateIntervalEnd)),]
View(phetran[which(phetran$individualID=='NEON.PLA.D04.GUAN.06002' & phetran$phenophaseName=='Young leaves'),])
View(phedur[which(phedur$individualID=='NEON.PLA.D04.GUAN.06002' & phedur$phenophaseName=='Young leaves'),])

testsi <- phe$phe_statusintensity[which(phe$phe_statusintensity$individualID %in% c('NEON.PLA.D04.GUAN.06494',
                                                                                    'NEON.PLA.D14.SRER.06243',
                                                                                    'NEON.PLA.D14.SRER.06621')),]
testind <- phe$phe_perindividual[which(phe$phe_perindividual$individualID %in% c('NEON.PLA.D04.GUAN.06494',
                                                                                     'NEON.PLA.D14.SRER.06243',
                                                                                     'NEON.PLA.D14.SRER.06621')),]
testy <- list(phe_statusintensity = testsi, phe_perindividual = testind)
saveRDS(testy, '/Users/clunch/Desktop/phe_test_GUAN_SRER.rds')

bbc <- loadByProduct(dpID = "DP1.10067.001", site = c("DEJU", 'LAJA'),
  package="basic", check.size = FALSE, token=Sys.getenv('NEON_TOKEN'))
rootmass <- scaleRootMass(bbc)
rootchem <- joinRootChem(bbc)

apc <- loadByProduct(dpID = "DP1.20072.001",
  site = c("SUGG",'ARIK','BLUE'),
  package = 'expanded',
  check.size = FALSE,
  token=Sys.getenv('NEON_TOKEN'))
apTax <- joinAquPointCount(apc)

apl <- loadByProduct(dpID = "DP1.20066.001", site = c('PRLA','OKSR','MCDI'),
  package='expanded',
  check.size = FALSE,
  token=Sys.getenv('NEON_TOKEN'))
aplTax <- joinAquClipHarvest(apl)
View(aplTax$joinedBiomass)
View(aplTax$fieldTaxonomy)

apppc <- estimateAquPercentCover(apc)
View(apppc$percentCover)
View(apppc$transectMetrics)

apppc <- estimateAquPercentCover(apc, barPlots = T)
ab <- apppc$plot_list


veg <- loadByProduct(dpID = "DP1.10098.001", site = 'BLAN',
                     startdate='2022-01', enddate='2023-12',
                     check.size = FALSE,
                     token=Sys.getenv('NEON_TOKEN'))
vprod <- estimateWoodProd(veg, siteID='BLAN')
vmass <- estimateWoodMass(veg)

veg <- loadByProduct(dpID = "DP1.10098.001", site = c('ABBY','YELL'),
                     startdate='2021-01', enddate='2024-12',
                     check.size = FALSE,
                     token=Sys.getenv('NEON_TOKEN'))
vmass <- estimateWoodMass(veg)
# 3700 missing trees from this set??
# vs 5570 trees with mass estimates
# in some cases source=missingAllometry, but most are Chojnacky_etal_2014
# more dead mass than live most years at ABBY?
vprod <- estimateWoodProd(veg, siteID='ABBY')



