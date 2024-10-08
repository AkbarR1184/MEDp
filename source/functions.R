#' Download various precipitation datasets
#'
#' This function downloads specified precipitation datasets from Zenodo.
#'
#' @importFrom utils download.file
#' @param path A character string with the path where the data will be downloaded.
#' @param datasets A character vector specifying which datasets to download. 
#' Options include: "e_obs", "gpcc", "gpcp", "merra2_land", "mswep", "mswx", "gpm_imerg", "era5_land", "em_earth", "gsmap".
#' If set to "all", it will download all available datasets.
#' @param domain A character string with the desired domain data set. Suitable options are:
#' \itemize{
#' \item{"raw" for default available spatial coverage,}
#' \item{"global" for datasets with global (land and ocean) coverage,}
#' \item{"med" for datasets with mediterranean only coverage,}
#' \item{"land" for datasets with land only coverage,}
#' \item{"ocean" for datasets with ocean only coverage.}
#' }
#' @param time_res A character string with the desired time resolution. Suitable options are:
#' \itemize{
#' \item{"daily",}
#' \item{"monthly",}
#' \item{"yearly".}
#' }
#' @return No return value, called to download the datasets.
#' @keywords internal
download_data <- function(path = "", datasets, domain = "raw", time_res = "daily") {
  # Base URL for Zenodo
  zenodo_base <- "https://zenodo.org/records/13897331/files/"
  zenodo_end <- "?download=1"
  
  # List of all available datasets
  all_datasets <- c("e_obs", "gpm_imerg", "era5_land", "em_earth", "gsmap", "gpcc", "gpcp", "merra2_land", "mswep", "mswx")
  
  if (domain == "raw") {
    domain <- "land"
  } else if (domain == "med") {
    domain <- "mediterranean"
  }
  
  if (datasets == "all") {
    datasets <- all_datasets
  }
  
  for (dataset in datasets) {
    file_name <- switch(dataset,
                        e_obs = paste0("e-obs_tp_mm_", domain, "_200101_201912_025_", time_res, ".nc"),
                        gpm_imerg = paste0("gpm-imerg-v6_tp_mm_", domain, "_200101_201912_025_", time_res, ".nc"),
                        era5_land = paste0("era5-land_tp_mm_", domain, "_200101_201912_025_", time_res, ".nc"),
                        em_earth = paste0("em-earth_tp_mm_", domain, "_200101_201912_025_", time_res, ".nc"),
                        gsmap = paste0("gsmap-v8_tp_mm_", domain, "_200101_201912_025_", time_res, ".nc"),
                        gpcc = paste0("gpcc-v2020_tp_mm_", domain, "_200101_201912_025_", time_res, ".nc"),
                        gpcp = paste0("gpcp-v3-2_tp_mm_", domain, "_200101_201912_025_", time_res, ".nc"),
                        merra2_land = paste0("merra2-land_tp_mm_", domain, "_200101_201912_025_", time_res, ".nc"),
                        mswep = paste0("mswep-v2-8_tp_mm_", domain, "_200101_201912_025_", time_res, ".nc"),
                        mswx = paste0("mswx-past_tp_mm_", domain, "_200101_201912_025_", time_res, ".nc"),
                        stop("Unknown dataset specified.")
    )
    
    file_url <- paste0(zenodo_base, file_name, zenodo_end)
    file_destination <- file.path(path, file_name)
    
    try(download.file(file_url, file_destination, mode = "wb"), silent = TRUE)
  }
}



# plot_ts function 

plot_ts <- function(data, x, y, dataset_col, palette, y_title = "Precipitation (mm/year)", x_labels = TRUE, legend_title = "Name") {
  p <- ggplot(data, aes_string(x = x, y = y, color = dataset_col, group = dataset_col)) +
    geom_line(linetype = "solid", size = 1) +
    geom_point(shape = 19, size = 3, alpha = 0.7) +  # Add transparency
    geom_smooth(method = "loess", se = FALSE, aes_string(color = dataset_col), size = 0.5, linetype = "solid") +
    scale_color_manual(name = legend_title, values = palette) +
    labs(
      title = "",
      x = ifelse(x_labels, "", ""),
      y = y_title
    ) +
    scale_x_continuous(breaks = seq(2001, 2019, by = 1), limits = c(2001, 2019), expand = c(0.005, 0.005)) +
    theme_minimal() +
    theme(
      axis.text.x = if (x_labels) element_text(angle = 45, hjust = 0.9, color = "black", family = "sans-serif", size = 16) else element_blank(),
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
  
  return(p)
}
