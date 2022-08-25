source("2_process/src/process_and_style.R")

p2_targets_list <- list(
  tar_target(
    site_data_process_style, 
    process_data(file_in = site_data_csv, site_filename = site_info_csv)
  )
)