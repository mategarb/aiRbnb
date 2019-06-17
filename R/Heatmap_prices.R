install.packages("geojsonio")
install.packages("leaflet")
require(geojsonio)
require(leaflet)
require(tidyverse)

dat <- read.csv("data/listings_Stockholm.csv")
nycounties <- geojson_read("data/neighbourhoods.geojson",  what = "sp")

head(dat)

###
table(dat$neighbourhood)

dat$price <- gsub("\\$", "", dat$price)
dat$price <- gsub("\\,","", dat$price)
dat$price <- gsub("\\.00", "", dat$price)


mean.dat <- dat %>%
  group_by(neighbourhood) %>%
  summarise(mean_price = round(mean(as.numeric(price)), digits=2),
            max_price=round(max(as.numeric(price)), digits=2))

##have to change names as they dont fit the one used in listings

nycounties$neighbourhood <- c("Kungsholmen", "Östermalm","Bromma","Skärholmen","Södermalm",
"Hägersten-Liljeholmen", "Norrmalm", "Farsta", "Hässelby-Vällingby","Skarpnäck",
"Spånga-Tensta", "Älvsjö", "Enskede-Årsta-Vantör", "Rinkeby-Kista")


mean.val <- mean.dat$mean_price[match(nycounties$neighbourhood,mean.dat$neighbourhood)]


d = palette(rainbow(56))

leaflet(nycounties) %>%
  addTiles()%>% addProviderTiles(providers$Stamen.TonerLite) %>%
  addPolygons(fillColor = d, stroke = FALSE)

bins <- c(500, 600, 700, 800, 900, 1000, 1050, 1100, 1150, 1200, 1300, Inf)
pal <- colorBin("YlOrRd", domain=mean.val,  bins = bins)

pdf("Mean_dayprice_neighbourhoods.pdf", width=14, height=12)
p <- leaflet(nycounties) %>%
  addTiles() %>% addProviderTiles(providers$Stamen.TonerLite) %>%
  addPolygons(
  fillColor = ~pal(mean.val),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7) %>%
  addLegend(pal = pal, values = ~mean.val, opacity = 0.7, title = NULL,
                                   position = "bottomright")
p

dev.off()





