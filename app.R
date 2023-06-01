library(shiny)
library(plotly)

source("police.r")

about <- tabPanel("About",
                  h1("About this project")
)

controls <- sidebarPanel(
  h1("Control Panel"),
  selectInput(
    inputId = "state_name",
    label = "Select a State",
    choices = agg_df$state
  )
)

note_line_1 <- sidebarPanel(
  wellPanel(
  h5("Note:"),
  p("This graph (and all lineplots in this page) depicts the average number of incidents per state within each region"),
  p("It does not show the number of incidents per year, but the points 2013 and 2018 instead represent the periods of 2013-2017 and 2018-2022 respectively.")
  )
)

note_line_2 <- sidebarPanel(
  wellPanel(
    p("")
  )
)

note_line_3 <- sidebarPanel(
  wellPanel(
    p("")
  )
)

table_view <- tabPanel("Table", tableOutput(outputId = "df_res"))

compare <- tabPanel("Overview",
                    fluidPage(
                     h1("How police violence incidents have changed over time"),
                     h6("Overall, there has been a 11% increase in police brutality incidents in the US from the 2013-2017 period to the 2018-2022 period. This trend is also reflected in the regional level, as almost all regions have experienced significant increases or stayed relatively the same."),
                     sidebarLayout(
                       note_line_1,
                      mainPanel(
                        plotlyOutput("lineplot_reg")
                     )
                     ),
                     p("The Rockies is the region with the most notable increase in incidents (50 percent points), with all states experiencing an increase, the lowest being Montana with 24 percent points, and the highest Wyoming with 76 percent points"),
                     sidebarLayout(
                       note_line_2,
                       mainPanel(
                         plotlyOutput("lineplot_roc")
                       )
                     ),
                     p("On the contrary, the Mid-Atlantic is the region with the greatest percentage decrease in incidents (28 percent points), with all states experiencing a decrease in incidents, the lowest being Pennsylvania and Virginia 2 percent points, and the highest being Delaware 50 percent points."),
                     sidebarLayout(
                       note_line_3,
                       mainPanel(
                         plotlyOutput("lineplot_mid")
                       )
                     ),
                    titlePanel("State"),
                     sidebarLayout(
                     controls,
                     #note_line_1,
                     mainPanel(
                               table_view
                    )
                    )
                    )
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
  output$df_res <- renderTable({
    state_info <- agg_df[agg_df$state == input$state_name, ]
    return(state_info)
  })
  output$lineplot_reg <- renderPlotly({
    line1 <- ggplot(data = incidents_region_change_df, aes(x = Year, y = round(incidents_region))) +
    geom_line(aes(col = Region)) +
    labs(y = "Average incidents (per million)", col = "Region")
  return(line1)
  })
  
  output$lineplot_roc <- renderPlotly({
    line2 <- ggplot(data = rockies_df, aes(x = Year, y = round(incidents_per_1000000))) +
      geom_line(aes(col = state)) +
      labs(y = "Average incidents (per million)", col = "State")
    return(line2)
  })
  
  output$lineplot_mid <- renderPlotly({
    line3 <- ggplot(data = mid_atl_df, aes(x = Year, y = round(incidents_per_1000000))) +
      geom_line(aes(col = state)) +
      labs(y = "Average incidents (per million)", col = "State")
    return(line3)
  })
  }

shinyApp(ui = ui, server = server)
