# trying out bird occupancy tutorial code

library(neonUtilities)
library(RPresence)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(neonOS)

bird.counts <- loadByProduct(dpID="DP1.10003.001",
                             site=c('HARV','JERC'),
                             startdate="2019-01",
                             enddate="2019-12",
                             check.size = F)

bird.counts <- loadByProduct(dpID="DP1.10003.001",
                             site=c('HARV','JERC'),
                             startdate="2019-01",
                             enddate="2019-12",
                             release='LATEST',
                             check.size = F,
                             token=Sys.getenv('LATEST_TOKEN'))



brd_perpoint_clean <- bird.counts$brd_perpoint %>%
  mutate(year = str_extract(eventID, "\\d{4}"))%>%
  mutate(pointSurveyID = paste(plotID, "point", pointID, year, "bout", boutNumber, sep = "_")) %>%
  mutate(locationID = paste(plotID, "point", pointID, sep = "_")) %>%
  mutate(timeID = paste(year, "bout", boutNumber, sep = "_"))

brd_countdata_clean <- bird.counts$brd_countdata %>%
  mutate(year = str_extract(eventID, "\\d{4}"))%>%
  mutate(pointSurveyID = paste(plotID, "point", pointID, year, "bout", boutNumber, sep = "_")) %>%
  mutate(locationID = paste(plotID, "point", pointID, sep = "_")) %>%
  mutate(timeID = paste(year, "bout", boutNumber, sep = "_"))

brdpp_dup <- removeDups(bird.counts$brd_perpoint, bird.counts$variables_10003, 'brd_perpoint')

brd_joineddata_clean <- inner_join(
  brd_countdata_clean,
  brd_perpoint_clean,
  by = "pointSurveyID",
  suffix = c(".count", ".perpoint")
)

brd_joineddata_clean <- brd_joineddata_clean %>%
  select(-matches("\\.perpoint$"))
names(brd_joineddata_clean) <- gsub("\\.count$", "", names(brd_joineddata_clean))


# Filter table by species
bird_species <- "Melanerpes carolinus"
brd_joineddata_model1 <- brd_joineddata_clean %>%
  filter(scientificName == bird_species)

# Get all valid surveys years across sites (so we can fill in NAs)
valid_site_years <- brd_perpoint_clean %>%
  distinct(siteID, year)

# Get detections — only species *actually observed at a site* (so we can fill in 0s)
detections <- brd_joineddata_model1 %>%
  group_by(siteID, year) %>%
  summarize(present = 1, .groups = "drop")

# Join and fill
site_by_year <- valid_site_years %>%
  left_join(detections, by = c("siteID", "year")) %>%
  mutate(present = replace_na(present, 0)) %>%
  pivot_wider(
    names_from = year,
    values_from = present
  )

head(site_by_year, n=10)

run_occ_for_species_list <- function(species_df, brd_joineddata_clean, brd_perpoint_clean, years = c("2018", "2019", "2020", "2021", "2022", "2023")) {
  
  results <- list()
  detection_histories <- list()
  
  for (i in seq_len(nrow(species_df))) {
    
    sci_name <- species_df$scientificName[i]
    common_name <- species_df$vernacularName[i]
    
    # Filter detection data to this species and the sites
    brd_species <- brd_joineddata_clean %>%
      filter(scientificName == sci_name)
    
    # Get valid surveys (site-year combos with effort)
    valid_site_years <- brd_perpoint_clean %>%
      distinct(siteID, year)
    
    # Get detections for this species
    detections <- brd_species %>%
      group_by(siteID, year) %>%
      summarize(present = 1, .groups = "drop")
    
    # Build site-year detection matrix
    site_by_year <- valid_site_years %>%
      left_join(detections, by = c("siteID", "year")) %>%
      mutate(present = replace_na(present, 0)) %>%
      pivot_wider(
        names_from = year,
        values_from = present
      )
    
    # Create Pao object
    birds_pao <- createPao(
      data = site_by_year[, years],
      unitnames = site_by_year$siteID,
      title = common_name
    )
    
    # Run occupancy model
    model <- occMod(
      data = birds_pao,
      model = list(psi ~ 1, p ~ 1),
      type = "so"
    )
    
    # Extract estimates
    ests <- print_one_site_estimates(mod = model) %>%
      as.data.frame() %>%
      slice(1:2)
    
    rownames(ests) <- NULL
    
    named_est <- list(
      vernacularName = common_name,
      psi_Estimate = ests$est[1],
      psi_SE       = ests$se[1],
      psi_L95      = ests$lower[1],
      psi_U95      = ests$upper[1],
      p_Estimate   = ests$est[2],
      p_SE         = ests$se[2],
      p_L95        = ests$lower[2],
      p_U95        = ests$upper[2]
    )
    
    detection_histories[[sci_name]] <- site_by_year
    results[[sci_name]] <- named_est
  }
  
  return(list(
    estimates = results,
    detection_histories = detection_histories
  ))
  
}

species_input <- brd_joineddata_clean %>%
  distinct(scientificName, vernacularName) %>%
  arrange(scientificName)

results_df <- run_occ_for_species_list(
  species_df = species_input,
  brd_joineddata_clean = brd_joineddata_clean,
  brd_perpoint_clean = brd_perpoint_clean
)

psi_df <- bind_rows(lapply(names(results_df$estimates), function(name) {
  row <- results_df$estimates[[name]]
  tibble(
    scientificName = name,
    vernacularName = row$vernacularName,
    psi_Estimate = row$psi_Estimate,
    psi_SE = row$psi_SE,
    psi_L95 = row$psi_L95,
    psi_U95 = row$psi_U95
  )
})) %>%
  arrange(psi_Estimate)

psi_df <- psi_df %>%
  mutate(label = paste0(scientificName))
#mutate(label = paste0(scientificName, "\n", vernacularName))

ggplot(psi_df, aes(x = reorder(label, psi_Estimate), y = psi_Estimate)) +
  geom_col(fill = "grey") +
  geom_errorbar(aes(ymin = psi_L95, ymax = psi_U95), width = 0.2) +
  labs(
    title = "Species Occupancy (ψ) Estimates",
    x = "Species",
    y = "ψ Estimate"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

p_df <- bind_rows(lapply(names(results_df$estimates), function(name) {
  row <- results_df$estimates[[name]]
  tibble(
    scientificName = name,
    vernacularName = row$vernacularName,
    p_Estimate = row$p_Estimate,
    p_SE = row$p_SE,
    p_L95 = row$p_L95,
    p_U95 = row$p_U95
  )
})) %>%
  arrange(p_Estimate)

p_df <- p_df %>%
  mutate(label = paste0(scientificName))
#mutate(label = paste0(scientificName, "\n", vernacularName))

ggplot(p_df, aes(x = reorder(label, p_Estimate), y = p_Estimate)) +
  geom_col(fill = "grey") +
  geom_errorbar(aes(ymin = p_L95, ymax = p_U95), width = 0.2) +
  labs(
    title = "Species Detection Probability (p) Estimates",
    x = "Species",
    y = "p Estimate"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

estimates_df <- bind_rows(lapply(names(results_df$estimates), function(name) {
  row <- results_df$estimates[[name]]
  tibble(
    scientificName = name,
    vernacularName = row$vernacularName,
    psi_Estimate = row$psi_Estimate,
    psi_L95 = row$psi_L95,
    psi_U95 = row$psi_U95,
    p_Estimate = row$p_Estimate,
    p_L95 = row$p_L95,
    p_U95 = row$p_U95
  )
}))

psi_range_species <- estimates_df %>%
  filter(psi_Estimate >= 0.5, psi_Estimate <= 0.6) %>%
  select(scientificName, vernacularName, psi_Estimate, p_Estimate, p_L95, p_U95) %>%
  arrange(desc(p_Estimate))

psi_range_species



bird <- loadByProduct(dpID="DP1.10003.001",
                      site=c('SJER','TEAK','HEAL'),
                      startdate="2019-01",
                      enddate="2022-12",
                      release='LATEST',
                      check.size = F,
                      token=Sys.getenv('LATEST_TOKEN'))

unique(bird$brd_perpoint$eventID)
unique(bird$brd_countdata$eventID)

pptab <- bird$brd_perpoint |>
  group_by(eventID) |>
  summarize(n = n())

cdtab <- bird$brd_countdata |>
  group_by(eventID) |>
  summarize(n = n(), plct = length(unique(plotID)))



