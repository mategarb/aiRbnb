install.packages("geojsonio")
install.packages("leaflet")
require(geojsonio)
require(leaflet)
require(tidyverse)

dat <- read.csv("data/listings_Stockholm.csv")

setwd("figures")
pdf("plots.pdf", width=8, height = 6)
districts <- unique(dat$neighbourhood)
for (i in 1:length(districts)) {
  a <- dat[dat$neighbourhood== districts[i],]

  #pdf(paste0("price_per_room", districts[i], ".pdf"), width=10, height = 8)
  p <- ggplot(a, aes(x = as.numeric(price))) +
  geom_histogram(aes(color = room_type, fill = room_type),
                 position = "identity", bins = 50, alpha = 0.35) +
  scale_color_manual(values = c("#FFE529", "#E486B7","#449B76" )) +
  scale_fill_manual(values = c("#FFE529", "#E486B7","#449B76")) +
  scale_x_continuous(limits = c(0, 6000), breaks = seq(0, 6000, 1000)) +
    ggtitle(paste0("Price in ", districts[i]))
print(p)
}
dev.off()



