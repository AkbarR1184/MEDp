###
# Step 3: Calculating annual statistics such as annual total precipitation, 
#Number of wet days, and Intensity
###

# Source the required libraries and functions
source("./source/lib.R")
source("./source/functions.R")
source("./source/global_variables.R")

annual_stats <- readRDS(paste0(PATH_PROCESSED_DATA, "annual_stats.rds"))

# Create the plot with summary statistics in columns at the top
p01<- ggplot(annual_stats, aes(x =year , y = intensity, color = dataset, group = dataset)) +
  geom_line(linetype = "solid", size = 1) +
  geom_point(shape = 19, size = 3, alpha = 0.7) +  # Add transparency
  geom_smooth(method = "loess", se = FALSE, aes(color = dataset), size = 0.5, linetype = "solid") +
  scale_color_manual(name = "name", values = pallete)+
  labs(
    title = "",
    x = "",
    y = "Precipitation (mm/year)"
  ) +
  scale_x_continuous(breaks = seq(2001, 2019, by = 1), limits = c(2001, 2019), expand = c(0.005, 0.005)) +
  theme_minimal() +
  theme(
    axis.text.x = element_blank(),
    axis.ticks = element_line(),
    axis.text.y = element_text(color = "black", family = "sans-serif", size = 16),
    axis.title.y = element_text(color = "black", family = "sans-serif", size = 16, margin = margin(t = 0, r = 20, b = 0, l = 0)),
    legend.position = "right",
    panel.border = element_rect(size = 1, colour = "black", fill = NA),
    legend.key.height = unit(2, "lines"),
    legend.text = element_text(color = "black", family = "sans-serif", size = 12),
    legend.title = element_text(color = "black", family = "sans-serif", size = 14),
    legend.text.align = 0
  )


# Create the plot with summary statistics in columns at the top
p02<- ggplot(prec_data_2001_2019_R, aes(x = year, y = avg_intensity, color = dataset, group = dataset)) +
  geom_line(linetype = "solid", size = 1) +
  geom_point(shape = 19, size = 3, alpha = 0.7) +  # Add transparency
  geom_smooth(method = "loess", se = FALSE, aes(color = dataset), size = 0.5, linetype = "solid") +
  scale_color_manual(name="reanalysis-based",values = c(
    "ERA5-Land" = "#DDCC77",
    "MERRA2-Land"= "#999933",
    "MSWEP v2.8"="#882255",
    "MSWX-past" = "#888888"
  )) +
  labs(
    title = "",
    x = "",
    y = "Precipitation (mm/day)"
  ) +
  scale_x_continuous(breaks = seq(2001, 2019, by = 1), limits = c(2001, 2019), expand = c(0.005, 0.005)) +
  theme_minimal() +
  theme(
    axis.text.x = element_blank(),
    axis.ticks = element_line(),
    axis.text.y = element_text(color = "black", family = "sans-serif", size = 16),
    axis.title.y = element_text(color = "black", family = "sans-serif", size = 16, margin = margin(t = 0, r = 20, b = 0, l = 0)),
    legend.position = "right",
    legend.title = element_text(color = "black", family = "sans-serif", size = 14),
    panel.border = element_rect(size = 1, colour = "black", fill = NA),
    legend.key.height = unit(2, "lines"),
    legend.text = element_text(color = "black", family = "sans-serif", size = 12),
    legend.text.align = 0
  ) +
  # Annotate summary statistics for each dataset as columns
  annotate(
    "text", 
    x = 2001, 
    y = 8,  # Adjust y-position to accommodate for text positioning at the top
    label = paste(
      "ERA5-Land\n",
      "Min: ", summary_stats_R$Min[summary_stats_R$dataset == "ERA5-Land"], "\n",
      "Mean: ", summary_stats_R$Mean[summary_stats_R$dataset == "ERA5-Land"], "\n",
      "Max: ", summary_stats_R$Max[summary_stats_R$dataset == "ERA5-Land"]
    ),
    hjust = 0, vjust = 1, 
    size = 4, color = "#DDCC77", family = "sans-serif"
  ) +
  annotate(
    "text", 
    x = 2003, 
    y = 8,  # Same y-position for uniformity across datasets
    label = paste(
      "MERRA2-Land\n",
      "Min: ", summary_stats_R$Min[summary_stats_R$dataset == "MERRA2-Land"], "\n",
      "Mean: ", summary_stats_R$Mean[summary_stats_R$dataset == "MERRA2-Land"], "\n",
      "Max: ", summary_stats_R$Max[summary_stats_R$dataset == "MERRA2-Land"]
    ),
    hjust = 0, vjust = 1, 
    size = 4, color = "#999933", family = "sans-serif"
  ) +
  annotate(
    "text", 
    x = 2005, 
    y = 8,  # Same y-position for uniformity across datasets
    label = paste(
      "MSWEP v2.8\n",
      "Min: ", summary_stats_R$Min[summary_stats_R$dataset == "MSWEP v2.8"], "\n",
      "Mean: ", summary_stats_R$Mean[summary_stats_R$dataset == "MSWEP v2.8"], "\n",
      "Max: ", summary_stats_R$Max[summary_stats_R$dataset == "MSWEP v2.8"]
    ),
    hjust = 0, vjust = 1, 
    size = 4, color = "#882255", family = "sans-serif"
  )+
  annotate(
    "text", 
    x = 2007, 
    y = 8,  # Same y-position for uniformity across datasets
    label = paste(
      "MSWX-past\n",
      "Min: ", summary_stats_R$Min[summary_stats_R$dataset == "MSWX-past"], "\n",
      "Mean: ", summary_stats_R$Mean[summary_stats_R$dataset == "MSWX-past"], "\n",
      "Max: ", summary_stats_R$Max[summary_stats_R$dataset == "MSWX-past"]
    ),
    hjust = 0, vjust = 1, 
    size = 4, color = "#888888", family = "sans-serif"
  )

#Satellite-Based



# Create the plot with summary statistics in columns at the top
p03<- ggplot(prec_data_2001_2019_S, aes(x = year, y = avg_intensity, color = dataset, group = dataset)) +
  geom_line(linetype = "solid", size = 1) +
  geom_point(shape = 19, size = 3, alpha = 0.7) +  # Add transparency
  geom_smooth(method = "loess", se = FALSE, aes(color = dataset), size = 0.5, linetype = "solid") +
  scale_color_manual(name="satellite-based",values = c(
    "GPCP v3.2" = "#332288",
    "GPM-IMERG v6"= "#AA4499",
    "GSMap v8"="#44AA99"
  )) +
  labs(
    title = "",
    x = "Time (year)",
    y = "Precipitation (mm/day)"
  ) +
  scale_x_continuous(breaks = seq(2001, 2019, by = 1), limits = c(2001, 2019), expand = c(0.005, 0.005)) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 0.9, color = "black", family = "sans-serif", size = 16),
    axis.ticks = element_line(),
    axis.text.y = element_text(color = "black", family = "sans-serif", size = 16),
    axis.title.y = element_text(color = "black", family = "sans-serif", size = 16, margin = margin(t = 0, r = 20, b = 0, l = 0)),
    axis.title.x = element_text(color = "black", family = "sans-serif", size = 16),
    legend.position = "right",
    panel.border = element_rect(size = 1, colour = "black", fill = NA),
    legend.key.height = unit(2, "lines"),
    legend.title = element_text(color = "black", family = "sans-serif", size = 14),
    legend.text = element_text(color = "black", family = "sans-serif", size = 12),
    legend.text.align = 0
  ) +
  # Annotate summary statistics for each dataset as columns
  annotate(
    "text", 
    x = 2001, 
    y = 8,  # Adjust y-position to accommodate for text positioning at the top
    label = paste(
      "GPCP v3.2\n",
      "Min: ", summary_stats_S$Min[summary_stats_S$dataset == "GPCP v3.2"], "\n",
      "Mean: ", summary_stats_S$Mean[summary_stats_S$dataset == "GPCP v3.2"], "\n",
      "Max: ", summary_stats_S$Max[summary_stats_S$dataset == "GPCP v3.2"]
    ),
    hjust = 0, vjust = 1, 
    size = 4, color = "#332288", family = "sans-serif"
  ) +
  annotate(
    "text", 
    x = 2003, 
    y = 8,  # Same y-position for uniformity across datasets
    label = paste(
      "GPM-IMERG v6\n",
      "Min: ", summary_stats_S$Min[summary_stats_S$dataset == "GPM-IMERG v6"], "\n",
      "Mean: ", summary_stats_S$Mean[summary_stats_S$dataset == "GPM-IMERG v6"], "\n",
      "Max: ", summary_stats_S$Max[summary_stats_S$dataset == "GPM-IMERG v6"]
    ),
    hjust = 0, vjust = 1, 
    size = 4, color = "#AA4499", family = "sans-serif"
  ) +
  annotate(
    "text", 
    x = 2005, 
    y = 8,  # Same y-position for uniformity across datasets
    label = paste(
      "GSMap v8\n",
      "Min: ", summary_stats_S$Min[summary_stats_S$dataset == "GSMap v8"], "\n",
      "Mean: ", summary_stats_S$Mean[summary_stats_S$dataset == "GSMap v8"], "\n",
      "Max: ", summary_stats_S$Max[summary_stats_S$dataset == "GSMap v8"]
    ),
    hjust = 0, vjust = 1, 
    size = 4, color = "#44AA99", family = "sans-serif"
  )


legend1 <- get_legend(p01 + theme(legend.position = "right"))
legend2 <- get_legend(p02 + theme(legend.position = "right"))
legend3 <- get_legend(p03 + theme(legend.position = "right"))

# Remove legends from the plots
p01_no_legend <- p01 + theme(legend.position = "none")
p02_no_legend <- p02 + theme(legend.position = "none")
p03_no_legend <- p03 + theme(legend.position = "none")
library(ggpubr)
plot_arrangement <- ggarrange(p01_no_legend, p02_no_legend, p03_no_legend, nrow = 3, heights = c(1, 1, 1))

# Arrange legends in one column
legend_arrangement <- ggarrange(legend1, legend2, legend3, nrow = 3, heights = c(1, 1, 1))

# Combine plots and legends side by side
final_plot <- ggarrange(plot_arrangement, legend_arrangement, ncol = 2, widths = c(3, 0.5))

cairo_pdf("intensity_ts.pdf" ,
          width = 14, height = 22,
          family = "sans", bg = "white",
          fallback_resolution = 600)
print(final_plot)  # Print the plot to the device
dev.off()  # C
ggpubr::ggarrange(p01, p02, p03, nrow = 3, 
                  heights = c(1, 1, 1), # Adjust heights if needed
                  widths = c(1, 1, 1))