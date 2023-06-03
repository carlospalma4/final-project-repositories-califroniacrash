library(shiny)
library(plotly)

source("police.r")

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
                  p("Concern and anger about instances of police brutality and wrongful executions by law enforcement in the United States have grown in recent years. Numerous rallies, petitions, and demands for change have been made in response to these tragedies. The disproportionate impact of police violence on black minority communities, a pattern that has continued since the late 1900s, is one specific cause for worry. Each year, thousands of people, mostly from marginalized backgrounds, are affected as a result of these interactions, leaving their loved ones in a great deal of pain and anguish. The data’s main goal is to determine whether a significant contributing factor to the disproportionately high rate of violent interactions between law enforcement and citizens is inadequate police training."),

p("The training dataset that is used is sourced from the National Archive of Criminal Justice Data. Alongside, a dataset for every police violence case from 2013 to 2023 was found. The goal was to find a training dataset for every year from 2013 to 2022, but the Census of State and Local Law Enforcement Training Academies is only held every five years, resulting in only having 2013 and 2018. Therefore, starting from 2013, we use police violence data and correlate it with the census data taken in 2013 for the next five years up to 2018. Then, the same is done with 2018 data all the way up to 2022 to see if there is any noticeable change between those years."),

p("Our data on police violence is sourced from the Mapping Police Violence Organization. Municipal and state governments, as well as publicly available media, are used as sources. The website claims that a key resource for locating news media allegations of police abuse is Google News. Any mention of police violence between 2013 and 2023 is gathered in the dataset.  Access to the data is made possible through the website and downloaded files. The website shows a number of graphic representations to help users understand the data. The dataset contains 11,354 rows that list all fatalities from 2013 through 2023. There are also 68 columns containing details about the officer, including their name, gender, race, date of birth, street address, city, state, responsible agency, cause of death, and whether or not the officer was charged. The usage of this dataset contributes greatly to this research’s goal, to see if there is a positive correlation between police brutality and police training. In our dataset’s case we mainly used the column that showed the number of incidents."), 

p("The Census of State and Local Law Enforcement Training Academies includes two datasets, one from 2013 and one from 2018. They provide valuable insights into the required police training across different states, including the number of training hours and the specific types of training mandated for law enforcement professionals. By examining these two datasets, we hope to determine if variations in training requirements have any correlation with rates of police brutality. We aim to complement our findings by cross-referencing the data with a second set of datasets, also with an addition of analyzing the fatalities per state."),

            p("Our analysis will focus particularly on identifying specific years when significant changes occurred in police training requirements. Numbers that are shown as also by incidents per million. By examining these pivotal moments, we aim to discern the potential impact of altered training protocols on incidents of police brutality. By merging the datasets and delving into the detailed training requirements imposed by each state, we aspire to gain a deeper understanding of the underlying factors contributing to the rise in police brutality. Through our data analysis, we intend to provide a more nuanced perspective on the relationship between police training and the occurrence of such incidents."),
              h3("Explore the number of police brutality incidents per million occured in every state"),    
              sidebarLayout(
                    p(""),
                    mainPanel(
                      tabsetPanel(
                    map_view,
                    table_view
                      )
                    )
                  )
)

note_line_1 <- sidebarPanel(
  wellPanel(
  h5("Note:"),
  p("This graph (and all lineplots in this page) does not show the number of incidents per million year, but the points 2013 and 2018 instead represent the periods of 2013-2017 and 2018-2022 respectively.")
  )
)


compare <- tabPanel("Overview",
                    fluidPage(
                     h1("How police violence incidents have changed over time"),
                     h6("Overall, there has been a 11% increase in police brutality incidents in the US from the 2013-2017 period to the 2018-2022 period. This trend is also reflected in the regional level, as almost all regions have experienced significant increases or stayed relatively the same."),
                        div(plotlyOutput("lineplot_reg", width = '500px'), align = "center"),
                     p("The Rockies is the region with the most notable increase in incidents (50 percent points), with all states experiencing an increase, the lowest being Montana with 24 percent points, and the highest Wyoming with 76 percent points"),
                         div(plotlyOutput("lineplot_roc",width = '500px'), align = "center"),
                     p("On the contrary, the Mid-Atlantic is the region with the greatest percentage decrease in incidents (28 percent points), with all states experiencing a decrease in incidents, the lowest being Pennsylvania and Virginia 2 percent points, and the highest being Delaware 50 percent points."),
                         div(plotlyOutput("lineplot_mid", width = '500px'), align = "center"),
                    p("These discrepancies show a highly uneven distribution of police brutality incidents across the nation, as well as within regions and states.")
                    )
)


relation <- tabPanel("Police training and incidents", 
                     fluidPage(
                     h1("Exploring the state of New Mexico"),
                     p("New Mexico is the state with the highest number of police brutality incidents per million in the nation (59)."),
                         div(plotlyOutput("barplot_us", width = '500px'), align = "center"),
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
                         div(plotlyOutput("scatter_2013", width = '500px'), align = "center")
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
                         div(plotlyOutput("scatter_2018", width = '500px'), align = "center")
                       )
                     ),
                     p("Perhaps this could be attributed to changes in the total duration of training between both periods. It might be worth considering how this has changed for every state in this period of time. It could be expected that New Mexico experienced a significant decrease in this regard following the possible negative correlation between the mentioned factors."),
                         div(plotlyOutput("barplot_train", width = '500px'), align = "center"),
                     p("Yet analysis proves inconsequential, as New Mexico barely experienced any changes in training duration (save for an 1.4 hour drop). We might get a clearer picture if we zoomed out to the regional level."),
                         div(plotlyOutput("barplot_train_reg", width = '500px'), align = "center"),
                     p("This seems strange, as it turns out that the South West (where New Mexico belongs) is the second region with the most increase in total training, averaging 84 hours. Simply increasing the duration of training might not be a significant solution to the problem of police brutality as it does not seem applicable to regional/state levels, so it might be worth considering how other factors of police training mey have affected this phenomenon in a particular state.")
                     )
)

factors <- tabPanel("Possible solutions",
                    fluidPage(
                    h1("Analyzing the state of Maine"),
                    p("In the 2013-2022 period, the only state that was an outlier (with police incidents significantly higher than those of other states in its region) regarding police incidents per million within all regions was Maine. However, for the 2018-2022 period it dropped significantly by 15% and stopped being an outlier within the Mid-Atlantic region, even falling to the lower quartiles."),
                        div(plotlyOutput("boxplot_2013", width = '500px'), align = "center"),
                        div(plotlyOutput("boxplot_2018", width = '500px'), align = "center"), 
                    p("It could be interesting to examine how police training in the state of Maine changed between periods, as it became the eighth state with the highest decrease in police brutality incidents per million in the nation (dropping 15 percentage points)."),
                        div(plotlyOutput("barchart_inc_change", width = '500px'), align = "center"),
                    p("Police training in the state of Maine has experienced a notable change in the levels of stress that recruits are subject to (higher stress meaning that training is of military type as opposed to academic), becoming the eight state in the nation with the greatest decrease."),
                        div(plotlyOutput("barchart_stress", width = '500px'), align = "center"),
                    p("It also has seen a significant increase in the number of hours of training dedicated to stress management at the personal level, ranking second in the nation as it saw a 10 hour average increase."),
                        div(plotlyOutput("barchart_man", width = '500px'), align = "center"),
                    p("And finally, the state has moved on from no academies offering training in identification and response to excessive use of force by other officers to all academies doing it, becoming the state with the greatest increase in this aspect."),
                        div(plotlyOutput("barchart_exc", width = '550px'), align = "center"),
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
    colnames(state_info)[1] <- "State"
    colnames(state_info)[2] <- "Incidents 2013-2017"
    colnames(state_info)[3] <- "Population 2017"
    colnames(state_info)[4] <- "Incidents per million 2013-2017"
    return(state_info)
  })
  output$df_res_8 <- renderTable({
    state_info_1 <- select(agg_df, state, incidents_2018, Population_2022, incidents_2018_per_1000000)
    state_info_1 <- state_info_1[state_info_1$state == input$state_name, ]
    colnames(state_info_1)[1] <- "State"
    colnames(state_info_1)[2] <- "Incidents 2018-2022"
    colnames(state_info_1)[3] <- "Population 2022"
    colnames(state_info_1)[4] <- "Incidents per million 2018-2022"
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
      labs(x = "Change in stress levels experienced by recruits (1-5 scale)", y = "state")
    bar_5p <- ggplotly(bar_5, tooltip = "text")
    return(bar_5p)
  })
  
  output$barchart_man <- renderPlotly({
    bar_6 <- ggplot(data = agg_df, aes(x = median_stress_man_2018 - median_stress_man_2013, y = reorder(state, median_stress_man_2018 - median_stress_man_2013), text = paste(
      "Change:", round(median_stress_man_2018 - median_stress_man_2013, 1)))) +
      geom_bar(stat = 'identity') +
      labs(x = "Change in stress management skills training (in hours)", y = "state")
    bar_6p <- ggplotly(bar_6, tooltip = "text")  
    return(bar_6p)
  })
  
  output$barchart_exc <- renderPlotly({
    bar_7 <- ggplot(data = agg_df, aes(x = mean_force_id_2018 - mean_force_id_2013, y = reorder(state, mean_force_id_2018), text = paste(
      "Duration change:", round(mean_force_id_2018 - mean_force_id_2013, 1)))) +
      geom_bar(stat = 'identity') +
      labs(x = "Change in proportion of excessive force use identification training", y = "State")
      bar_7p <- ggplotly(bar_7, tooltip = "text")
    return(bar_7p)
  })
  output$map_2013 <- renderPlotly({
    us_2013 <- plot_usmap(data = agg_2013, values = "Incidents") + 
      scale_fill_continuous(low = "white", high = "blue", name = "Incidents per million (2013)", label = scales::comma, limits = c(0, 60)) + 
      theme(legend.position = "right") 
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
