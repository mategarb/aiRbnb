library(tidyverse)
library(udpipe)
library(wordcloud)

data <- readRDS("/Users/mateuszgarbulowski/Desktop/aiRbnb_data/data/stockholm.rds")
district <- data$neighbourhood[2]

info <- "house_rules"
info_1 <- c("description", "host_about", "summary", "name", "space", "interaction", "house_rules")
info_2 <- c("amenities", "property_type", "host_verifications", "host_name")

part_of_spech <- c("adjective", "noun", "verb", "adverb")

### EXAMPLES
wordCloudBnb("Södermalm", data, "house_rules", "adjective", "english", top=10)
wordCloudBnb("Norrmalm", data, "house_rules", "adjective", "english", top=10)
wordCloudBnb("Östermalm", data, "house_rules", "adjective", "english", top=10)
wordCloudBnb("all", data, "house_rules", "adjective", "english", top=10)

wordCloudBnb("Södermalm", data, "description", "noun", "english", top=5)
wordCloudBnb("Norrmalm", data, "description", "noun", "english", top=5)
wordCloudBnb("Östermalm", data, "description", "noun", "english", top=5)
wordCloudBnb("all", data, "description", "noun", "english", top=5)

wordCloudBnb("Södermalm", data, "amenities") # no need to set other parameters
wordCloudBnb("Norrmalm", data, "amenities")
wordCloudBnb("Östermalm", data, "amenities")

wordCloudBnb("Södermalm", data, "host_verifications") # no need to set other parameters
wordCloudBnb("Norrmalm", data, "host_verifications")
wordCloudBnb("Skärholmen", data, "host_verifications")
wordCloudBnb("all", data, "host_verifications")


