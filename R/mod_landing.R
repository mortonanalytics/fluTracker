#' landing UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_landing_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$div(id = "landing-div",
             tags$div(id = "header-bar"),
             tags$div(id = "hero-div",
                      tags$div(id = "hero-content",
                               class = "container",
                               tags$div(class = "row",
                                        tags$div(id = "hero-title", class = "col-sm-6"),
                                        tags$div(id = "hero-headline", class = "col-sm-6")
                                        )
                               ),
                      tags$div(id = "navigation") ## may not be needed
                      )
             )
  )
}
    
#' landing Server Function
#'
#' @noRd 
mod_landing_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_landing_ui("landing_ui_1")
    
## To be copied in the server
# callModule(mod_landing_server, "landing_ui_1")
 
