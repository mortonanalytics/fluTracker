#' dashboard UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_dashboard_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$div(id="dashboard-charts", class="container-md",
             tags$div(class="dashboard-section-divider"),
             tags$div(class='row', style="margin: 0px 10px 0px 10px;",
                      h2("Influenza Like Illness Dashboard", style="color:whitesmoke; margin: 0px 10px 0px 10px;")
                      ),
             tags$div(class='row', style="margin: 0px 10px 0px 10px;",
                      tags$div(class='col-sm-2',  style="color:whitesmoke;",
                               dateRangeInput(ns("essence_dates"),
                                              label = "Dates for Analysis",
                                              start = Sys.Date() - 7,
                                              end = Sys.Date()
                                              )
                               )
             ),
             tags$div(id="value-box-div", class="row", style="margin: 0px 10px 0px 10px;",
                      tags$div(class='col-sm-2',
                               htmlOutput(ns("value_box_total_ili"))
                               ),
                      tags$div(class='col-sm-2',
                               htmlOutput(ns("value_box_new_ili"))
                              ),
                      tags$div(class='col-sm-2',
                               htmlOutput(ns("value_box_change_in_ili"))
                        ),
                      tags$div(class='col-sm-2',
                               htmlOutput(ns("value_box_total_death"))
                        ),
                      tags$div(class='col-sm-2',
                               htmlOutput(ns("value_box_new_death"))
                        ),
                      tags$div(class='col-sm-2',
                               htmlOutput(ns("value_box_change_in_death"))
                        ),
                      ),
             tags$div(id="dahboard-stats-div", class='row', style="margin: 0px 10px 0px 10px;",
                      tags$div(class='col-sm-6', style="color: rgb(255,255,255,1);",
                               h3("Geo Statistics"),
                               br(),
                                myGIOOutput(ns("county_map"), height = "800px")
                                #verbatimTextOutput(ns("env_check"))
                               ),
                      tags$div(class='col-sm-5', style="margin: 0px 10px 0px 10px; color: rgb(255,255,255,1);",
                               h3("Vital Statistics"),
                               selectInput(ns("vital_stat_grouper"),
                                           "View By",
                                           choices = c(
                                            "Age Group" = "AgeGroup",
                                            "Gender" = "Sex",
                                            "Facility Type" = "FacilityType"
                                            ),
                                           selected = "AgeGroup"
                                           ),
                               myIOOutput(ns("vital_stats"), height = "250px" ),
                               h3("Legislative Tracker"),
                               DT::dataTableOutput(ns("legislation_tracker"), height = "250px" )
                               )
                      )
              )
             
  )
}
    
#'dashboard Server Function
#'
#' @noRd 
mod_dashboard_server <- function(input, output, session){
  ns <- session$ns
  
  #### parameters ####
  start_date <- reactive({
    format(as.Date(input$essence_dates[1]), "%d%b%Y")
  })
  
  end_date <- reactive({
    format(as.Date(input$essence_dates[2]), "%d%b%Y")
  })
  
  #### ESSENCE data read in and summarize ####
  essence_data <- reactive({
    req(input$essence_dates)
    get_essence_data(start_date = start_date(), end_date = end_date())
  })
  
  value_box_values <- reactive({
    process_value_box_data( essence_data() )
  })
  
  map_values <- reactive({
    process_map_data( essence_data() )
  })
  
  vital_statistics <- reactive({
    req(input$vital_stat_grouper)
    
    final <- process_summary_data( 
      df = essence_data(), 
      category = input$vital_stat_grouper 
      )

    return(final)
  })
  
  output$env_check <- renderPrint({
    Sys.getenv("user")
  })
  
  #### value box HTML ####
  
  output$value_box_total_ili <- renderUI({
    tags$div(class="value-card",
             tags$div(class="value-card-header",
                      tags$p(class="value-card-header-text",
                      "Total Influenza Like Illness Cases")
                      ),
             tags$div(class="value-card-value",
                      tags$p(class="value-card-value-text",
                             format(value_box_values()$total_ili, big.mark = ","))
                      )
             )
  })
  
  output$value_box_new_ili <- renderUI({
    tags$div(class="value-card",
             tags$div(class="value-card-header",
                      tags$p(class="value-card-header-text",
                             "New Influenza Like Illness Cases")
             ),
             tags$div(class="value-card-value",
                      tags$p(class="value-card-value-text",
                             format(value_box_values()$new_ili, big.mark = ","))
             )
    )
  })
 
  output$value_box_change_in_ili <- renderUI({
    tags$div(class="value-card",
             tags$div(class="value-card-header",
                      tags$p(class="value-card-header-text",
                             "Daily Change in Influenza Like Illness Cases")
             ),
             tags$div(class="value-card-value",
                      tags$p(class="value-card-value-text",
                             percent(value_box_values()$change_in_ili))
             )
    )
  })
  
  output$value_box_total_death <- renderUI({
    tags$div(class="value-card",
             tags$div(class="value-card-header",
                      tags$p(class="value-card-header-text",
                             "Total Influenza Like Illness Deaths")
             ),
             tags$div(class="value-card-value",
                      tags$p(class="value-card-value-text",
                             format(value_box_values()$total_death, big.mark = ","))
             )
    )
  })
  
  output$value_box_new_death <- renderUI({
    tags$div(class="value-card",
             tags$div(class="value-card-header",
                      tags$p(class="value-card-header-text",
                             "New Influenza Like Illness Deaths")
             ),
             tags$div(class="value-card-value",
                      tags$p(class="value-card-value-text",
                             format(value_box_values()$new_death, big.mark = ","))
             )
    )
  })
  
  output$value_box_change_in_death <- renderUI({
    tags$div(class="value-card",
             tags$div(class="value-card-header",
                      tags$p(class="value-card-header-text",
                             "Daily Change in Influenza Like Illness Deaths")
             ),
             tags$div(class="value-card-value",
                      tags$p(class="value-card-value-text",
                             value_box_values()$change_in_death)
             )
    )
  })
  
  #### map by county ####
  
  addResourcePath("maps", "./maps" )
  
  output$county_map <- renderMyGIO({
    req( map_values() )

    df <- map_values()

    myGIO( height = "800px" ) %>%
      addBase(base = "resourceMap",
              data = df,
              geoJson = df,
              mapping = list(dataKey = "geoid",
                             dataValue = "ILI Cases",
                             toolTip = "ILI Deaths",
                             dataLabel = "NAME",
                             mapKey = "FIPS"),
              options = c(myGIO::setPolygonZoom(behavior = "click",zoomScale = 8),
                          nameFormat = 'text',
                          toolTipFormat = '.0f')
      ) %>%
      readGeoJSON("./maps/WV_Counties.geojson") 

  })
  
  #### vital statistics ####
  
  output$vital_stats <- renderMyIO({
    
    colorKey <- unlist( unique( vital_statistics()[[input$vital_stat_grouper]] ) )
    colorScheme <- viridis::viridis(length(colorKey))
    
    myIO::myIO() %>%
      myIO::addIoLayer("bar",
                       label = "ili",
                       data = vital_statistics(),
                       color = colorScheme[1],
                       mapping = list(
                         x_var = input$vital_stat_grouper,
                         y_var = "ILI Cases"
                       )) %>%
      myIO::setAxisFormat(yAxis = ",.0f" ) %>%
      #myIO::flipAxis()%>%
      myIO::defineCategoricalAxis(xAxis = TRUE, yAxis = FALSE) %>%
      myIO::setAxisLimits( ylim = list(min = 0)) %>%
      myIO::setmargin(bottom = 75, right= 75) %>%
      myIO::suppressLegend()
  })
  
  #### legislation tracker ####
  output$legislation_tracker <- DT::renderDataTable({
    df <- read.csv('./data/wv_leg_tracker.csv', stringsAsFactors = FALSE )
    
    DT::datatable(
      df, 
      escape = FALSE, 
      rownames = FALSE,
      options = list(
        scrollX = TRUE,
        scrolly = TRUE,
        pageLength = 3,
        dom = 'ftp',
        initComplete = JS(
          "function(settings, json) {",
          "$(this.api().table().header()).css({'color': '#fff'});",
          "$(this.api().table().footer()).css({'color': '#fff'});",
          "}")
      )
      )
  })
  
}