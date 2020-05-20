#' times_series UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_times_series_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$div(id="times-series-charts", class="container-md", style="background-color: rgb(255,255,255,0.3);",
             tags$div(class="section-divider"),
             tags$div(class='row', style="margin: 0px 10px 0px 10px;",
                      tags$div(class='col-sm-12',
                               h1("Historical Trends and West Virginia Legistlative History", 
                                  style="color: white; text-align:center;")
                      )
             ),
             tags$div(class="row", style="margin: 0px 10px 0px 10px;",
                      
                      tags$div(class="col-sm-6 chart-container",
                               
                               tabsetPanel(type = "pills",
                                 tabPanel(title = "National Trends",
                                          box(myIO::myIOOutput(ns("ts_nat"), height = "450px"), width = "100%")
                                          ),
                                 tabPanel(title = "West Virginia Trends",
                                          box(myIO::myIOOutput(ns("ts_wv")), width = "100%")
                                          )
                               ),
                               tags$div(class="info-card", style="min-height: 275px",
                                        tags$div(class="row", style='background-color: #82A9D0; margin: 0px 0px 0px 0px;',
                                                 h3("Historical Trends",
                                                    style="text-align:center;"
                                                 )
                                        ),
                                        tags$div(class='row', style="margin: 0px 10px 0px 10px;",
                                                 tags$ul(style="font-size: 20px;",
                                                         tags$li("Information on patient visits to health care providers for influenza like illness (ILI) is collected through the U.S. Outpatient influenza like illness (ILI) Surveillance Network (ILINet)."),
                                                         tags$li("This collaborative effort between CDC, state and local health departments, and health care providers started during the 1997-98 influenza season when approximately 250 providers were enrolled."),
                                                         tags$li("Enrollment in the system has increased over time and there were >3,000 providers enrolled during the 2010-11 season.") 
                                                 )
                                        )
                               )
                               
                        ),
                      tags$div(class="col-sm-6 ",
                               tabsetPanel(type = "pills",
                                 tabPanel(
                                   title = "West Virginia Legislation",
                                   DT::dataTableOutput(ns("legislation_tracker"), height = "450px")
                                   )
                               ),
                               tags$div(class="info-card", style="min-height: 275px",
                                        tags$div(class="row", style='background-color: #FF9E01; margin: 0px 0px 0px 00px;',
                                                 h3("Legislative History",
                                                    style="text-align:center;"
                                                 )
                                        ),
                                        tags$div(class='row',style="margin: 0px 10px 0px 10px;",
                                                 tags$ul(style="font-size: 20px;",
                                                         tags$li("The West Virginia Legislature convenes annually for sixty (60) days."),
                                                         tags$li("The list of bills below represent both proposed and passed legislation relating to influenza."),
                                                         tags$li("Follow the links to read the text of the bill.") 
                                                 )
                                        )
                               ),
                               
                        ),
                      tags$div(style="margin-left: auto; margin-right: auto; margin-top: 10px; margin-bottom: 10px",
                               tags$button(class="nav-btn3", "Next Page", onclick="scrollToSection('about-section')")
                      )
                      )
                    )
             
  )
}
    
#' times_series Server Function
#'
#' @noRd 
mod_times_series_server <- function(input, output, session){
  ns <- session$ns
  
  output$ts_nat <- myIO::renderMyIO({
    ili_nat_df <- read.csv('./data/national_ILINet.csv', stringsAsFactors = FALSE )%>%
      dplyr::filter(YEAR >= 2015) %>%
      dplyr::select(YEAR, WEEK, ILITOTAL) %>%
      dplyr::mutate(YEAR = as.character(YEAR),
             WEEK = as.numeric(WEEK),
             ILITOTAL = as.numeric(ILITOTAL))
    
    colorKey <- unlist(unique(ili_nat_df$YEAR))
    colorScheme <- viridis::viridis(length(colorKey))
    
    myIO::myIO() %>%
      myIO::addIoLayer("line",
                 label = "ili",
                 data = ili_nat_df,
                 color = colorScheme,
                 mapping = list(
                   x_var = "WEEK",
                   y_var = "ILITOTAL",
                   group = "YEAR"
                 )) %>%
      myIO::setAxisFormat(xAxis = ".0f") %>%
      myIO::setAxisLimits(xlim = list(min = 0.5, max = 54), ylim = list(min = 0))
  })
  
  output$ts_wv <- myIO::renderMyIO({
    ili_wv_df <- read.csv('./data/state_ILINet.csv', stringsAsFactors = FALSE)%>%
      dplyr::filter(YEAR >= 2015) %>%
      dplyr::select(YEAR, WEEK, ILITOTAL) %>%
      dplyr::mutate(YEAR = as.character(YEAR),
             WEEK = as.numeric(WEEK),
             ILITOTAL = as.numeric(ILITOTAL))
    
    colorKey <- unlist(unique(ili_wv_df$YEAR))
    colorScheme <- viridis::viridis(length(colorKey))
    
    myIO::myIO() %>%
      myIO::addIoLayer("line",
                 label = "ili",
                 data = ili_wv_df,
                 color = colorScheme,
                 mapping = list(
                   x_var = "WEEK",
                   y_var = "ILITOTAL",
                   group = "YEAR"
                 )) %>%
      myIO::setAxisFormat(xAxis = ".0f") %>%
      myIO::setAxisLimits(xlim = list(min = 0.5, max = 54), ylim = list(min = 0))
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
        pageLength = 5,
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
    
## To be copied in the UI
# mod_times_series_ui("times_series_ui_1")
    
## To be copied in the server
# callModule(mod_times_series_server, "times_series_ui_1")
 
