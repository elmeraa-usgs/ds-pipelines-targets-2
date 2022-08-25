library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

# set parameters for downloading nwis data 
parameterCd <- '00010'
startDate <- "2014-05-01"
endDate <- "2015-05-01"

p1_targets_list <- list(
  tar_target(
    site_data_01427207,
    download_nwis_site_data(site_num = '01427207', parameterCd = parameterCd, startDate = startDate, endDate = endDate)
    ),
  tar_target(
    site_data_01432160,
    download_nwis_site_data(site_num = '01432160', parameterCd = parameterCd, startDate = startDate, endDate = endDate)
  ),
  tar_target(
    site_data_01436690,
    download_nwis_site_data(site_num = '01436690', parameterCd = parameterCd, startDate = startDate, endDate = endDate)
  ),
  tar_target(
    site_data_01466500,
    download_nwis_site_data(site_num = '01466500', parameterCd = parameterCd, startDate = startDate, endDate = endDate)
  ), 
  tar_target(
    site_data_csv,
    sites(input = list(site_data_01427207, site_data_01432160, site_data_01436690, site_data_01466500),
    file_out = "1_fetch/out/site_data.csv"),
    format = "file"
  ),
  tar_target(
    site_info_csv,
    nwis_site_info(file_out = "1_fetch/out/site_info.csv", site_data=site_data_csv),
    format = "file"
  )
)

p2_targets_list <- list(
  tar_target(
    site_data_process_style, 
    process_data(file_in = site_data_csv, site_filename = site_info_csv)
  )
)

p3_targets_list <- list(
  tar_target(
    figure_1_png,
    plot_nwis_timeseries(file_out = "3_visualize/out/figure_1.png", site_data_process_style),
    format = "file"
  )
)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)
