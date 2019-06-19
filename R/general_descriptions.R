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


#### T-TEST FOR COMPARISON ####

district_ttest <- function(district1, district2){
  if(district1!="Stockholm"){
    group1<- dat_new %>%
      filter(neighbourhood==district1) %>%
      .$price
  }
  if(district1 == "Stockholm"){
    group1<- dat_new %>%
      .$price
  }
  if(district2!="Stockholm"){
    group2<- dat_new %>%
      filter(neighbourhood==district2) %>%
      .$price
  }
  if(district2=="Stockholm"){
    group2<- dat_new %>%
      .$price
  }

  #T-test
  df <- list(group1_=group1, group2_=group2)
  names(df) <- c(paste0(district1, "_"), paste0(district2,"_"))
  p_val <- round(t.test(df[[1]], df[[2]])[[3]], digits=3)
  significance <- ifelse(p_val < 0.05, "Significant difference in price ", "No significant difference in price ")
  output_text <- paste0(significance, "between ", district1, " and ", district2, " (p = ", p_val, ")")

  #Plot
  output_plot <- df %>%
    unlist() %>% as.data.frame() %>%
    rownames_to_column("group") %>% separate(group, into=c("Group", "Number"), sep="_") %>% select(-Number) %>%
    `colnames<-`(c("Group", "Price")) %>%
    ggplot()+
    geom_boxplot(aes(x=Group, y=Price))+
    labs(caption = paste0(output_text))+
    theme_bw()+
    theme(panel.grid = element_blank(),
          axis.title.x = element_blank())

  return(output_plot)

  }


district_ttest("Stockholm", "Kungsholmen")

