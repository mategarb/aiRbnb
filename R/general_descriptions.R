
library(tidyverse)
library(scales)
dat <- readRDS("data/stockholm.rds")

dat_new <- dat %>%
  mutate(price= parse_number(dat$price))


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



superhost_rate <- function(district){
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
  fraction_SH <- (no_superhost/total_length)*100 %>% round(., digits=0)
  fraction_not_SH <- 100-fraction_SH
  output_mat <- matrix(c(total_length, no_superhost, fraction_SH, fraction_not_SH), ncol = 4, dimnames = list(c(district),
                                                                            c("Total", "Superhost", "Fraction_SH", "Fraction_not_SH"))) %>%
    as.data.frame()

  output_mat <- matrix(c(fraction_SH, fraction_not_SH), nrow = 2, dimnames = list(c("SH", "not_SH"),
                                                                                c("Values"))) %>%
    as.data.frame() %>%
    rownames_to_column("Fraction")



  gg_output <- ggplot(output_mat, aes(x="", y=Values, fill=Fraction))+
    geom_bar(stat = "identity")+
    coord_polar("y", start=0)+
    scale_fill_brewer("Blues") +
    theme(axis.text.x=element_blank())+
    geom_text(aes(y = Values/2 + c(0, cumsum(Values)[-length(Values)]),
                  label = percent(Values/100)), size=5)+
    theme_minimal()+
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      panel.border = element_blank(),
      panel.grid=element_blank(),
      axis.ticks = element_blank(),
      plot.title=element_text(size=14, face="bold")
    )

  return(gg_output)

  }


#superhost_rate("Norrmalm")
