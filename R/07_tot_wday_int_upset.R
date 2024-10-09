###
#Step 8: Structuring Slope Data for Upset Plots
###

#load libraries
source("./source/lib.R")
source("./source/functions.R")
source("./source/global_variables.R")

#load data
prec_data <-
  readRDS(paste0(PATH_PROCESSED_DATA, "prec_data_2001_2019.rds"))

# slope for total precipitation, wet days number, intensity
prec_data <-
  unique(prec_data[, .(year, lon, lat, pr_year,wet_days,intensity, dataset)])

# Calculate slopes for total precipitation, wet days, and intensity
prec_tot_slope <- calc_slope(prec_data, "pr_year", indices = c(2, 5))

##significant at 0.95
prec_tot_slope_sig<- prec_tot_slope[`P-value`<0.05]

#Save data
saveRDS(prec_tot_slope, paste0(PATH_PROCESSED_DATA, "prec_tot_slope.rds"))
saveRDS(prec_tot_slope_sig, paste0(PATH_PROCESSED_DATA, "prec_tot_slope_sig.rds"))

# Calculate slopes for wet days
prec_wday_slope <- calc_slope(prec_data, "wet_days", indices = c(1, 5))

##significant at 0.95
prec_wday_slope_sig<- prec_wday_slope[`P-value`<0.05]

#Save data
saveRDS(prec_wday_slope, paste0(PATH_PROCESSED_DATA, "prec_wday_slope.rds"))
saveRDS(prec_wday_slope_sig, paste0(PATH_PROCESSED_DATA, "prec_wday_slope_sig.rds"))

# Calculate slopes for intensity
prec_intensity_slope <- calc_slope(prec_data, "intensity", indices = c(2, 5))
prec_intensity_slope_sig<- prec_intensity_slope[`P-value`<0.05]

#Save data
saveRDS(prec_intensity_slope, paste0(PATH_PROCESSED_DATA, "prec_intensity_slope.rds"))
saveRDS(prec_intensity_slope_sig, paste0(PATH_PROCESSED_DATA, "prec_intensity_slope_sig.rds"))

# Prepare data for upset plots
prec_tot_wday_intensity_slope <- merge(prec_tot_slope, prec_wday_slope,
                                       by = c("lon", "lat", "dataset"), all = TRUE)

prec_tot_wday_intensity_slope <- merge(
  prec_tot_wday_intensity_slope,
  prec_intensity_slope,
  by = c("lon", "lat", "dataset"),
  all = TRUE
)

prec_tot_wday_intensity_slope <-
  prec_tot_wday_intensity_slope[, c(1:4, 6, 8)]
setnames(
  prec_tot_wday_intensity_slope,
  c(
    "lon",
    "lat",
    "dataset",
    "prec_tot_slope",
    "prec_wday_slope",
    "prec_intensity_slope"
  )
)

prec_tot_wday_intensity_slope[prec_tot_slope > 0, total_p := 1]
prec_tot_wday_intensity_slope[prec_tot_slope < 0, total_n := 1]
prec_tot_wday_intensity_slope[prec_wday_slope > 0, wetdays_p := 1]
prec_tot_wday_intensity_slope[prec_wday_slope < 0, wetdays_n := 1]
prec_tot_wday_intensity_slope[prec_intensity_slope > 0, int_pos := 1]
prec_tot_wday_intensity_slope[prec_intensity_slope < 0, int_n := 1]

prec_tot_wday_intensity_slope[is.na(prec_tot_wday_intensity_slope)] <- 0
prec_tot_wday_intensity_slope <- prec_tot_wday_intensity_slope[,c(1:3, 7:12)]

saveRDS(prec_tot_wday_intensity_slope, 
        paste0(PATH_PROCESSED_DATA, 
               "prec_tot_wday_intensity_slope.rds"))
