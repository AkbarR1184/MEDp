###
# Step 4: Time series plot for the number of wet days
###

# Load necessary libraries and functions
source("./source/lib.R")
source("./source/functions.R")
source("./source/global_variables.R")

# Load annual statistics
annual_statistics <- readRDS(
  paste0(PATH_PROCESSED_DATA, "annual_stats.rds")
)

# Time series plot function for wet days
prec_wday_ts <- function(data, label, palette) {
  plot_ts(data = data, 
          dataset_col = "dataset", 
          x = "year", 
          y = "wet_days", 
          y_title = "Number of Wet Days", 
          x_labels = FALSE, 
          legend_title = label, 
          palette = palette) + 
    theme(legend.position = "none")
}

# Create plots for different data sources focusing on the number of wet days
prec_wday_ts_sources <- list(
  prec_wday_ts(annual_statistics[source == "gauge-based"], "gauge-based", 
                   GAUGE_BASED_PALETTE),
  prec_wday_ts(annual_statistics[source == "reanalysis-based"], "reanalysis-based", 
                   REANALYSIS_BASED_PALETTE),
  prec_wday_ts(annual_statistics[source == "satellite-based"], "satellite-based", 
                   SATELLITE_BASED_PALETTE) + 
    theme(axis.text.x = element_text(angle = 45, hjust = 0.9, 
                                     color = "black", 
                                     family = "sans-serif", 
                                     size = 16))
)

# Extract legends from the wet days plots
legends <- lapply(prec_wday_ts_sources, function(plot) {
  get_legend(plot + theme(legend.position = "right"))
})

# Arrange plots and legends for the number of wet days
combined_plots <- ggarrange(plotlist = prec_wday_ts_sources, nrow = 3)
combined_legends <- ggarrange(plotlist = legends, nrow = 3)

# Combine and annotate the wet days time series plot
combined_prec_wday_ts_sources <- ggarrange(combined_plots, combined_legends, 
                                       ncol = 2, widths = c(3, 0.5))
combined_prec_wday_ts_sources <- annotate_figure(combined_prec_wday_ts_sources, 
                     bottom = text_grob("Time (Year)", size = 16, vjust = 0.5))

# Save the plot as a PDF
cairo_pdf("results/figures/prec_wdays_ts.pdf", width = 14, height = 22,
          family = "sans", bg = "white", fallback_resolution = 600)
print(combined_prec_wday_ts_sources)
dev.off()
