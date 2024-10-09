### 
# Step 5: Time series plot for intensity (total precipitation / number of wet days)
###

# Load necessary libraries and functions
source("./source/lib.R")
source("./source/functions.R")
source("./source/global_variables.R")

# Load annual intensity statistics
annual_statistics <- readRDS(
  paste0(PATH_PROCESSED_DATA, "annual_stats.rds")
)

# Time series plot function for precipitation intensity
prec_intensity_ts <- function(data, label, palette) {
  plot_ts(data = data, dataset_col = "dataset", 
          x = "year", y = "intensity", 
          y_title = "Precipitation (mm/day)", 
          x_labels = FALSE, legend_title = label, 
          palette = palette) + 
    theme(legend.position = "none")
}

# Create plots for different sources
prec_intensity_ts_sources <- list(
  prec_intensity_ts(
    annual_statistics[source == "gauge-based"], 
    "gauge-based", 
    GAUGE_BASED_PALETTE
  ),
  prec_intensity_ts(
    annual_statistics[source == "reanalysis-based"], 
    "reanalysis-based", 
    REANALYSIS_BASED_PALETTE
  ),
  prec_intensity_ts(
    annual_statistics[source == "satellite-based"], 
    "satellite-based", 
    SATELLITE_BASED_PALETTE
  ) + theme(axis.text.x = element_text(
    angle = 45, 
    hjust = 0.9, 
    color = "black", 
    family = "sans-serif", 
    size = 16)
  )
)

# Extract legends from plots
legends <- lapply(prec_intensity_ts_sources, function(plot) {
  get_legend(plot + theme(legend.position = "right"))
})

# Arrange plots and legends
combined_plots <- ggarrange(
  plotlist = prec_intensity_ts_sources, nrow = 3
)
combined_legends <- ggarrange(
  plotlist = legends, nrow = 3
)

# Combine and annotate the precipitation intensity time series plot
combined_prec_intensity_ts_sources <- ggarrange(
  combined_plots, combined_legends, 
  ncol = 2, widths = c(3, 0.5)
)

combined_prec_intensity_ts_sources <- annotate_figure(
  combined_prec_intensity_ts_sources, 
  bottom = text_grob("Time (year)", size = 16, vjust = 0.5)
)

# Save the plot
cairo_pdf("results/figures/prec_intensity_ts.pdf", width = 14, height = 22,
          family = "sans", bg = "white", fallback_resolution = 600)
print(combined_prec_intensity_ts_sources)
dev.off()
