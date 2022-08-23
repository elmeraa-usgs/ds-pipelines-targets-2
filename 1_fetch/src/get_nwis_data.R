#' Getting NWIS Data 
#'
#' @param site_num character, 4 different site_num: "01427207", "01432160", "01436690", "01466500"
#' @param file_out csv, csv exported for each designated site_num
#' @param parameterCd 
#' @param startDate 
#' @param endDate 
#'
#' @export csvs,export 5 csvs: site_info.csv, nwis_01427207_data.csv, nwis_01432160_data.csv, nwis_01436690_data.csv, & nwis_01466500_data.csv. 

download_nwis_site_data <- function(file_out, site_num, parameterCd = '00010', startDate="2014-05-01", endDate="2015-05-01"){
  
  # # filepaths look something like directory/nwis_01432160_data.csv,
  # # remove the directory with basename() and extract the 01432160 with the regular expression match
  # site_num <- basename(filepath) %>% 
  #   stringr::str_extract(pattern = "(?:[0-9]+)")
  
  # readNWISdata is from the dataRetrieval package
  data_out <- readNWISdata(sites=site_num, service="iv", 
                           parameterCd = parameterCd, startDate = startDate, endDate = endDate)

  # -- simulating a failure-prone web-sevice here, do not edit --
  set.seed(Sys.time())
  if (sample(c(T,F,F,F), 1)){
    stop(site_num, ' has failed due to connection timeout. Try tar_make() again')
  }
  # -- end of do-not-edit block
  
  write_csv(data_out, file = file_out)
  return(file_out)
}

# bind csvs so we can get site_info  
sites_csvs <- function(file_in){
  lapply(file_in, read_csv) %>% 
    bind_rows()
}

# obtain site info, includes cols such as: station_nm, site_tp, lat_va, long_va, etc.
nwis_site_info <- function(file_out, site_data){
  site_no <- unique(site_data$site_no)
  site_info <- dataRetrieval::readNWISsite(site_no)
  write_csv(site_info, file_out)
  return(file_out)
}
