#' Getting NWIS Data 
#'
#' @param site_num character, a site number for a USGS streamgage
#' @param file_out csv, csv exported with data on all 4 site_num
#' @param parameterCd, parameter code corresponding to the type of data queried
#' @param startDate 
#' @param endDate 
#'
#' @export csvs,export 2 csvs: site_data.csv and site_info.csv

download_nwis_site_data <- function(site_num, parameterCd, startDate, endDate){

  # readNWISdata is from the dataRetrieval package
  data_out <- readNWISdata(sites=site_num, service="iv", 
                           parameterCd = parameterCd, startDate = startDate, endDate = endDate)

  # -- simulating a failure-prone web-sevice here, do not edit --
  set.seed(Sys.time())
  if (sample(c(T,F,F,F), 1)){
    stop(site_num, ' has failed due to connection timeout. Try tar_make() again')
  }
  # -- end of do-not-edit block
  
  return(data_out)
}

# bind data so we can get site_info  
sites <- function(input, file_out){
    bind_rows(input) %>% 
    write_csv(file = file_out)
  return(file_out)
}

# obtain site info, includes cols such as: station_nm, site_tp, lat_va, long_va, etc.
nwis_site_info <- function(file_out, site_data){
  site_data <- read_csv(site_data)
  site_no <- unique(site_data$site_no)
  site_info <- dataRetrieval::readNWISsite(site_no)
  write_csv(site_info, file_out)
  return(file_out)
}
