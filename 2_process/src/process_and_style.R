#' Processing and styling site data 
#' @param file_in csv, site_data_csv includes cols site_no, X_00010_00000, X_00010_00000_cd, and tz_cd for each site 
#' @param site_filename csv, site_info.csv includes cols such as: station_nm, site_tp, lat_va, long_va, etc. for each site. 
#' @return df, contains cleaned data for plotting time series

process_data <- function(file_in, site_filename){
  site_info <- read_csv(site_filename)
  nwis_data_clean <- read_csv(file_in) %>% 
  rename(water_temperature = X_00010_00000) %>% 
    select(-agency_cd, -X_00010_00000_cd, -tz_cd) %>% 
    left_join(site_info, by = "site_no") %>% 
    select(station_name = station_nm, site_no, dateTime, water_temperature, latitude = dec_lat_va, longitude = dec_long_va) %>% 
    mutate(station_name = as.factor(station_name))
  
  return(nwis_data_clean)
}
