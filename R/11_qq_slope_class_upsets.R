###
# step 11: Upset plots for precipitation classes

#load necessary libraries
source("./source/lib.R")
source("./source/functions.R")
source("./source/global_variables.R")
source("./source/graphics.R")

prec_classes_slope <- readRDS(paste0(PATH_PROCESSED_DATA, "prec_class_upset_data.rds"))

# Rename columns for clarity
colnames(prec_classes_slope) <- c("lon","lat","dataset","L+","L-","M+", 
                         "M-","H+", "H-","VH+","VH-")

# Map dataset identifiers
prec_classes_slope[, dataset := PREC_FIGURE_IDENTIFIERS[dataset]]

# Subset data by region
prec_classes_slope_region1 <- prec_classes_slope[lon<0]
prec_classes_slope_region2 <- prec_classes_slope[lon> 30]

# Define combinations for plotting
comb <- colnames(prec_classes_slope)[4:11]

# Create and save upset plot for all data
p01 <-
  plot_upset(
    data = prec_classes_slope,
    combination = comb,
    n_intersection = 16,
    max_degree = 4,
    min_degree = 4
  )

ggsave(
  plot = p01,
  width = 13,
  height = 8.27,
  units = "in",
  dpi = 600,
  filename = paste0(PATH_SAVE_FIGURES, "qq_upset_med.pdf")
) 

# Create and save upset plot for region 1
p02 <-
  plot_upset(
    data = prec_classes_slope_region1,
    combination = comb,
    n_intersection = 16,
    max_degree = 4,
    min_degree = 4
  )

ggsave(
  plot = p02,
  width = 13,
  height = 8.27,
  units = "in",
  dpi = 600,
  filename = paste0(PATH_SAVE_FIGURES, "qq_upset_west.pdf")
) 

# Create and save upset plot for region 2
p03 <-
  plot_upset(
    data = prec_classes_slope_region2,
    combination = comb,
    n_intersection = 16,
    max_degree = 4,
    min_degree = 4
  )

ggsave(
  plot = p03,
  width = 13,
  height = 8.27,
  units = "in",
  dpi = 600,
  filename = paste0(PATH_SAVE_FIGURES, "qq_upset_east.pdf"))


