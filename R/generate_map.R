generate_map <- function(district, nycounties, parameter, data){

  parameter2 <- gsub('Price [SEK]', 'price', parameter, fixed = TRUE)
  parameter2 <- gsub('Rating', 'review_scores_value', parameter2, fixed = TRUE)
  parameter2 <- gsub('Bedrooms', 'bedrooms', parameter2, fixed = TRUE)
  nycounties$neighbourhood <- c("Kungsholmen", "Östermalm","Bromma","Skärholmen","Södermalm",
                                "Hägersten-Liljeholmen", "Norrmalm", "Farsta", "Hässelby-Vällingby","Skarpnäck",
                                "Spånga-Tensta", "Älvsjö", "Enskede-Årsta-Vantör", "Rinkeby-Kista")

  if(district == 'Whole City'){

    data_summary <- sumarize_data(data, parameter2, district)

    data_summary <- data_summary[match(nycounties$neighbourhood,data_summary$neighbourhood),]


    pal <- colorBin("YlOrRd", domain = data_summary$mean_val, bins =  5)

    labels <- sprintf(
      "<strong>%s</strong><br/> %s: %g<sup></sup>",
      as.character(data_summary$neighbourhood),parameter, data_summary$mean_val) %>%
      lapply(htmltools::HTML)


    p <- leaflet(nycounties) %>%
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
      addLegend(pal = pal, values = ~data_summary$mean_val, opacity = 0.7, title = parameter,
                position = "bottomright")
    return(p)

  # }else{
  #   district <- 'Södermalm'
  #   data <- data %>% filter(neighbourhood==district)
  #   data_summary <- sumarize_data(data, parameter2, district)
  #
  #  ind_neighbourhood = which( nycounties$neighbourhood == district)
  #  icons <- awesomeIcons(
  #    icon = 'ios-close',
  #    iconColor = 'black',
  #    library = 'ion'
  #  )
  #
  #  leaflet(data) %>% addTiles() %>%
  #    addAwesomeMarkers(~longitude, ~latitude, icon = icons)
   }
}

