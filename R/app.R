library(shinydashboard)
library(geojsonR)
library(shiny)
library(geojsonio)
library(dashboardthemes)
library(shinyWidgets)
library(leaflet)
library(geojsonR)
require(tidyverse)
library(udpipe)
library(wordcloud)
source("generate_map.R")
source("sumarize_data.R")
source("word_cloud_bnb.R")

nycounties <- geojson_read("../data/neighbourhoods.geojson",
                           what = "sp")
data <- readRDS('../data/Stockholm.rds')

ui <- dashboardPage(
  dashboardHeader(title = "aiRbnb"),
  dashboardSidebar(
    pickerInput(
      inputId = "InNeigh",
      label = "Select neighbourhood",
      choices = c('Whole City',as.character(unique(data$neighbourhood))),
      options = list(
        `live-search` = TRUE)
    )
  ),
  dashboardBody(
    shinyDashboardThemes(
      theme = "purple_gradient"
    ),
    fluidRow(box(width=12,

      title = "Controls",
      pickerInput(
      inputId = "MapParam",
      label = "Select neighbourhood",
      choices = c('Price [SEK]' , 'Score',  'Size [m2]'),
      options = list(
        `live-search` = TRUE)),
      leafletOutput("map") )),

    fluidRow(
      box(width=12,
        title = "Word Cloud",
        pickerInput(
          inputId = "WordCloud",
          label = "Type of information",
          choices = c("description", "host_about", "summary", "name", "space", "interaction", "house_rules",
                      "amenities", "property_type", "host_verifications", "host_name"),
          options = list(
            `live-search` = TRUE)
        ),
        pickerInput(
          inputId = "PartOfSpeech",
          label = "Select part of speech",
          choices = c('adjective', 'noun', 'verb', 'adverb'),
          options = list(
            `live-search` = TRUE)),
        sliderInput("slider_wc", label = h3("Slider"), min = 1,
                    max = 100, value = 10),
        wordcloud2Output("world_cloud")
        )
  ),

  fluidRow(
    box(width=12,
        title = "Summary",
        pickerInput(
          inputId = "summary",
          label = "Type of information",
          choices = c('Whole City',as.character(unique(data$neighbourhood))),
          options = list(
            `live-search` = TRUE)
        )

    )
  )
))

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)

  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  output$map <- renderLeaflet({
    generate_map("Whole City", nycounties, input$MapParam, data )
  })

  out_wc <- reactive({
   word_cloud_bnb(district = input$InNeigh, data, input$WordCloud, part_of_speech=input$PartOfSpeech, language="english")
    })

  output$world_cloud <- renderWordcloud2({
    out_wc <- out_wc()
    out_tab <- out_wc$tab[order(out_wc$tab$freq, decreasing = T),][1:input$slider_wc,]

    colfunc <- colorRampPalette(c("darkorchid1","firebrick1", "chartreuse", "deepskyblue", "gold"))
    cols <- colfunc(length(out_tab$freq))
    wordcloud2(out_tab, size = 0.75, shuffle = F, color = cols)
  })

}

shinyApp(ui, server)
