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
    tags$div(id="dashboard-charts", class="container-sm",
             tags$div(class="dashboard-section-divider"),
             tags$div(class='row', style="margin: 0px 10px 0px 10px;",
                      tags$div(class='col-sm-12',
                               h1("West Virginia Tracker for Influenza Like Illness (ILI)",
                                  style="color: white; text-align:center; font-family: 'Roboto Slab', serif;")
                               )
                      ),
             #### info cards ####
             tags$div(class='row', style="margin: 0px 10px 0px 10px;",
                      tags$div(class='col-sm-4',
                               tags$div(class="info-card",
                                        tags$div(class="row", style='background-color: #82A9D0; margin: 0px 0px 0px 0px;',
                                                 h3("What is Influenza Like Illness (ILI)?",
                                                    style="text-align:center;"
                                                    )
                                        ),
                                        tags$div(class='row', style="margin: 0px 10px 0px 10px;",
                                                 p("A medical diagnosis of possible influenza or other illness causing similar symptoms",
                                                   style="font-size: 20px"
                                                   )
                                        )
                                        )
                               ),
                      tags$div(class='col-sm-4',
                               tags$div(class="info-card",
                                 tags$div(class="row", style='background-color: #FF9E01; margin: 0px 0px 0px 00px;',
                                          h3("How is the data collected?",
                                             style="text-align:center;"
                                             )
                                 ),
                                 tags$div(class='row',style="margin: 0px 10px 0px 10px;",
                                          p("The data is part of the Centers for Disease Controls's (CDC) early notification system for ILI",
                                            style="font-size: 20px"
                                            )
                                 )
                               )
                               ),
                      tags$div(class='col-sm-4',
                               tags$div(class="info-card",
                                 tags$div(class="row", style='background-color: #BACFE4; margin: 0px 0px 0px 0px;',
                                          h3("What do we use this data for?",
                                             style="text-align:center;"
                                             )
                                 ),
                                 tags$div(class='row',style="margin: 0px 10px 0px 10px;",
                                          p("The data here is intended to track influenza like illness in West Virginia by county to find and predict influenza like illness outbreaks",
                                            style="font-size: 20px"
                                            )
                                 )
                                 )
                               )
                      ),

             #### user input and ???? ####
             # tags$div(class='row', style="margin: 0px 10px 0px 10px;",
             #          tags$div(class='col-sm-2',  style="color:whitesmoke;",
             #                   dateRangeInput(ns("essence_dates"),
             #                                  label = "Select Dates for Analysis",
             #                                  start = Sys.Date() - 7,
             #                                  end = Sys.Date()
             #                                  )
             #                   )
             # ),
             # tags$div(id="value-box-div", class="row", style="margin: 0px 10px 0px 10px;",
             #          tags$div(class='col-sm-2',
             #                   htmlOutput(ns("value_box_total_ili"))
             #                   ),
             #          tags$div(class='col-sm-2',
             #                   htmlOutput(ns("value_box_new_ili"))
             #                  ),
             #          tags$div(class='col-sm-2',
             #                   htmlOutput(ns("value_box_change_in_ili"))
             #            ),
             #          tags$div(class='col-sm-2',
             #                   htmlOutput(ns("value_box_total_death"))
             #            ),
             #          tags$div(class='col-sm-2',
             #                   htmlOutput(ns("value_box_new_death"))
             #            ),
             #          tags$div(class='col-sm-2',
             #                   htmlOutput(ns("value_box_change_in_death"))
             #            ),
             #          ),

             #### dash exhibits ####
             tags$div(id="dashboard-stats-div", class='row', style="margin: 0px 10px 0px 10px;",
                     tags$div(class="col-sm-8", style="color:whitesmoke;",
                               h3("Influenza Like Illness by County", style="color:whitesmoke;"),
                               box( width = "100%",
                                    myGIOOutput(ns("county_map"), height = "700px", width = "100%") %>% withSpinner()
                                   )
                     ),
                     tags$div(class="col-sm-4", style="color:whitesmoke;",
                              # h3("Population Summary", style="color:whitesmoke;"),
                              # selectInput(ns("vital_stat_grouper"),
                              #             "View By",
                              #             choices = c(
                              #               "Age Group" = "AgeGroup",
                              #               "Gender" = "Sex",
                              #               "Facility Type" = "FacilityType"
                              #             ),
                              #             selected = "AgeGroup"
                              # ),
                              # box(width="100%",
                              #     myIOOutput(ns("vital_stats"), height = "250px" )
                              # ),
                              dateRangeInput(ns("essence_dates"),
                                             label = "Select Dates for Analysis",
                                             start = Sys.Date() - 7,
                                             end = Sys.Date()
                              ),
                              #h3("Tracking Summaries", style="color:whitesmoke;"),
                              htmlOutput(ns("value_box_total_ili")),
                              htmlOutput(ns("value_box_change_in_ili")),
                              htmlOutput(ns("value_box_total_death")),
                              box(width = "100%",  solidHeader = TRUE,
                                  title="About the Data",
                                  h4("From the CDC:"),
                                  p("ESSENCE, developed by Johns Hopkins University (JHU), is the platform's primary syndromic surveillance tool, and practitioners across the surveillance community have used variations of ESSENCE successfully for years. "),
                                  br(),
                                  p("The platform was developed through an active collaboration of CDC and other federal agencies, state and local health departments, and public health partners. The platform hosts an array of user-selected tools and has features that are continually being enhanced to reflect their needs.")
                                  ),
                              tags$div(style="margin-left: auto; margin-right: auto",
                                       tags$button(class="nav-btn2", "Next Page", onclick="scrollToSection('times-series-charts')")
                              )

                              )
                      )

             ##### end #####
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

  #### update cached data as needed ####
  last_date <- reactive({
    req(end_date())

    cached_data <- read.table('./data/essence.txt', sep = "|", stringsAsFactors = FALSE, header = T) %>%
      filter(as.Date(Date, "%m/%d/%Y") <= Sys.Date() )
    cached_data_max_date <- format(max(as.Date(cached_data$Date,"%m/%d/%Y")), "%d%b%Y")
    max_diff <- cached_data_max_date < end_date()

    return(max_diff)

  })

  observeEvent(last_date() == TRUE,{

    cached_data <- read.table('./data/essence.txt', sep = "|", stringsAsFactors = FALSE, header = T) %>%
      filter(as.Date(Date, "%m/%d/%Y") <= Sys.Date() )

    cached_data_max_date <- format(max(as.Date(cached_data$Date,"%m/%d/%Y")), "%d%b%Y")

    update_cached_data(cached_data_max_date, end_date())

  })

  #### ESSENCE data read in and summarize ####
  essence_data <- reactive({
    req(end_date())

    cached_data <- read.table('./data/essence.txt', sep = "|", stringsAsFactors = FALSE, header = T) %>%
      filter(as.Date(Date, "%m/%d/%Y") <= Sys.Date() )

    final <- cached_data %>%
        filter( as.Date(Date, "%m/%d/%Y") >= as.Date(start_date(), "%d%b%Y") )

    return(final)

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

    myGIO( height = "700px" ) %>%
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

    myIO::myIO() %>%
      myIO::addIoLayer("bar",
                       label = "ili",
                       data = vital_statistics(),
                       color = 'orange',
                       mapping = list(
                         x_var = input$vital_stat_grouper,
                         y_var = "ILI Cases"
                       )) %>%
      myIO::setAxisFormat(yAxis = ",.0f" ) %>%
      #myIO::flipAxis()%>%
      myIO::defineCategoricalAxis() %>%
      myIO::setAxisLimits( ylim = list(min = 0)) %>%
      myIO::setmargin(bottom = 100, right= 75) %>%
      myIO::suppressLegend()
  })



}
