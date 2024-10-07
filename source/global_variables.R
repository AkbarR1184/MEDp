#Variables

## Paths
PATH_DATA <- 'data/raw/'
PATH_SAVE <- 'data/processed/'
PATH_GEO <- 'data/geo_data/'

## Datasets
PREC_GLOBAL_DATASETS <- c("e-obs", "em-earth","era5-land", "gpcc",  
                          "gpcp", "gpm-imerg", "gsmap","merra2-land","mswep",  
                          "mswx")

# Types
PREC_DATASETS_OBS <- c("e-obs", "em-earth", "gpcc")
PREC_DATASETS_REANAL <- c("era5-land", "merra2-land", "mswep", "mswx")
PREC_DATASETS_REMOTE <- c("gpcp", "gpm-imerg", "gsmap")

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
