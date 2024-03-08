library(neonUtilities)

bet <- loadByProduct(dpID='DP1.10022.001', 
                     startdate='2021-01', enddate='2022-12',
                     check.size=F, package='expanded',
                     include.provisional=T, token=Sys.getenv('NEON_TOKEN'))

for(i in 1:nrow(bet$bet_expertTaxonomistIDProcessed)) {
  ib <- bet$bet_expertTaxonomistIDProcessed$individualID[i]
  idraw <- bet$bet_expertTaxonomistIDRaw$taxonID[which(
    bet$bet_expertTaxonomistIDRaw$individualID==ib)]
  if(idraw!=bet$bet_expertTaxonomistIDProcessed$taxonID[i]) {
    print(i)
  }
}


apl <- loadByProduct(dpID='DP1.20066.001', 
                     startdate='2021-01', enddate='2022-12',
                     check.size=F, package='expanded',
                     include.provisional=T, token=Sys.getenv('NEON_TOKEN'))

for(i in 100:nrow(apl$apl_taxonomyProcessed)) {
  ib <- apl$apl_taxonomyProcessed$sampleID[i]
  idproc <- unique(apl$apl_taxonomyRaw$taxonID[which(
    apl$apl_taxonomyRaw$sampleID==ib)])
  if(idproc!=apl$apl_taxonomyProcessed$taxonID[i]) {
    print(i)
  }
}


mos <- loadByProduct(dpID='DP1.10043.001', 
                     startdate='2021-01', enddate='2022-12',
                     check.size=F, package='expanded',
                     include.provisional=T, token=Sys.getenv('NEON_TOKEN'))

for(i in 2000:nrow(mos$mos_expertTaxonomistIDProcessed)) {
  ib <- mos$mos_expertTaxonomistIDProcessed$subsampleID[i]
  idraw <- unique(mos$mos_expertTaxonomistIDRaw$taxonID[which(
    mos$mos_expertTaxonomistIDRaw$subsampleID==ib)])
  if(idraw!=mos$mos_expertTaxonomistIDProcessed$taxonID[i]) {
    print(i)
  }
}


mam <- loadByProduct(dpID='DP1.10072.001', site='SRER', 
                     startdate='2017-01', enddate='2017-12',
                     package='expanded',
                     check.size=F, include.provisional=T,
                     token=Sys.getenv('NEON_TOKEN'))

