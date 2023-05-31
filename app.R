library(shiny)

source("police.r")

ui <- fluidPage(
  titlePanel("Police")
  
)

server <- function(input, output) {
  
  
}

shinyApp(ui = ui, server = server)
