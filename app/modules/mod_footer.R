#' about UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_footer_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$div(id = "footer", class="container-md", style="min-height: 150px;",
             # includeHTML(
             #   "./www/html/footer.html"
             # )
             # 
             )
  )
}
    
#' landing Server Function
#'
#' @noRd 
mod_footer_server <- function(input, output, session){
  ns <- session$ns
 
}
    
## To be copied in the UI
# mod_landing_ui("landing_ui_1")
    
## To be copied in the server
# callModule(mod_landing_server, "landing_ui_1")
 
