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
             tags$div(class="section-divider"),
             tags$div(class="row", style="margin: 0px",
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
             tags$div(class='row',
                      tags$div(class='col-sm-8', #style="background-color: white;",
                               #myGIOOutput(ns("county_map"), height = "650px")
                               verbatimTextOutput(ns("env_check"))
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
    format(as.Date(Sys.Date() - 3), "%d%b%Y")
  })
  
  end_date <- reactive({
    format(as.Date(Sys.Date()), "%d%b%Y")
  })
  
  #### ESSENCE data read in and summarize ####
  essence_data <- reactive({
    get_essence_data(start_date = start_date(), end_date = end_date())
  })
  
  value_box_values <- reactive({
    process_value_box_data( essence_data() )
  })
  
  map_values <- reactive({
    process_map_data( essence_data() )
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
  
  # output$county_map <- renderMyGIO({
  #   req( map_values() )
  #   
  #   df <- map_values()
  #   
  #   myGIO() %>%
  #     addBase(base = "resourceMap",
  #             data = df,
  #             geoJson = df,
  #             mapping = list(dataKey = "geoid",
  #                            dataValue = "total_ili",
  #                            toolTip = "total_ili",
  #                            dataLabel = "county",
  #                            mapKey = "FIPSSTCO"),
  #             options = c(myGIO::setPolygonZoom(behavior = "click",zoomScale = 25),
  #                         nameFormat = 'text',
  #                         toolTipFormat = '.0f')
  #     ) %>%
  #     readGeoJSON("./maps/countyMap.geojson")
  #   
  #   
  # })
  
}