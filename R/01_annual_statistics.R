###
# Step 2: Calculating annual statistics such as annual total precipitation, 
#Number of wet days, and Intensity
###

# Source the required libraries and functions
source("./source/lib.R")
source("./source/functions.R")
source("./source/global_variables.R")

# Initialize a parallel backend using all available cores but one
cl <- makeCluster(detectCores() - 33) 
registerDoParallel(cl)

# Process precipitation data for multiple global datasets in parallel
prec_data_2001_2019 <- foreach(
  dataset = PREC_GLOBAL_DATASETS,  # List of datasets to process
  .combine = rbind,                # Combine results by row
  .packages = 'data.table'         # Load the 'data.table' package for each task
) %dopar% {
  # Load raw data for the current dataset
  prec_data <- readRDS(paste0(PATH_TIDY_DATA, dataset, "_raw.rds"))
  
  # Calculate wet days, annual precipitation, and intensity by location and year
  prec_data[, wet_days := .N, by = .(lon, lat, year)]
  prec_data[, pr_year := sum(precip, na.rm = TRUE), by = .(lon, lat, year)]
  prec_data[, intensity := pr_year / wet_days, by = .(lon, lat, year)]
  
  # Aggregate results by year: average wet days, intensity, and annual precipitation
  agg_data <- prec_data[, .(
    avg_wet_days = mean(wet_days, na.rm = TRUE),
    avg_intensity = mean(intensity, na.rm = TRUE),
    avg_pr_year = mean(pr_year, na.rm = TRUE)
  ), by = year]
  
  # Add the dataset name for identification
  agg_data[, dataset := dataset]
  
  agg_data
}

stopCluster(cl)


# Map each dataset to its data source category
prec_data_2001_2019[, source := PREC_SOURCE[dataset]]

# Add new columns 'Min', 'Max', and 'Mean' for each dataset
prec_data_2001_2019[, dataset := PREC_UPDATED_NAMES[dataset]]
prec_data_2001_2019[, `:=`(
  min_intensity = min(avg_intensity),
  max_intensity = max(avg_intensity),
  avg_intensity = mean(avg_intensity),
  min_wet_days = min(avg_wet_days),
  max_wet_days = max(avg_wet_days),
  avg_wet_days = mean(avg_wet_days),
  min_pr = min(avg_pr_year),
  max_pr = max(avg_pr_year),
  avg_pr = mean(avg_pr_year)
), by = dataset]

# Save data 
saveRDS(prec_data_2001_2019, paste0(PATH_PROCESSED_DATA, "annual_stats.rds"))
