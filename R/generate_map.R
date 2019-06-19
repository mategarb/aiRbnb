generate_map <- function(district, nycounties, parameter, data){

  parameter2 <- gsub('Price [SEK]', 'price', parameter, fixed = TRUE)
  parameter2 <- gsub('Score', 'review_scores_value', parameter2, fixed = TRUE)
  parameter2 <- gsub('Size [m2]', 'square_feet', parameter2, fixed = TRUE)


  if(district == 'Whole City'){

    data_summary <- sumarize_data(data, parameter2, district)


  #  data_summary$neighbourhood <- as.character(data_summary$neighbourhood)
   # data_summary <- data_summary[,match(nycounties$neighbourhood,data_summary$neighbourhood)]

    pal <- colorBin("YlOrRd", domain = data_summary$median_val, bins =  length(data_summary$neighbourhood))
    labels <- sprintf(
      "<strong>%s</strong><br/> %s: %g<sup></sup>",
      as.character(data_summary$neighbourhood),parameter, data_summary$median_val
    ) %>% lapply(htmltools::HTML)


    p<- leaflet(nycounties) %>%
      addTiles() %>% addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(
        fillColor = ~pal(data_summary$median_val),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto")) %>%
      addLegend(pal = pal, values = ~data_summary$median_val, opacity = 0.7, title = parameter,
                position = "bottomright")
    return(p)

  }else{
    district <- 'Södermalm'
    data <- data %>% filter(neighbourhood==district)
    data_summary <- sumarize_data(data, parameter2, district)


  }
}

