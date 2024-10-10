###
# step 10: Slope calculation for precipitation classes

#load necessary libraries
source("./source/lib.R")
source("./source/functions.R")
source("./source/global_variables.R")
source("./source/graphics.R")

#load data
prec_data <-
  readRDS(paste0(PATH_PROCESSED_DATA, "prec_data_2001_2019.rds"))

# Calculate quantiles and merge with original data
prec_data_m <- prec_data[, as.list(quantile(precip, probs = c(0.3, 0.6, 0.9))), 
                         by = .(lon, lat, year, dataset)]
prec_data_m <- merge(prec_data_m, prec_data[, .(lon, lat, year, precip, dataset)], 
                     by = c("lon", "lat", "year", "dataset"), 
                     allow.cartesian = TRUE)

# Categorize precipitation
prec_data_m[, category := fifelse(precip < `30%`, "light",
                                  fifelse(precip < `60%`, "medium",
                                          fifelse(precip < `90%`, "hvy", "vhvy")))]

# Calculate mean precipitation for each category
prec_data_m <- prec_data_m[, lapply(.SD, mean, na.rm = TRUE), 
                           .SDcols = "precip", 
                           by = .(lon, lat, year, dataset, category)]
setnames(prec_data_m, "precip", "m_quant")

# Calculate slopes
prec_class_slope <-
  prec_data_m[, as.list(tryCatch(
    mkttest((m_quant - mean(m_quant, na.rm = TRUE)) / (sd(m_quant, na.rm = TRUE)))
    [c(2, 5)],error = function(e)NULL)), .(lon, lat, category, dataset)]

# Save slope results
saveRDS(qq_class_slopes,
        paste0(PATH_PROCESSED_DATA, "prec_class_slope.rds"))

# Flagging positive and negative slopes for each category
qq_class_slopes[category == "light" & `Sen's slope` > 0, lt_pos := 1]
qq_class_slopes[category == "light" & `Sen's slope` < 0, lt_neg := 1]

qq_class_slopes[category == "medium" & `Sen's slope` > 0, mid_pos := 1]
qq_class_slopes[category == "medium" & `Sen's slope` < 0, mid_neg := 1]

qq_class_slopes[category == "hvy" & `Sen's slope` > 0, hvy_pos := 1]
qq_class_slopes[category == "hvy" & `Sen's slope` < 0, hvy_neg := 1]

qq_class_slopes[category == "vhvy" & `Sen's slope` > 0, vhvy_pos := 1]
qq_class_slopes[category == "vhvy" & `Sen's slope` < 0, vhvy_neg := 1]

qq_class_slopes[is.na(qq_class_slopes)] <- 0
qq_class_slopes <- qq_class_slopes[, c(1:4, 7:14)]
qq_class_slopes <- qq_class_slopes[, 
                          lapply(.SD, max), 
                          .SDcols = c(5:12), 
                          by = .(lon, lat, dataset)]

# Save the final data for further analysis
saveRDS(qq_class_slopes, paste0(PATH_PROCESSED_DATA, "prec_class_upset_data.rds"))
