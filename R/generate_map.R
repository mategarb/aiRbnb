generate_map <- function(neighbourhoods, nycounties, parameter, data){
  if(neighbourhoods == 'Whole City'){


    parameter.dat <- data %>% .[[parameter]] %>% as.character %>%
      parse_number %>% as.numeric

    data[[parameter]]  <- data[[parameter]] %>% as.character
    data[[parameter]] <-     parameter.dat




    mean.dat <- data %>% select(c(neighbourhood, parameter )) %>%
      group_by(neighbourhood) %>%
      summarize(mean_val = round(mean(.data[[parameter]],  na.rm = TRUE), digits=2),
                max_val = round(max(.data[[parameter]],  na.rm = TRUE), digits=2))


  #  mean.dat$neighbourhood <- as.character(mean.dat$neighbourhood)
   # mean.dat <- mean.dat[,match(nycounties$neighbourhood,mean.dat$neighbourhood)]


    pal <- colorBin("YlOrRd", domain = mean.dat$mean_val, bins =  length(mean.dat$neighbourhood))
    labels <- sprintf(
      "<strong>%s</strong><br/> %s: %g<sup></sup>",
      as.character(mean.dat$neighbourhood),parameter, mean.dat$mean_val
    ) %>% lapply(htmltools::HTML)


    p<- leaflet(nycounties) %>%
      addTiles() %>% addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(
        fillColor = ~pal(mean.dat$mean_val),
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
      addLegend(pal = pal, values = ~mean.dat$mean_val, opacity = 0.7, title = NULL,
                position = "bottomright")
    return(p)

  }
}

