### NECCESSARY PACKAGES ##
library(tidyverse)
library(scales)

## LOADING DATA ##
dat <- readRDS("data/stockholm.rds")

dat_new <- dat %>%
  mutate(price= parse_number(dat$price),
         neighbourhood2 = iconv(neighbourhood, from = "ASCII", to = "latin1"))


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


#median_price("Norrmalm")



#### SUPERHOST FRACTION PER DISTRICT ####

superhost_frac <- function(district){
  if(district!="Stockholm"){
    group<- dat_new %>%
      filter(neighbourhood==district)
  }
  else{
    group <- dat_new

  }
  total_length <- group$price %>% length()
  no_superhost <- group %>%
    filter(host_is_superhost=="t") %>%
    .$host_is_superhost %>%
    length()
  fraction_SH <- ((no_superhost/total_length)*100) %>% round(., digits=0)
  fraction_not_SH <- 100-fraction_SH

#Create dataframe with fraction values
  output_mat <- matrix(c(fraction_SH, fraction_not_SH), nrow = 2, dimnames = list(c("Superhost", "Normal host"), c("Values"))) %>%
    as.data.frame() %>%
    rownames_to_column("Fraction")


#Plot
  gg_output <- ggplot(output_mat, aes(x="", y=Values, fill=Fraction))+
    geom_bar(stat = "identity")+
    coord_polar("y", start=0)+
    scale_fill_brewer("Blues") +
    theme(axis.text.x=element_blank())+
    geom_text(aes(y = Values/2 + c(0, cumsum(Values)[-length(Values)]),
                  label = percent(Values/100)), size=4)+
    theme_minimal()+
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      panel.border = element_blank(),
      panel.grid=element_blank(),
      axis.ticks = element_blank(),
      axis.text = element_blank(),
      legend.title = element_blank()
    )

#Print plot
  return(gg_output)

  }


#superhost_frac("Stockholm")




