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
  
  # Update domain if necessary
  if (domain == "raw") {
    domain <- "land"
  } else if (domain == "med") {
    domain <- "mediterranean"
  }
  
  # If datasets is "all", assign all available datasets
  if (datasets == "all") {
    datasets <- all_datasets
  }
  
  # Loop through each dataset and download
  for (dataset in datasets) {
    # Construct file name based on dataset
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
    
    # Construct full URL and file destination
    file_url <- paste0(zenodo_base, file_name, zenodo_end)
    file_destination <- file.path(path, file_name)
    
    # Attempt to download the file
    try(download.file(file_url, file_destination, mode = "wb"), silent = TRUE)
  }
}
