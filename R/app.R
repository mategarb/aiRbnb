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
      choices = c('Whole City',as.character(nycounties$neighbourhood)),
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
      box(width=6,
        title = "Word Cloud",
        pickerInput(
          inputId = "WordCloud",
          label = "Type of information",
          choices = c("description", "host_about", "summary", "name", "space", "interaction", "house_rules",
                      "amenities", "property_type", "host_verifications", "host_name"),
          options = list(
            `live-search` = TRUE)
        ),
        wordcloud2Output("World_Cloud2"),
        wordcloud2Output("word_cloud")
        )
  ),

  fluidRow(
    box(width=12,
        title = "Summary",
        pickerInput(
          inputId = "summary",
          label = "Type of information",
          choices = c('Whole City',as.character(nycounties$neighbourhood)),
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

  output$World_Cloud2 <- renderWordcloud2({
    word_cloud_bnb(district = "Whole City", data, input$WordCloud, part_of_speech="adjective", language="english", top_words=30)
  })
  output$word_cloud = renderWordcloud2({
    wordcloud2(demoFreq)
  })

}

shinyApp(ui, server)
