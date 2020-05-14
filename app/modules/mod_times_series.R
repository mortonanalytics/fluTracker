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
    tags$div(id="times-series-charts", class="container-md", style="background-color: rgb(255,255,255,0.2",
             tags$div(class="section-divider"),
             tags$div(class='row', style="margin: 0px 10px 0px 10px;",
                      h2("Historic Trends", style="color:whitesmoke; margin: 0px 10px 0px 10px;")
             ),
             tags$div(class="row", style="margin: 0px 10px 0px 10px;",
                      
                      tags$div(class="col-sm-6 chart-container",
                               tabsetPanel(
                                 tabPanel(title = "National Trends",
                                          br(),
                                          myIO::myIOOutput(ns("ts_nat"))
                                          ),
                                 tabPanel(title = "West Virginia Trends",
                                          br(),
                                          myIO::myIOOutput(ns("ts_wv"))
                                          )
                               )
                               
                        ),
                      tags$div(class="col-sm-6 "
                               
                        )
                      )
                    ),
    tags$div(class="section-divider"),
    tags$div(class="section-divider")
             
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
 
}
    
## To be copied in the UI
# mod_times_series_ui("times_series_ui_1")
    
## To be copied in the server
# callModule(mod_times_series_server, "times_series_ui_1")
 
