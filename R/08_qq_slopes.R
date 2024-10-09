results <- prec_djf[, qq_slopes(.SD), by = dataset, .SDcols = c("lon", "lat", "precip", "year")]
