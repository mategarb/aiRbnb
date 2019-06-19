library(shinydashboard)
library(geojsonR)
library(shiny)
library(geojsonio)
library(dashboardthemes)
library(shinyWidgets)
library(leaflet)
library(geojsonR)
require(tidyverse)
source("generate_map.R")
source("sumarize_data.R")

nycounties <- geojson_read("../data/neighbourhoods.geojson",
                           what = "sp")
data <- read.csv('../data/listings_Stockholm.csv')

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
      choices = c('price', 'review_scores_value', 'square_feet'),
      options = list(
        `live-search` = TRUE)),
      leafletOutput("map") )),

    fluidRow(
      box(width=12,
        title = "Word Cloud",
        pickerInput(
          inputId = "WordCloud",
          label = "Type of information",
          choices = c('Whole City',as.character(nycounties$neighbourhood)),
          options = list(
            `live-search` = TRUE)
        )

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

}

shinyApp(ui, server)
