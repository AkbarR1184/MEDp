###
# step 09: Upset plots for total precipitation, number of wet days ,and intensity
###

source("./source/lib.R")
source("./source/functions.R")
source("./source/global_variables.R")
source("./source/graphics.R")

#load data

slope_data <-
  readRDS(paste0(PATH_PROCESSED_DATA, "prec_tot_wday_intensity_slope.rds"))

install.packages("ComplexUpset", type="source")
library(ComplexUpset)

# data structure 
colnames(slope_data) <- c("lon","lat","dataset",
                          "total P (+)", "total P (-)","wet days (+)", 
                          "wet days (-)", "intensity (+)","intensity (-)")

#exclude points that have unexpected results due to method limitation
filtered_data1 <-
  slope_data[`total P (+)` == 1 &
               `total P (-)` == 0 & `wet days (-)` == 0 & `wet days (+)` == 0]
filtered_data2 <-
  slope_data[`total P (+)` == 0 &
               `total P (-)` == 1 & `wet days (-)` == 0 & `wet days (+)` == 0]

ex_points <- rbind(filtered_data1, filtered_data2)
slope_data <- slope_data[!ex_points, on=.(lon, lat, dataset)]

#remove unneccessary files
rm(dt, filtered_data1, filtered_data2)

# define two sub-regions lon<0 (region1), and lon>30 (region2)
slope_data_region1 <- slope_data[lon<0]
slope_data_region2 <- slope_data[lon> 30]
slope_data[, dataset := PREC_FIGURE_IDENTIFIERS[dataset]]
#define sets 
combination <- colnames(slope_data)[4:9]

upset_med <- plot_upset_three(slope_data, combination)
ggsave("prec_tot_wday_intensity_upset_med.png", 
       width = 11.69, height = 8.27, units = "in", dpi = 600) 

# Plot upset for region1 and region2
upset_region1 <- plot_upset_three(slope_data_region1, combination)
upset_region2 <- plot_upset_three(slope_data_region2, combination)

# Arrange and save the region1 and region2 plots
ggpubr::ggarrange(upset_region1, upset_region2, 
                  ncol = 1, common.legend = TRUE, legend = "right", 
                  labels = c("A", "B"))
ggsave("prec_tot_wday_intensity_upset_west_east.png", 
       width = 11.69, height = 16, units = "in", dpi = 600)  
