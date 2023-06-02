library(shiny)
library(plotly)

source("police.r")

# controls <- sidebarPanel(
#   h1("Control Panel"),
#   selectInput(
#     inputId = "state_name",
#     label = "Select a State",
#     choices = agg_df$state
#   )
# )

note_map_1 <- sidebarPanel(
  wellPanel(
    p("")
  )
)

note_map_2 <- sidebarPanel(
  wellPanel(
    p("")
  )
)
map_view <- tabPanel("Map", plotlyOutput(outputId = "map_2013"), plotlyOutput(outputId = "map_2018"))
 controls <- sidebarPanel(
     h1("Control Panel"),
     selectInput(
       inputId = "state_name",
       label = "Select a State",
       choices = agg_df$state
     )
 )
 table_view <- tabPanel("Table", controls, tableOutput(outputId = "df_res_3"), tableOutput(outputId = "df_res_8"))


about <- tabPanel("About",
                  h1("About this project"),
                  sidebarLayout(
                    note_map_1,
                    mainPanel(
                      tabsetPanel(
                    map_view,
                    table_view
                      )
                    )
                  ),
                  # sidebarLayout(
                  #   note_map_2,
                  #   mainPanel(
                  #     plotlyOutput("map_2018")
                  #   )
                  # )
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

note_bar_1 <- sidebarPanel(
  wellPanel(
    p("")
  )
)

note_scatter_1 <- sidebarPanel(
  wellPanel(
    p("")
  )
)

note_scatter_2 <- sidebarPanel(
  wellPanel(
    p("")
  )
)

note_bar_2 <- sidebarPanel(
  wellPanel(
    p("")
  )
)

note_bar_3 <- sidebarPanel(
  wellPanel(
    p("")
  )
)

note_box_1 <- sidebarPanel(
  wellPanel(
    p("")
  )
)

note_box_2 <- sidebarPanel(
  wellPanel(
    p("")
  )
)

note_bar_4 <- sidebarPanel(
  wellPanel(
    p("")
  )
)

note_bar_5 <- sidebarPanel(
  wellPanel(
    p("")
  )
)

note_bar_6 <- sidebarPanel(
  wellPanel(
    p("")
  )
)

note_bar_7 <- sidebarPanel(
  wellPanel(
    p("")
  )
)

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
                         plotlyOutput("lineplot_roc"),
                     p("On the contrary, the Mid-Atlantic is the region with the greatest percentage decrease in incidents (28 percent points), with all states experiencing a decrease in incidents, the lowest being Pennsylvania and Virginia 2 percent points, and the highest being Delaware 50 percent points."),
                         plotlyOutput("lineplot_mid"),
                    
                    )
)


relation <- tabPanel("Police training and incidents", 
                     fluidPage(
                     h1("Exploring the state of New Mexico"),
                     p("New Mexico is the state with the highest number of police brutality incidents per million in the nation (59)."),
                         plotlyOutput("barplot_us"),
                     p("As shown in the previous section, the region of the South West is ranked first among the regions with respect to average number of incidents per million. This might suggest a possible relation between police training and police brutlity incidents. Therefore, it is reasonable to examine the average total duration of training across different states and the number of incidents occured."),
                     p("This plot comparing the number of incidents per million and the number of hours of training in the 2013-2017 period does not suggest much of a relationship between both factors"),
                     sidebarLayout(
                       sidebarPanel(
                         h3("Controls"),
                         sliderInput(
                           inputId = "inc_per",
                           label = "Filter by number of incidents per million per state",
                           min = 0,
                           max = 60,
                           value = 60
                         )
                         ), 
                       mainPanel(
                         plotlyOutput("scatter_2013")
                       )
                     ),
                     p("However, the period of 2018-2022 suggests a more linear relationship between the factors: number of police brutality incidents decreasing as total training hours increases (albeit moderate)."),
                     sidebarLayout(
                       sidebarPanel(
                         h3("Controls"),
                         sliderInput(
                           inputId = "inc_per_1",
                           label = "Filter by number of incidents per million per state",
                           min = 0,
                           max = 60,
                           value = 60
                         )
                       ), 
                       mainPanel(
                         plotlyOutput("scatter_2018")
                       )
                     ),
                     p("Perhaps this could be attributed to changes in the total duration of training between both periods. It might be worth considering how this has changed for every state in this period of time. It could be expected that New Mexico experienced a significant decrease in this regard following the possible negative correlation between the mentioned factors."),
                         plotlyOutput("barplot_train"),
                     p("Yet analysis proves inconsequential, as New Mexico barely experienced any changes in training duration (save for an 1.4 hour drop). We might get a clearer picture if we zoomed out to the regional level."),
                         plotlyOutput("barplot_train_reg"),
                     p("This seems strange, as it turns out that the South West is the second region with the most increase in total training, averaging 84 hours. Simply increasing the duration of training might not be a significant solution to the problem of police brutality as it does not seem applicable to regional/state levels, so it might be worth considering how other factors of police training mey have affected this phenomenon in a particular state.")
                     )
)

factors <- tabPanel("Possible remedies",
                    fluidPage(
                    h1("Analyzing the state of Maine"),
                    p("In the 2013-2022 period, the only state that was an outlier (with police incidents significantly higher than those of other states in its region) regarding police incidents per million within all regions was Maine. However, for the 2018-2022 period it dropped significantly by 15% and stopped being an outlier within the Mid-Atlantic region, even falling to the lower quartiles."),
                        plotlyOutput("boxplot_2013"),
                        plotlyOutput("boxplot_2018"), 
                    p("It could be interesting to examine how police training in the state of Maine changed between periods, as it became the eighth state with the highest decrease in police brutality incidents per million in the nation (dropping 15 percentage points)."),
                        plotlyOutput("barchart_inc_change"),
                    p("Police training in the state of Maine has experienced a notable change in the levels of stress that recruits are subject to (higher stress meaning that training is of military type as opposed to academic), becoming the eight state in the nation with the greatest decrease."),
                        plotlyOutput("barchart_stress"),
                    p("It also has seen a significant increase in the number of hours of training dedicated to stress management at the personal level, ranking second in the nation as it saw a 10 hour average increase."),
                        plotlyOutput("barchart_man"),
                    p("And finally, the state has moved on from no academies offering training in identification and response to excessive use of force by other officers to all academies doing it, becoming the state with the greatest increase in this aspect."),
                        plotlyOutput("barchart_exc"),
                    p("These changes suggest that a decrease in the stress levels experienced by recruits in their academies, added to an increase in training related to stress management skills at the personal level, and increased training in identification and response to excessive use of force by other officers could potentially be associated with a decrease in incidents of police brutality, and as such, may represent potential remedies for the problem.")
                    )
                  )

ui <- navbarPage("An analysis of police violence and training",
                 about,
                 compare,
                 relation,
                 factors
)

server <- function(input, output) {
  output$df_res_3 <- renderTable({
    state_info <- select(agg_df, state, incidents_2013, Population_2017, incidents_2013_per_1000000)
    state_info <- state_info[state_info$state == input$state_name, ]
    return(state_info)
  })
  output$df_res_8 <- renderTable({
    state_info_1 <- select(agg_df, state, incidents_2018, Population_2022, incidents_2018_per_1000000)
    state_info_1 <- state_info_1[state_info_1$state == input$state_name, ]
    return(state_info_1)
  })
  output$lineplot_reg <- renderPlotly({
    line1 <- ggplot(data = incidents_region_change_df, aes(x = Year, y = incidents_region)) +
    geom_line(aes(col = Region)) +
    labs(y = "Average incidents (per million)", col = "Region")
    line1_p <- ggplotly(line1, tootltip = "text")
    return(line1_p)
  })
  
  output$lineplot_roc <- renderPlotly({
    line2 <- ggplot(data = rockies_df, aes(x = Year, y = incidents_per_1000000)) +
      geom_line(aes(col = state)) +
      labs(y = "Average incidents (per million)", col = "State")
    line2_p <- ggplotly(line2, tootltip = "text")
    return(line2_p)
  })
  
  output$lineplot_mid <- renderPlotly({
    line3 <- ggplot(data = mid_atl_df, aes(x = Year, y = incidents_per_1000000)) +
      geom_line(aes(col = state)) +
      labs(y = "Average incidents (per million)", col = "State")
    line3_p <- ggplotly(line3, tootltip = "text")
    return(line3_p)
  })
  
  output$barplot_us <- renderPlotly({
    bar_1 <- ggplot(data = agg_df, aes(x = incidents_2018_per_1000000, y = reorder(state, incidents_2018_per_1000000), text = paste(
      "Incidents:", round(incidents_2018_per_1000000, 1))))+
      geom_bar(stat = 'identity') +
      labs(x = "Total incidents per million (2018-2022)", y = "State")
    bar_1p <- ggplotly(bar_1, tooltip = "text")
    return(bar_1p)
  })
  
  output$scatter_2013 <- renderPlotly({
    filt_df <- agg_df[agg_df$incidents_2013_per_1000000 <= input$inc_per, ]
    scatter_1 <- ggplot(data = filt_df, aes(x = (median_training_2013), y = incidents_2013_per_1000000, text = paste(
      paste("State:", state),
      paste("Incidents", round(incidents_2013_per_1000000, 1)),
      paste("Training duration", round(median_training_2013, 1), "h"), sep = "\n"))) +
      geom_point(aes(col = Region)) +
      labs(x = "Training duration (in hours)", y = "Incidents per million (2013-2017)")
      scatter_1p <- ggplotly(scatter_1, tooltip = "text")
      return(scatter_1p)
  })
  
  output$scatter_2018 <- renderPlotly({
    filt_df_1 <- agg_df[agg_df$incidents_2018_per_1000000 <= input$inc_per_1, ]
    scatter_2 <- ggplot(data = filt_df_1, aes(x = (mean_training_2018), y = incidents_2018_per_1000000, text = paste(
      paste("State:", state),
      paste("Incidents", round(incidents_2018_per_1000000, 1)),
      paste("Training duration", round(mean_training_2018, 1), "h"), sep = "\n"))) +
      geom_point(aes(col = Region)) + 
      labs(x = "Training duration (in hours)", y = "Incidents per million (2018-2022)") 
      scatter_2p <- ggplotly(scatter_2, tooltip = "text")
      return(scatter_2p)
  })
  
  output$barplot_train <- renderPlotly({
    bar_2 <- ggplot(data = agg_df, aes(x = mean_training_2018 - median_training_2013, y = reorder(state, mean_training_2018 - median_training_2013), text = paste(
      "Duration change:", round(mean_training_2018 - median_training_2013, 1))))+
      geom_bar(stat = 'identity') +
      labs(x = "Change of total duration of training (in hours)", y = "State")
    bar_2p <- ggplotly(bar_2, tooltip = "text")    
    return(bar_2p)
  })
  
  output$barplot_train_reg <- renderPlotly({
    bar_3 <- ggplot(data = train_reg, aes(x = mean_training, y = reorder(Region, mean_training), text = paste(
      "Duration change:", round(mean_training, 1))))+
      geom_bar(stat = 'identity') +
      labs(x = "Change in total duration of training (in hours)", y = "Region")
    bar_3p <- ggplotly(bar_3, tooltip = "text")
    return(bar_3p)
  })
  
  output$boxplot_2013 <- renderPlotly({
    box_1 <- ggplot(data = agg_df, aes(x = Region, y = incidents_2013_per_1000000)) +
      geom_boxplot() + 
      labs(y = "Incidents per million (2013-2017)")
      return(box_1)
  })
  
  output$boxplot_2018 <- renderPlotly({
    box_2 <- ggplot(data = agg_df, aes(x = Region, y = incidents_2018_per_1000000)) +
      geom_boxplot() +
      labs(y = "Incidents per million (2018-2022)")
    return(box_2)
  })
  
  output$barchart_inc_change <- renderPlotly({
    bar_4 <- ggplot(data = change_incidents_us_df, aes(x = change, y = reorder(states_vec, change), text = paste(
      "Percent change:", round(change, 1)))) +
      geom_bar(stat = 'identity') +
      labs(x = "Percent change in incidents per million (2013-2017 - 2018-2022)", y = "State")
    bar_4p <- ggplotly(bar_4, tooltip = "text")
    return(bar_4p)
  })
  
  output$barchart_stress <- renderPlotly({
    bar_5 <- ggplot(data = agg_df, aes(x = mean_stress_2018 - mean_stress_2013, y = reorder(state, mean_stress_2018 - mean_stress_2013), text = paste(
      "Change:", round(mean_stress_2018 - mean_stress_2013, 1))))+
      geom_bar(stat = 'identity') + 
      labs(x = "Change in stress levels experienced by recruits in training (1-5 scale)", y = "state")
    bar_5p <- ggplotly(bar_5, tooltip = "text")
    return(bar_5p)
  })
  
  output$barchart_man <- renderPlotly({
    bar_6 <- ggplot(data = agg_df, aes(x = median_stress_man_2018 - median_stress_man_2013, y = reorder(state, median_stress_man_2018 - median_stress_man_2013), text = paste(
      "Change:", round(median_stress_man_2018 - median_stress_man_2013, 1)))) +
      geom_bar(stat = 'identity') +
      labs(x = "Change in training dedicated to stress management skills (in hours)", y = "state")
    bar_6p <- ggplotly(bar_6, tooltip = "text")  
    return(bar_6p)
  })
  
  output$barchart_exc <- renderPlotly({
    bar_7 <- ggplot(data = agg_df, aes(x = mean_force_id_2018 - mean_force_id_2013, y = reorder(state, mean_force_id_2018), text = paste(
      "Duration change:", round(mean_force_id_2018 - mean_force_id_2013, 1)))) +
      geom_bar(stat = 'identity') +
      labs(x = "Change in proportion of academies that offer training in identification of excessive use of force", y = "State")
      bar_7p <- ggplotly(bar_7, tooltip = "text")
    return(bar_7p)
  })
  output$map_2013 <- renderPlotly({
    us_2013 <- plot_usmap(data = agg_2013, values = "Incidents") + 
      scale_fill_continuous(low = "white", high = "blue", name = "Incidents per million (2013)", label = scales::comma, limits = c(0, 60)) + 
      theme(legend.position = "right") 
      #geom_text(aes(label = State, hjust = -0.1, vjust = -0.3))
    
    
    
    # us_2013 <- plot_usmap(data = agg_tibble,
    #            values = "incidents_2013_per_1000000",
    #            labels = FALSE) #+
    #             geom_text(aes(label = State, hjust = -0.1, vjust = -0.3)) 
     return(us_2013)
  })
  
  output$map_2018 <- renderPlotly({
    us_2018 <- plot_usmap(data = agg_2018, values = "Incidents") + 
      scale_fill_continuous(low = "white", high = "blue", name = "Incidents per million (2018)", label = scales::comma, limits = c(0, 60)) + 
      theme(legend.position = "right") 
    return(us_2018)
  })

}
shinyApp(ui = ui, server = server)
