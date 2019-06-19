library(tidyverse)
library(udpipe)
library(wordcloud2)
source("R/word_cloud_bnb.R")

require(devtools)
install_github("lchiffon/wordcloud2")

data <- readRDS("/Users/mateuszgarbulowski/Desktop/RaukR_project/aiRbnb_data/data/stockholm.rds")
district <- data$neighbourhood[2]
info_1 <- c("description", "host_about", "summary", "name", "space", "interaction", "house_rules")

info <- "house_rules"
info_1 <- c("description", "host_about", "summary", "name", "space", "interaction", "house_rules")
info_2 <- c("amenities", "property_type", "host_verifications", "host_name")

part_of_speech <- c("adjective", "noun", "verb", "adverb")[1]

### EXAMPLES
word_cloud_bnb("Södermalm", data, "house_rules", "adjective", "english", top=50)
word_cloud_bnb("Norrmalm", data, "house_rules", "adjective", "english", top=10)
word_cloud_bnb("Östermalm", data, "house_rules", "adjective", "english", top=10)
word_cloud_bnb("Whole City", data, "house_rules", "adjective", "english", top=20)

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


