library(leaflet)
library(geojsonR)

nycounties <- geojson_read("/Users/karsm933/Downloads/neighbourhoods.geojson",
                           what = "sp")
data <- read.csv('/Users/karsm933/Downloads/listings.csv')


x = sample(1:7, 14,replace = TRUE)
bins <- seq(1:7)
pal <- colorBin("YlOrRd", domain = x, bins = bins)
labels <- sprintf(
  "<strong>%s</strong><br/> rate: %g<sup></sup>",
  as.character(nycounties$neighbourhood), x
) %>% lapply(htmltools::HTML)


leaflet(nycounties) %>%
  addTiles() %>% addProviderTiles(providers$Stamen.TonerLite) %>%
  addPolygons(
  fillColor = ~pal(x),
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
  addLegend(pal = pal, values = ~x, opacity = 0.7, title = NULL,
            position = "bottomright")
