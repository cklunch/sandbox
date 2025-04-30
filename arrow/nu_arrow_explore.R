# get a list of available files with historical data
urllst <- neonUtilities::queryFiles(
  dpID = "DP1.20120.001",
  site = "all",
  tabl = "inv_taxonomyProcessed",
  package = "basic",
  include.provisional = FALSE,
  metadata = FALSE,
  token = Sys.getenv("NEON_TOKEN"))

# bind dataset
ds_inv <- arrow::open_csv_dataset(
  sources = urllst[[1]], 
  schema = neonUtilities::schemaFromVar(
    variables = urllst[[2]], 
    tab = 'inv_taxonomyProcessed',
    package = 'basic'), 
  skip = 1)

ds_inv %>% nrow()

