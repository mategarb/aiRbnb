#### WILCOX-TEST FOR COMPARISON ####

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
  ttest_list <- list(group1_=remove_outs(group1), group2_=remove_outs(group2))
  names(ttest_list) <- c(paste0(district1, "_"), paste0(district2,"_"))

  df <- ttest_list %>%
    unlist() %>% as.data.frame() %>%
    rownames_to_column("group") %>% separate(group, into=c("Group", "Number"), sep="_") %>% select(-Number) %>%
    `colnames<-`(c("Group", "Price"))


  q <- ggboxplot(df, x= "Group", y= "Price")

  options(scipen = 1)
  options(digits = 2)


  my_comparisons <- list( c(paste0(district1), paste0(district2)) )

  output_plot <- q +
    stat_compare_means(comparisons = my_comparisons,  label="p.signif",
                       palette =c("#00AFBB", "#E7B800"))+
    stat_compare_means(label.y = 2500)+
    theme(axis.title.x = element_blank())



  return(output_plot)

}

