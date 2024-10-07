## packages
# generic
library(data.table)
library(plyr)
library(dplyr)
library(lubridate)

# plotting
library(ggplot2)
library(ggpubr)

# geospatial
library(raster)
library(ncdf4)
library(sp)
library(sf)
library(stars)

# parallel
library(doParallel)

## Paths
PATH_DATA <- 'data/raw/'
PATH_SAVE <- 'data/processed/'

## Datasets
PREC_GLOBAL_DATASETS <- c("e-obs", "em-earth", "gpcc","era5-land", "merra2-land", 
                          "gpcp", "gpm-imerg", "mswep",  
                          "mswx", "gsmap")

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
