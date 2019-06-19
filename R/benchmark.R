devtools::install_github("eddelbuettel/rbenchmark")
library(rbenchmark)

data <- readRDS("/Users/mateuszgarbulowski/Desktop/RaukR_project/aiRbnb_data/data/stockholm.rds")
data$price <- data$price %>% parse_number

district <- "Whole City"
district1 <- "Norrmalm"

info <- "description"
part_of_speech <- c("adjective", "noun", "verb", "adverb")[1]

out_b <- benchmark("before" = {

    out1 <- word_cloud_bnb_before(district, data, info, part_of_speech="adjective", language="english")
},
"after" = {
  out1 <- word_cloud_bnb_after(district, data, info, part_of_speech="adjective", language="english")
},
replications = 2,
columns = c("test", "replications", "elapsed",
            "relative", "user.self", "sys.self"))

nycounties <- geojson_read("data/neighbourhoods.geojson",
                           what = "sp")



out_2 <- benchmark("remove_outs" = {

  out1 <- remove_outs(data$price, q_min = "10%", q_max = "90%")},
"generate_map" = {
  out1 <- generate_map(district, nycounties, 'Price [SEK]', data)
    },
"wilcox_test" = {
  out1 <- district_ttest(district, district1, data)
},
replications = 2,
columns = c("test", "replications", "elapsed",
            "relative", "user.self", "sys.self"))
