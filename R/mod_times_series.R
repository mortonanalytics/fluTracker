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
 
  )
}
    
#' times_series Server Function
#'
#' @noRd 
mod_times_series_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_times_series_ui("times_series_ui_1")
    
## To be copied in the server
# callModule(mod_times_series_server, "times_series_ui_1")
 
