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
  min_intensity = round(min(avg_intensity), 2),
  max_intensity = round(max(avg_intensity), 2),
  avg_intensity = round(mean(avg_intensity), 2),
  min_wet_days = round(min(avg_wet_days), 2),
  max_wet_days = round(max(avg_wet_days), 2),
  avg_wet_days = round(mean(avg_wet_days), 2),
  min_pr = round(min(avg_pr_year), 0),
  max_pr = round(max(avg_pr_year), 0),
  avg_pr = round(mean(avg_pr_year), 0)
), by = dataset]


# Save data 
saveRDS(prec_data_2001_2019, paste0(PATH_PROCESSED_DATA, "annual_stats.rds"))
