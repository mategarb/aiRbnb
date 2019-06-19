generate_map <- function(neighbourhoods, nycounties, parameter, data){
  if(neighbourhoods == 'Whole City'){

    data_summary <- sumarize_data(data, parameter, neighbourhood)


  #  data_summary$neighbourhood <- as.character(data_summary$neighbourhood)
   # data_summary <- data_summary[,match(nycounties$neighbourhood,data_summary$neighbourhood)]


    pal <- colorBin("YlOrRd", domain = data_summary$mean_val, bins =  length(data_summary$neighbourhood))
    labels <- sprintf(
      "<strong>%s</strong><br/> %s: %g<sup></sup>",
      as.character(data_summary$neighbourhood),parameter, data_summary$mean_val
    ) %>% lapply(htmltools::HTML)


    p<- leaflet(nycounties) %>%
      addTiles() %>% addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(
        fillColor = ~pal(data_summary$mean_val),
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
      addLegend(pal = pal, values = ~data_summary$mean_val, opacity = 0.7, title = NULL,
                position = "bottomright")
    return(p)

  }
}

