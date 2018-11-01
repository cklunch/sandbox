prin <- read.delim("/Users/clunch/Desktop/Plant_and_algae_external_lab_taxonomy_ptx_taxonomy_in_PRIN_FAIL.txt", sep="\t")
prin_fail <- unique(prin$scientificName)

prin16 <- read.delim("/Users/clunch/Desktop/Plant_and_algae_external_lab_taxonomy_ptx_taxonomy_in_PRIN_FAIL2016.txt", sep="\t")
prin_fail16 <- unique(prin16$scientificName)

prin2 <- read.delim("/Users/clunch/Desktop/Plant_and_algae_external_lab_taxonomy_ptx_taxonomy_in_PRIN_SUC.txt", sep="\t")
prin_success <- unique(prin2$scientificName)

fail1 <- prin_fail[which(!(prin_fail %in% prin_success))]
fail2 <- prin_fail16[which(!(prin_fail16 %in% prin_success))]
intersect(fail1,fail2)

king1 <- read.delim("/Users/clunch/Desktop/Plant_and_algae_external_lab_taxonomy_ptx_taxonomy_in_KING_FAIL.txt", sep="\t")
king2 <- read.delim("/Users/clunch/Desktop/Plant_and_algae_external_lab_taxonomy_ptx_taxonomy_in_KING_SUC.txt", sep="\t")
king_fail <- unique(king1$scientificName)
king_success <- unique(king2$scientificName)
failK <- king_fail[which(!(king_fail %in% king_success))]
  
  
  