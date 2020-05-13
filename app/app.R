library(shiny)
library(httr)
library(jsonlite)
library(glue)
library(dplyr)
library(myIO)
library(myGIO)

readRenviron("./.Renviron")

lapply(list.files('./util'), function(mod){
  source(paste0("./util/", mod))
})

lapply(list.files('./modules'), function(mod){
  source(paste0("./modules/", mod))
})

# Define UI for application that draws a histogram
ui <- fluidPage(style="padding:0px",
  tagList(
    tags$head(tags$link(href="css/landing.css", rel="stylesheet")),
    tags$head(tags$link(href="css/main.css", rel="stylesheet")),
    tags$head(tags$link(href="css/dashboard.css", rel="stylesheet")),
    tags$head(tags$link(href="css/ts.css", rel="stylesheet")),
    tags$div(id="page-container",
      mod_landing_ui("landing_ui_1"),
      mod_dashboard_ui("dashboard"),
      mod_times_series_ui("times_series_ui_1")
    ),
    tags$body(tags$script(src="js/scrollToView.js"))
  )
 
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  callModule(mod_landing_server, "landing_ui_1")
  
  callModule(mod_dashboard_server, "dashboard")

  callModule(mod_times_series_server, "times_series_ui_1")
}

# Run the application 
shinyApp(ui = ui, server = server)
