sumarize_data <- function(data, parameter, neighbourhood){
parameter.dat <- data %>% .[[parameter]] %>% as.character %>%
  parse_number %>% as.numeric

data[[parameter]]  <- data[[parameter]] %>% as.character
data[[parameter]] <-     parameter.dat




data_summary <- data %>% select(c( neighbourhood, parameter )) %>%
  group_by(neighbourhood) %>%
  summarize(mean_val = round(mean(.data[[parameter]],  na.rm = TRUE), digits=2),
            max_val = round(max(.data[[parameter]],  na.rm = TRUE), digits=2),
            median_val = round(median(.data[[parameter]],  na.rm = TRUE), digits=2))

return(data_summary)
}
