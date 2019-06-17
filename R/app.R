library(shinydashboard)
library(geojsonR)
library(shiny)
library(geojsonio)

nycounties <- geojson_read("../data/neighbourhoods.geojson",
                           what = "sp")

ui <- dashboardPage(
  dashboardHeader(title = "AiRbnb"),
  dashboardSidebar(
    sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                      label = "Search..."),
    selectInput("inputTest", "Select neighbourhood",
                choices = c('Whole City',as.character(nycounties$neighbourhood)), multiple=FALSE, selectize=TRUE,
                width = '98%')
  ),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      box(plotOutput("plot1", height = 250)),

      box(
        title = "Controls",
        sliderInput("slider", "Number of observations:", 1, 100, 50)
      )
    )
  ), skin = 'purple'
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)

  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

shinyApp(ui, server)
