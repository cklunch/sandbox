library(vegan)
library(vegetarian)
library(dplyr)
library(tidyr)
library(lubridate)
library(neonUtilities)
install.packages("vegan")
install.packages("tidyverse")

inv <- loadByProduct(dpID='DP1.20120.001', site=c('ARIK','POSE','MAYF'),
                     check.size=F)
list2env(inv, .GlobalEnv)

View(inv_fieldData)
View(inv_persample)
View(inv_taxonomyProcessed)

# add year column to field data
inv_fieldData <- inv_fieldData %>%
  mutate(year = collectDate %>% year())

# join subset of field data to subset of taxonomyProcessed
table_observation <- inv_taxonomyProcessed %>%
  select(uid, sampleID, domainID, siteID, namedLocation,
         collectDate, subsamplePercent, individualCount,
         estimatedTotalCount, acceptedTaxonID, scientificName,
         genus, family, order, taxonRank) %>% 
  left_join(inv_fieldData %>% 
              select(sampleID, eventID, year,
                     habitatType, samplerType,
                     benthicArea)) %>%
  mutate(inv_dens = estimatedTotalCount/benthicArea,
         inv_dens_unit = 'count per square meter')
View(table_observation)

# extract sample info
table_sample_info <- table_observation %>% 
  select(sampleID, domainID, siteID, namedLocation,
         collectDate, eventID, year, 
         habitatType, samplerType, benthicArea,
         inv_dens_unit) %>%
  distinct()

# table of observations of each taxon
taxa_occurrence_summary <- table_observation %>%
  select(sampleID, acceptedTaxonID) %>%
  distinct() %>%
  group_by(acceptedTaxonID) %>%
  summarize(occurrences = n())
View(taxa_occurrence_summary)

# remove taxa observed once or twice
taxa_list_cleaned <- taxa_occurrence_summary %>%
  filter(occurrences > 2)

# remove taxa observed once or twice from observation table
table_observation_cleaned <- table_observation %>%
  filter(acceptedTaxonID %in% 
           taxa_list_cleaned$acceptedTaxonID,
         !sampleID %in% c('MAYF.20190729.CORE.1',
                          'POSE.20160718.HESS.1'))

table_observation_by_order <- table_observation_cleaned %>%
  filter(!is.na(order)) %>%
  group_by(domainID, siteID, year, eventID,
           sampleID, habitatType, order) %>%
  summarise(order_dens = sum(inv_dens, na.rm=T))
head(table_observation_by_order)

order_by_site <- table_observation_by_order %>%
  group_by(order, siteID) %>%
  summarise(occurrence = (order_dens > 0) %>% sum())

ggplot(data=order_by_site,
       aes(x = reorder(order, -occurrence),
           y=occurrence,
           color=siteID,
           fill=siteID)) +
  geom_col() +
  theme(axis.text.x = element_text(angle=45, hjust=1))

ggplot(data=table_observation_by_order,
       aes(x = reorder(order, -order_dens),
           y=log10(order_dens),
           color=siteID,
           fill=siteID)) +
  geom_boxplot(alpha=0.5) +
  facet_grid(siteID ~ .) +
  theme(axis.text.x=element_text(angle=45, hjust=1))

# convert data to format compatible with vegetarian package
# first strip down observation table to a few variables
table_sample_by_taxon_density_long <- table_observation_cleaned %>%
  select(sampleID, acceptedTaxonID, inv_dens) %>%
  distinct() %>%
  filter(!is.na(inv_dens))

# now convert table to wide
table_sample_by_taxon_density_wide <- table_sample_by_taxon_density_long %>%
  pivot_wider(id_cols = sampleID,
              names_from = acceptedTaxonID,
              values_from = inv_dens,
              values_fill = list(inv_dens = 0),
              values_fn = list(inv_dens = sum)) %>%
  tibble::column_to_rownames(var = 'sampleID')
View(table_sample_by_taxon_density_wide)

# calculate mean order richness across all 3 sites
table_sample_by_taxon_density_wide %>%
  vegetarian::d(lev='alpha', q=0)

table_sample_by_taxon_density_wide %>%
  vegetarian::d(lev='alpha', q=1)

# calculate diversity indices for each site
vegetarian::d(table_sample_by_taxon_density_wide
              [grep('POSE', rownames(table_sample_by_taxon_density_wide))],
              lev='alpha', q=0)
# 11.76

vegetarian::d(table_sample_by_taxon_density_wide
              [grep('MAYF', rownames(table_sample_by_taxon_density_wide))],
              lev='alpha', q=0)
# 9.4

vegetarian::d(table_sample_by_taxon_density_wide
              [grep('ARIK', rownames(table_sample_by_taxon_density_wide))],
              lev='alpha', q=0)
# 4.3

vegetarian::d(table_sample_by_taxon_density_wide
              [grep('POSE', rownames(table_sample_by_taxon_density_wide))],
              lev='alpha', q=1)




