#' Plotting water temperature over time for 4 stations 
#'
#' @param file_out file path, 3_visualize/out/figure_1.png
#' @param site_data_styled df, data from all 4 sites, cleaned and styled
#' @param width 
#' @param height 
#' @param units 

#' @export figure_1.png of water temp over time for 4 stations 

plot_nwis_timeseries <- function(file_out, site_data_process_style, width = 12, height = 7, units = 'in'){
  
  ggplot(data = site_data_process_style, aes(x = dateTime, y = water_temperature, color = station_name)) +
    geom_line() + theme_bw()
  ggsave(file_out, width = width, height = height, units = units)
  
  return(file_out)
}