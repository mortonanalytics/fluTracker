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
                               #class = "container",
                               tags$div(class = "row",
                                        tags$div(id = "hero-headline", class = "col-sm-12 col-lg-12",
                                                 tags$div(id="hero-text-box",
                                                          tags$p(id="hero-title-text", "West Virginia Influenza Like Illness Tracking and Prediction",
                                                                 style="font-family: 'Roboto Slab', serif;"
                                                                 ),
                                                          tags$p(class="hero-subtitle-text", "A tool for tracking and predicting Influenza Like Illness in West Virginia"),
                                                          br(),
                                                          tags$p(class="hero-subtitle-text2", "Provided by Extra-Corporeal Membrane Oxygenation Program of the West Virginia University Heart and Vascular Institute"),
                                                          tags$div(style="position:absolute; bottom: -25px; left: 50%;",
                                                            tags$button(class="nav-btn", "Explore Data", onclick="scrollToSection('dashboard-charts')")
                                                          )
                                                          
                                                 )
                                                 )
                                        )
                               )
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
 
