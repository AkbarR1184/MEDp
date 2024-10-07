#Variables

## Paths
PATH_NC_DATA <- 'data/nc/'
PATH_PROCESSED_DATA <- 'data/processed/'
PATH_GEO_DATA <- 'data/geo_data/'
PATH_TIDY_DATA <- 'data/tidy/'

## Datasets
PREC_GLOBAL_DATASETS <- c(
  "e-obs",
  "em-earth",
  "era5-land",
  "gpcc",
  "gpcp",
  "gpm-imerg",
  "gsmap",
  "merra2-land",
  "mswep",
  "mswx"
)
PREC_UPDATED_NAMES <- c(
  "e-obs" = "E-OBS v29e",
  "em-earth" = "EM-EARTH",
  "era5-land" = "ERA5-Land",
  "gpcc" = "GPCC v2020",
  "gpcp" = "GPCP v3.2",
  "gpm-imerg" = "GPM-IMERG v6",
  "gsmap" = "GSMaP v8",
  "merra2-land" = "MERRA2-Land",
  "mswep" = "MSWEP v2.8",
  "mswx" = "MSWX-Past"
)
# Types
PREC_SOURCE <- list(
  "e-obs" = "gauge-based",
  "em-earth" = "gauge-based",
  "era5-land" = "reanalysis-based",
  "gpcc" = "gauge-based",
  "gpcp" = "satellite-based",
  "gpm-imerg" = "satellite-based",
  "gsmap" = "satellite-based",
  "merra2-land" = "reanalysis-based",
  "mswep" = "reanalysis-based",
  "mswx" = "reanalysis-based"
)
## Constants
# Time
PERIOD_START <- as.Date("2001-01-01")
PERIOD_END <- as.Date("2019-12-31")

# Space
PILOT_LAT_MAX <- 40
PILOT_LAT_MIN <- -10
PILOT_LON_MIN  <- 35
PILOT_LON_MAX <- 45

## Variable names
PREC_NAME <- "prec"
PREC_NAME_SHORT <- "tp"
## Parallelization
N_CORES <- detectCores()

# color palettes for each source
gauge_based_palette <- c(
  "e_obs_v29e" = "#88CCEE",
  "em_earth" = "#CC6677",
  "gpcc_v2020" = "#117733"
)

reanalysis_based_palette <- c(
  "era5_land" = "#DDCC77",
  "merra2_land" = "#999933",
  "mswep_v2_8" = "#882255",
  "mswx_past" = "#888888"
)

satellite_based_palette <- c(
  "gpcp_v3_2" = "#332288",
  "gpm_imerg_v6" = "#AA4499",
  "gsmap_v8" = "#44AA99"
)


