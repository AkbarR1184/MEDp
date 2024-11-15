###
# Step 9: Calculating Quantile Slopes and Generating Plots
###

# Load libraries
source("./source/lib.R")
source("./source/functions.R")
source("./source/global_variables.R")
source("./source/graphics.R")

# Load data
prec_data <- readRDS(
  paste0(PATH_PROCESSED_DATA, "prec_data_2001_2019.rds")
)

# Calculate quantile slopes
qq_sl <- prec_data[, qq_slopes(.SD), 
                   by = dataset, 
                   .SDcols = c("lon", "lat", "precip", "year")]

# Save data
saveRDS(qq_sl, paste0(PATH_PROCESSED_DATA, "qq_slope.rds"))

# Update dataset names
qq_sl[, dataset := PREC_FIGURE_IDENTIFIERS[dataset]]

# Calculate mean slope
qq_sl_mean <- qq_sl[, 
                    mean_slope := mean(slope, na.rm = TRUE), 
                    by = .(dataset, quantile)]

# Subset for the western and eastern parts
qq_sl_region1 <- qq_sl[lon < 0]
qq_sl_region2 <- qq_sl[lon > 30]

# Calculate mean slopes for regions
qq_sl_region1[, mean_slope := mean(slope, na.rm = TRUE), 
              by = .(dataset, quantile)]
qq_sl_region2[, mean_slope := mean(slope, na.rm = TRUE), 
              by = .(dataset, quantile)]

# Prepare data for plotting
qq_sl_plot <- unique(qq_sl_mean[, .(mean_slope, dataset, quantile)])
qq_sl_median <- qq_sl_plot[, .(median = median(mean_slope)), 
                           by = quantile]
qq_sl_median[, dataset := "median"]

# Region 1 plotting data
qq_sl_region1_plot <- unique(qq_sl_region1[, 
                                           .(mean_slope, dataset, quantile)])
qq_sl_median_region1 <- qq_sl_region1_plot[, 
                                           .(median = median(mean_slope), 
                                             dataset = "median"), 
                                           by = quantile]

# Region 2 plotting data
qq_sl_region2_plot <- unique(qq_sl_region2[, 
                                           .(mean_slope, dataset, quantile)])
qq_sl_median_region2 <- qq_sl_region2_plot[, 
                                           .(median = median(mean_slope), 
                                             dataset = "median"), 
                                           by = quantile]

# Generate plots for all data and regions; 
# the same can be applied for significant results
p01 <- qq_plot(
  data = qq_sl_plot,
  median_data = qq_sl_median,
  palette = c(GAUGE_BASED_PALETTE, 
              REANALYSIS_BASED_PALETTE, 
              SATELLITE_BASED_PALETTE)
)

p02 <- qq_plot(
  data = qq_sl_region1_plot,
  median_data = qq_sl_median_region1,
  palette = c(GAUGE_BASED_PALETTE, 
              REANALYSIS_BASED_PALETTE, 
              SATELLITE_BASED_PALETTE)
)

p03 <- qq_plot(
  data = qq_sl_region2_plot,
  median_data = qq_sl_median_region2,
  palette = c(GAUGE_BASED_PALETTE, 
              REANALYSIS_BASED_PALETTE, 
              SATELLITE_BASED_PALETTE)
)

# Arrange and save the final plot
p04 <- ggarrange(
  p01, 
  common.legend = TRUE, 
  legend = "right",                                               
  ggarrange(p02, p03, ncol = 2, labels = c("B", "C")),
  nrow = 2, 
  labels = "A"
)

ggsave(
  plot = p04,
  filename = paste0(PATH_SAVE_FIGURES, "qq_slopes_sig.pdf"),
  width = 8.02, 
  height = 6.01, 
  units = "in",
  dpi = 600
)
