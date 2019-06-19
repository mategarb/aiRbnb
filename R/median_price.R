#### MEDIAN PRICE PER DISTRICT ####

median_price <- function(district){
  if(district!="Stockholm"){
    group<- dat_new %>%
      filter(neighbourhood==district)
  }
  else{
    group <- dat_new

  }
  output <- group$price %>% median()

  return(output)
}
