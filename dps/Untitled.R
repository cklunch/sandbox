# code to identify veg structure & phenology individuals with the same tags

library(neonUtilities)
library(dplyr)

vegds <- datasetQuery('DP1.10098.001', site='all', tabl='vst_mappingandtagging', 
                      include.provisional = T, token=Sys.getenv('NEON_TOKEN'))
veg <- vegds |>
  collect()

pheds <- datasetQuery('DP1.10055.001', site='all', tabl='phe_perindividual',
                      include.provisional = T, token=Sys.getenv('NEON_TOKEN'))
phe <- pheds |>
  collect()
