
###
# Step 1: Importing data
###

# Source the required libraries and functions
source("./source/lib.R")
source("./source/functions.R")
source("./source/global_variables.R")

# Downloading data

download_data(path = PATH_DATA, datasets = "all", domain = "med", time_res = "daily")

## It is possible to download a single datasets from the list of datasets e.g., 
#download_data(path = PATH_DATA, domain = "med", time_res = "daily", datasets = "e-obs")

# List of downloaded dataset file names
PREC_FNAME<- list.files("data/raw")
n_datasets <- length(PREC_FNAME)

for (dataset_count in 1:n_datasets) {
  # Load the precipitation brick from the downloaded RDS files
  prec_brick <- brick(paste0(PATH_DATA, PREC_FNAME[[dataset_count]]))
  
  # Convert the raster brick to a tidy data frame
  prec_tidy <- raster::as.data.frame(prec_brick, xy = TRUE)
  prec_tidy <- as.data.table(prec_tidy)
  prec_tidy <- as.data.table(melt(prec_tidy, id.vars = c("x", "y")))
  setnames(prec_tidy, colnames(prec_tidy), c('lon', 'lat', 'time', 'precip'))
  prec_tidy[, time := as.Date(time, format = "X%Y.%m.%d")]
  
  # Clean up memory
  gc(); rm(prec_brick)
  
  # Load geographic data for filtering
  kg_data <- readRDS(paste0(PATH_GEO, "KG_med.rds"))
  kg_data <- data.table(kg_data)
  kg_data <- kg_data[KG != 4 & KG != 5 & KG != 0]
  
  # Filter precipitation data based on geographic and temporal constraints
  prec_tidy <- prec_tidy[kg_data, on = .(lon, lat)]
  prec_tidy <- prec_tidy[lat >= 34]
  
  # Exclude precipitation values less than or equal to 1
  prec_tidy <- prec_tidy[precip > 1]
  
  # Extract year, month, and day from the date
  prec_tidy[, year := year(time)]
  prec_tidy[, month := month(time)]
  prec_tidy[, day := day(time)]
  
  # Remove the time column as it's no longer needed
  prec_tidy[, c("time", "KG") := NULL]
  
  # Save the processed precipitation data to an RDS file
  saveRDS(prec_tidy, paste0(PATH_SAVE, PREC_GLOBAL_DATASETS[[dataset_count]], "_raw.rds"))
  
  # Clean up memory
  gc(); rm(prec_tidy)
}
