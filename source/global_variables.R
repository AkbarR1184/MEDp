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
  "gpcc-v2020" = "GPCC v2020",
  "gpcp-v3-2" = "GPCP v3.2",
  "gpm-imerg-v6" = "GPM-IMERG v6",
  "gsmap-v8" = "GSMaP v8",
  "merra2-land" = "MERRA2-Land",
  "mswep-v2-8" = "MSWEP v2.8",
  "mswx-past" = "MSWX-Past"
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
