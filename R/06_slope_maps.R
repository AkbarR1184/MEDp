###
# Step 7: Slope Maps 
###

# Load required scripts
source("./source/lib.R")
source("./source/functions.R")
source("./source/global_variables.R")
source("./source/graphics.R")

# Load processed slope data
prec_tot_slope <- readRDS(paste0(PATH_PROCESSED_DATA, "prec_tot_slope.rds"))

# Update the dataset names using the mapping
prec_tot_slope[, dataset := PREC_FIGURE_IDENTIFIERS[dataset]]

# Add a column to flag significance
prec_tot_slope$significant <- prec_tot_slope$`P-value` < 0.05

# Prepare for plotting by capping slopes
prec_tot_slope[, capped_slope := pmax(pmin(`Sen's slope`, 0.15), -0.15)]

# Create the plot
p00 <- ggplot() +
  geom_raster(data = prec_tot_slope, 
              aes(x = lon, y = lat, fill = capped_slope), 
              interpolate = TRUE) +
  geom_point(data = prec_tot_slope[significant == TRUE],
             aes(x = lon, y = lat), 
             fill = "black", size = 0.1) +
  borders(colour = "black", size = 0.5) +
  coord_cartesian(xlim = c(-10, 40), ylim = c(34, 45), expand = FALSE) +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = NA), 
    panel.ontop = FALSE,
    panel.grid = element_line(color = "grey"),
    strip.background = element_blank(),
    strip.placement = "outside",
    strip.text = element_text(hjust = 0, size = 14),
    text = element_text(family = "sans", color = "black", size = 14),
    axis.title = element_text(size = 14, family = "sans", color = "black"),
    axis.text = element_text(size = 12, family = "sans", color = "black"),
    plot.title = element_text(size = 18, hjust = 0.5),
    panel.grid.major = element_line(color = "gray80"),
    panel.spacing.x = unit(1.5, "lines"),
    panel.grid.minor = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank()
  ) +
  facet_wrap(~dataset, ncol = 2) +
  scale_x_continuous(
    expand = c(0, 0),
    breaks = seq(-10, 40, by = 10),
    labels = paste0(seq(-10, 40, by = 10), "\u00b0")
  ) +
  scale_y_continuous(
    expand = c(0, 0),
    breaks = seq(35, 45, by = 5),
    labels = paste0(seq(35, 45, by = 5), "\u00b0")
  ) +
  scale_fill_gradientn(
    colours = slope_palettes,
    name = "Slope",
    limits = c(-0.15, 0.15),
    oob = scales::oob_squish,
    guide = my_triangle_colourbar()
  )

# Save the plot as a PDF
cairo_pdf("results/figures/prec_tot_slope_map.pdf",
          width = 11.5, height = 11.69, pointsize = 8,
          family = "sans", bg = "white",
          fallback_resolution = 600)

print(p00)
dev.off()
