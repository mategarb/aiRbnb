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
library(ggplot2)
library(scales)
library(ggpubr)
source("generate_map.R")
source("sumarize_data.R")
source("word_cloud_bnb.R")
source("histogram_function.R")
source("superhost_fraction.R")
source("wilcox_test.R")
source("remove_outs.R")

nycounties <- geojson_read("../data/neighbourhoods.geojson",
                           what = "sp")
valfn <- function(x, y) if(x == y) return("Select another neighbourhood!")

data <- readRDS('../data/Stockholm.rds')

ui <- dashboardPage(
  dashboardHeader(title = "aiRbnb"),
  dashboardSidebar(
    h3('Stockholm'),
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
  fluidRow(  valueBoxOutput("vbox"),
             infoBoxOutput("bed"),
             valueBoxOutput("rate")),

    fluidRow(

      box(width=12,solidHeader = TRUE,status = 'primary', collapsible = TRUE, background = NULL,
          title = "Overview",
      pickerInput(
      inputId = "MapParam",
      label = "Select neighbourhood",
      choices = c('Price [SEK]' , 'Rating',  'Bedrooms'),
      options = list(
        `live-search` = TRUE)),
      leafletOutput("map") )),

    fluidRow(
      box(width=8, height =540 , solidHeader = TRUE,status = 'primary', collapsible = TRUE, background = NULL,
        title = "Word Cloud",
        column(3, pickerInput(
          inputId = "WordCloud",
          label = "Type of information",
          choices = c("description", "host_about", "summary", "name", "space", "interaction", "house_rules",
                      "amenities", "property_type", "host_verifications", "host_name"),
          options = list(
            `live-search` = TRUE)
        ),
        pickerInput(
          inputId = "PartOfSpeech",
          label = "Part of speech",
          choices = c('adjective', 'noun', 'verb', 'adverb'),
          options = list(
            `live-search` = TRUE)),
        sliderInput("slider_wc", label = 'Number of words', min = 1,
                    max = 100, value = 10)),
        column(9,
        wordcloud2Output("world_cloud"))

        ),
      box(width=4, solidHeader = TRUE,status = 'primary', collapsible = TRUE,
          title = "Neighbourhoods comparison",
          pickerInput(
            inputId = "InNeigh2",
            label = "Select neighbourhood",
            choices = c(as.character(unique(data$neighbourhood))),
            options = list(
              `live-search` = TRUE)
          ),
          plotOutput("plot_district_ttest"))
  ),

  fluidRow(
    box(width=6, solidHeader = TRUE,status = 'primary', collapsible = TRUE,
        title = "Price per the room type",
        plotOutput("histogram1")),

    box(width=6, solidHeader = TRUE,status = 'primary', collapsible = TRUE,
        title = "Superhost fraction",
       plotOutput("plot_superhost_frac")

    )
  )


))

server <- function(input, output) {


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

  output$histogram1<- renderPlot({
    histogram_function(input$InNeigh, data)
  })

  output$plot_superhost_frac<- renderPlot({
    superhost_frac(input$InNeigh, data)
  })

  output$plot_district_ttest<- renderPlot({
    shiny::validate(
      need(input$InNeigh != input$InNeigh2, "Select another neighbourhood!"))
    #validate(valfn(try(input$InNeigh, input$InNeigh2)))
    district_ttest(input$InNeigh, input$InNeigh2, data)
  })

  summary_data_price <- reactive({
    sumarize_data(data, 'price', input$InNeigh) %>% .$mean_val %>% mean
  })

  summary_data_size <- reactive({
    sumarize_data(data, 'bedrooms', input$InNeigh) %>% .$mean_val %>% mean
  })

  summary_data_rate <- reactive({
    sumarize_data(data, 'review_scores_value', input$InNeigh) %>% .$mean_val %>% mean
  })



  output$vbox <- renderValueBox({
    valueBox(
      paste0(round(summary_data_price(),2), ' SEK'),
      paste0("The average price for Stockholm"),
      icon = icon("dollar"), color = "purple"
    )
  })

  output$bed <- renderValueBox({
    valueBox(
      paste0(round(summary_data_size(),2)),
      paste0("The average number of bedrooms for Stockholm"),
      icon = icon("bed"), color = "yellow"
    )
  })


  output$rate <- renderValueBox({
    valueBox(
      paste0(round(summary_data_rate(),2), '/10'),
      paste0("The average rating  for Stockholm"),
      icon = icon("thumbs-up"), color = "maroon"
    )
  })
}

shinyApp(ui, server)
