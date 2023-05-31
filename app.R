library(shiny)

source("police.r")

about <- tabPanel("About",
                  h1("About this project")
)
compare <- tabPanel("Overview", 
                    h1("How police violence incidents have changed over time")
)
relation <- tabPanel("Police training and incidents", 
                     h1("Exploring the state of New Mexico")
)
factors <- tabPanel("Possible remedies",
                    h1("Analyzing the state of Maine")
)

ui <- navbarPage("An analysis of police violence and training",
                 about,
                 compare,
                 relation,
                 factors
)

server <- function(input, output) {
  
  
}

shinyApp(ui = ui, server = server)
