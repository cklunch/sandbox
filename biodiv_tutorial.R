library(vegetarian)
library(vegan)
library(lubridate)
library(dplyr)
library(ggplot2)
library(tidyr)

inv <- loadByProduct('DP1.20120.001', site=c('ARIK','POSE','MAYF'),
                     check.size=F)
list2env(inv, .GlobalEnv)

View(inv_fieldData)
View(inv_persample)
View(inv_taxonomyProcessed) # note long format

# what we want is to get from these tables to various metrics and
# indices: which taxa are found at which sites, taxonomic diversity 
# at each site, changes in diversity over time, etc.

# first thing we're working toward is a table of collection events 
# with the taxa that were found in each collection event.
# to do that, we need to join field data and taxonomy

## ****** ##
# add a column called 'year' to facilitate summarizing data by collection year
# (this will not reappear until the very end of the tutorial)
inv_fieldData <- inv_fieldData %>%
  mutate(year = collectDate %>% year())

## ----- ##
# put spatial data in a separate table (pretty sure this never reappears)
table_location <- inv_fieldData %>%
  select(siteID,
         domainID,
         namedLocation,
         decimalLatitude,
         decimalLongitude,
         elevation)

# drop exact duplicates from spatial data table
table_location <- distinct(table_location)

# create a table of each taxon that appears in the data set (pretty sure this never reappears)
table_taxon <- inv_taxonomyProcessed %>%
  select(acceptedTaxonID, taxonRank, scientificName,
         genus, family, order,
         identificationQualifier,
         identificationReferences)

# drop exact duplicates
table_taxon <- distinct(table_taxon)



## ****** ##
# subset several columns from taxonomyProcessed and fieldData, and 
# join, to get a data table of collection events for each taxon
table_observation <- inv_taxonomyProcessed %>%
  select(uid,
         sampleID,
         domainID,
         siteID,
         namedLocation,
         collectDate,
         subsamplePercent,
         individualCount,
         estimatedTotalCount,
         acceptedTaxonID,
         scientificName,
         genus, family, order,
         taxonRank) %>%
  left_join(inv_fieldData %>%
              select(sampleID, eventID, year,
                     habitatType, samplerType,
                     benthicArea)) %>%
  mutate(inv_dens = estimatedTotalCount/benthicArea,
         inv_dens_unit = 'count per square meter')

# extract sample info for each observation (this will be used many
# steps later to re-join site info to sampleIDs; also used in 
# sampling effort summary)
table_sample_info <- table_observation %>%
  select(sampleID, domainID, siteID, namedLocation, 
         collectDate, eventID, year, 
         habitatType, samplerType, benthicArea, 
         inv_dens_unit) %>%
  distinct()

# make a table of # observations for each taxon
taxa_occurrence_summary <- table_observation %>%
  select(sampleID, acceptedTaxonID) %>%
  distinct() %>%
  group_by(acceptedTaxonID) %>%
  summarize(occurrences = n())

# remove taxa that are only observed once or twice, 
# then use the subsetted data to subset the observation table
# and apparently also remove two specific samples
taxa_list_cleaned <- taxa_occurrence_summary %>%
  filter(occurrences > 2)

table_observation_cleaned <- table_observation %>%
  filter(acceptedTaxonID %in%
           taxa_list_cleaned$acceptedTaxonID,
         !sampleID %in% c("MAYF.20190729.CORE.1",
                          "POSE.20160718.HESS.1"))
View(table_observation_cleaned)


## ------- ##

# summarize sampling effort (why?)
sampling_effort_summary <- table_sample_info %>%
  group_by(siteID, year, samplerType) %>%
  summarise(
    event_count = eventID %>% unique() %>% length(),
    sample_count = sampleID %>% unique() %>% length(),
    habitat_count = habitatType %>% 
      unique() %>% length())
View(sampling_effort_summary)

# create taxonRank summary by site (why?)
taxon_rank_summary <- table_observation_cleaned %>% 
  group_by(domainID, siteID, taxonRank) %>%
  summarize(
    n_taxa = acceptedTaxonID %>% 
      unique() %>% length())

# plot taxon ranks by site (why?)
ggplot(data=taxon_rank_summary,
       aes(n_taxa, taxonRank)) +
  facet_wrap(~ domainID + siteID) +
  geom_col()


## ******* ##

# as a first cut, we're going to look just at the level of 
# the taxonomic order, so a relatively coarse taxonomic scale.
# we'll aggregate the data into observations at the order level, 
# and take a look at the orders present and their distribution across sites

# get sum of density by order for each sampleID (why?)
table_observation_by_order <- 
  table_observation_cleaned %>% 
  filter(!is.na(order)) %>%
  group_by(domainID, siteID, year, 
           eventID, sampleID, habitatType, order) %>%
  summarize(order_dens = sum(inv_dens, na.rm = TRUE))

head(table_observation_by_order)

# create summary of occurrence of each order by site
order_by_site <- table_observation_by_order %>%
  group_by(order, siteID) %>%
  summarize(
    occurrence = (order_dens > 0) %>% sum())

# plot order occurrence by site
ggplot(data=order_by_site,
         aes(x = reorder(order, -occurrence), 
  y = occurrence,
  color = siteID,
  fill = siteID)) +
  geom_col() +
  theme(axis.text.x = 
          element_text(angle = 45, hjust = 1))

# plot density of each order by site
ggplot(data=table_observation_by_order,
         aes(x = reorder(order, -order_dens), 
    y = log10(order_dens),
    color = siteID,
    fill = siteID)) +
  geom_boxplot(alpha = .5) +
  facet_grid(siteID ~ .) +
  theme(axis.text.x = 
          element_text(angle = 45, hjust = 1))

# covert to wide format
# this is necessary to work with some of the community ecology
# R packages

# strip the long table down to a small subset of variables
table_sample_by_taxon_density_long <- table_observation_cleaned %>%
  select(sampleID, acceptedTaxonID, inv_dens) %>%
  distinct() %>%
  filter(!is.na(inv_dens))

# convert stripped-down table to wide format
table_sample_by_taxon_density_wide <- table_sample_by_taxon_density_long %>%
  pivot_wider(id_cols = sampleID, 
                     names_from = acceptedTaxonID,
                     values_from = inv_dens,
                     values_fill = list(inv_dens = 0),
                     values_fn = list(inv_dens = sum)) %>%
  tibble::column_to_rownames(var = "sampleID")

View(table_sample_by_taxon_density_wide)

# get mean species richness across the 3 sites
table_sample_by_taxon_density_wide %>%
  vegetarian::d(lev = 'alpha', q = 0)

# interlude using fake data to demonstrate different values of q,
# giving varying weight to evenness

# followed by insane use of tibbles to calculate diversity 
# indices for differing q at different sites

# alternative to tibbles:
vegetarian::d(table_sample_by_taxon_density_wide
              [grep('POSE', rownames(table_sample_by_taxon_density_wide))],
              lev = 'alpha', q = 0)

vegetarian::d(table_sample_by_taxon_density_wide
              [grep('MAYF', rownames(table_sample_by_taxon_density_wide))],
              lev = 'alpha', q = 0)

vegetarian::d(table_sample_by_taxon_density_wide
              [grep('ARIK', rownames(table_sample_by_taxon_density_wide))],
              lev = 'alpha', q = 0)



# NMDS to group communities

my_nmds_result <- table_sample_by_taxon_density_wide %>% vegan::metaMDS()
