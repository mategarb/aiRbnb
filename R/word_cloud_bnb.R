word_cloud_bnb <- function(district, data, info, part_of_speech="adjective", language="english", top_words=10) {
info_1 <- c("description", "host_about", "summary", "name", "space", "interaction", "house_rules")
info_2 <- c("amenities", "property_type", "host_verifications", "host_name")

if(any(str_detect(info_1, info))) {

  if(district != "Whole City") {
    data <- data %>% filter(neighbourhood==district)
  }
  info <- "description"
  words <- data %>% .[[info]] %>% enframe %>%
    mutate(value=strsplit(value,"[[:space:]]|(?=[.!?])", perl=TRUE))

  words_apart <- words$value %>%
    unlist %>%
    enframe %>%
    mutate(value=str_to_lower(value)) %>%
    mutate(value=gsub(",","",value)) %>%
    mutate(value=gsub("\\(","",value)) %>%
    mutate(value=gsub("\\)","",value)) %>%
    mutate(value=gsub(";","",value)) %>%
    mutate(value=gsub(":","",value)) %>%
    mutate(value=gsub("\\w*[0-9]+\\w*\\s*","",value)) %>%
    mutate(value=gsub("[^a-zA-Z]", "", value)) %>%
    filter(value!=".") %>%
    filter(value!=" ") %>%
    filter(value!="") %>%
    mutate(value=as.character(value))

  # elect language and part of speech
  ud_model <- udpipe_download_model(language = c("english"))
  ud_model <- udpipe_load_model(ud_model$file_model)
  x <- udpipe_annotate(ud_model, x = unique(words_apart$value))
  x <- as.data.frame(x)

  if(part_of_speech=="adjective"){
    words_subset <- subset(x, upos %in% "ADJ")
  }
  if(part_of_speech=="verb"){
    words_subset <- subset(x, upos %in% "VERB")
  }
  if(part_of_speech=="adverb"){
    words_subset <- subset(x, upos %in% "ADV")
  }
  if(part_of_speech=="noun"){
    words_subset <- subset(x, upos %in% "NOUN")
  }

  words_curr <- words_subset$sentence

  words_inp_word <- words_apart$value[which(match(words_apart$value, words_curr)>=1)] %>% table %>% names
  words_inp_freq <- words_apart$value[which(match(words_apart$value, words_curr)>=1)] %>% table %>% unname
  words_inp <- data.frame(words_inp_word, words_inp_freq)


}

if(any(str_detect(info_2, info))) {

  words <- data %>% .[[info]] %>% str_split(",") %>%
    unlist %>% enframe %>%
    mutate(value=gsub("[^a-zA-Z]", " ", value)) %>%
    mutate(value=parse_character(value)) %>%
    mutate(value=str_to_lower(value))

  words_inp_word <- words$value %>% table %>% names
  words_inp_freq <- words$value %>% table %>% unname
  words_inp <- data.frame(words_inp_word, words_inp_freq)

}


colfunc <- colorRampPalette(c("darkorchid1","firebrick1", "chartreuse", "deepskyblue", "gold"))
cols <- colfunc(length(words_inp$freq))
words_inp <- words_inp[,-2]

colnames(words_inp) <- c("word", "freq")
wordcloud2(words_inp, color=cols)

}
