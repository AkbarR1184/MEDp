###
# step 6: Slope data preparation 


# Load required scripts
source("./source/lib.R")
source("./source/functions.R")
source("./source/global_variables.R")

# Set up parallel backend with 10 cores
cluster_cores <- 10
registerDoParallel(cluster_cores)

# Process precipitation data for global datasets
prec_data <- foreach(dataset = PREC_GLOBAL_DATASETS, .combine = rbind) %dopar% {
  library(data.table)
  dataset_path <- paste0(PATH_TIDY_DATA, dataset, "_raw.rds")
  dataset_prec_data <- readRDS(dataset_path)
  
  # Calculate wet days, yearly precipitation, and intensity
  dataset_prec_data[, wet_days := .N, .(lon, lat, year)]
  dataset_prec_data[, pr_year := sum(precip), .(lon, lat, year)]
  dataset_prec_data[, intensity := pr_year / wet_days, .(lon, lat, year)]
  dataset_prec_data[is.infinite(intensity), intensity := 0]
  
  # Add dataset information
  dataset_prec_data$dataset <- dataset
  dataset_prec_data
}

# Save the processed precipitation data
saveRDS(prec_data, paste0(PATH_PROCESSED_DATA, "prec_data_2001_2019.rds"))

# Filter relevant columns for slope calculation
prec_data <- prec_data[, .(lon, lat, year, pr_year, dataset)]
prec_data <- unique(prec_data, by = c("lon", "lat", "year", "dataset"))

# Calculate slope for total precipitation using Mann-Kendall test
prec_tot_slope <- prec_data[, as.list(
  tryCatch(
    mkttest((pr_year - mean(pr_year, na.rm = TRUE)) / sd(pr_year, na.rm = TRUE))[c(2, 5)], 
    error = function(e) NULL)
), .(lon, lat, dataset)
]

# Save the slope data
saveRDS(prec_tot_slope, paste0(PATH_PROCESSED_DATA, "prec_tot_slope.rds"))
