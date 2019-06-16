library(leaflet)
library(geojsonR)

nycounties <- geojson_read("/Users/karsm933/Downloads/neighbourhoods.geojson",
                           what = "sp")
d = palette(rainbow(14))

leaflet(nycounties) %>%
  addTiles() %>% addProviderTiles(providers$Stamen.TonerLite) %>%
  addPolygons(fillColor = d, stroke = FALSE)
