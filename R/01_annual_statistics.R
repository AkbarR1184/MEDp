###
# Step 2: Calculating annual statistics such as annual total precipitation, 
#Number of wet days, and Intensity
###

# Source the required libraries and functions
source("./source/lib.R")
source("./source/functions.R")
source("./source/global_variables.R")
# Create and register the parallel backend
cl <- makeCluster(detectCores() -1) # Use all cores but one
registerDoParallel(cl)

# Use foreach for parallel processing
prec_data_2001_2019 <- foreach(dataset = PREC_GLOBAL_DATASETS, .combine = rbind, .packages = 'data.table') %dopar% {
  
  # Load dataset
  prec_data <- readRDS(paste0(PATH_TIDY_DATA, dataset, "_raw.rds"))
  
  # Calculate wet days, total yearly precipitation, and intensity
  prec_data[, wet_days := .N, by = .(lon, lat, year)] 
  prec_data[, pr_year := sum(precip, na.rm = TRUE), by = .(lon, lat, year)]
  prec_data[, intensity := pr_year / wet_days, by = .(lon, lat, year)]
  
  # Aggregate over the whole region (average per year)
  agg_data <- prec_data[, .(
    avg_wet_days = mean(wet_days, na.rm = TRUE),
    avg_intensity = mean(intensity, na.rm = TRUE),
    avg_pr_year = mean(pr_year, na.rm = TRUE)
  ), by = year]
  
  # Add the dataset identifier
  agg_data[, dataset := dataset]
  
  # Return the aggregated data for this dataset
  agg_data
}

# Stop the cluster
stopCluster(cl)

# Save data 
saveRDS(prec_data_2001_2019, paste0(PATH_SAVE, "annual_stats.rds"))
