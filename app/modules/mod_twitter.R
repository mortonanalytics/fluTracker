#' twitter UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_twitter_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$div(id="twitter-charts", class="container-md container-sm", style="background-color: rgba(255,255,255,0.3);",
             tags$div(class="section-divider"),
             tags$div(class='row', style="margin: 0px 10px 0px 10px;",
                      tags$div(class='col-sm-12',
                               h1("Social Media Tracking via Twitter", 
                                  style="color: white; text-align:center; font-family: 'Roboto Slab', serif;")
                      )
             ),
             tags$div(class="row", style="margin: 0px 10px 0px 10px;",
                      tags$div(class = "col-sm-6", style="color: whitesmoke",
                               h3("Influenza Like Illness Twitter Totals by Week", style="color: whitesmoke"),
                               box(
                                 width = "100%",
                                 myIOOutput( ns("tweet_count"), height = "600px" )
                                )
                               ),
                      tags$div(class = "col-sm-6", style="color: whitesmoke",
                               h3("Influenza Like Illness Top Word Counts", style="color: whitesmoke"),
                               box(
                                 width = "100%",
                                 myIOOutput( ns("word_count"), height = "600px" )
                               )
                               )
                      ),
             tags$br(),
             tags$div(class="row", style="margin: 0px 10px 0px 10px;",
                      tags$div(class="col-sm-12",
                               tags$div(class="container",
                                        tags$h3(style="color: whitesmoke",
                                          "Twitter data refelcts Tweets involving ILI keywords and had geographic data to identify the tweet came from West Virgina. There are likely more tweets but their location cannot be verified."
                                        )
                                        ),
                               tags$div(style="display: flex; flex-flow: column; align-items: center;",
                                        tags$button(class="nav-btn4", "Next Page", onclick="scrollToSection('about-section')")
                                )
                               )
                      ),
             tags$br()
            )
             
  )
}
    
#' twitter Server Function
#'
#' @noRd 
mod_twitter_server <- function(input, output, session){
  ns <- session$ns
  
  #### update cached data as needed ####
  last_date <- reactive({
    cached_data <- read.table("./data/tweet_data.txt", 
              colClasses=c(rep("character", 4),rep("numeric", 2)),
              header = TRUE, 
              stringsAsFactors = FALSE,
              sep = "|")
    
    cached_data_max_date <- format(max(as.Date(cached_data$created_at,"%Y-%m-%d")), "%Y-%m-%d")
    
    max_diff <- cached_data_max_date < Sys.Date()
    
    return(max_diff)
    
  })
  
  observeEvent(last_date() == TRUE,{
    
    cached_data <- read.table("./data/tweet_data.txt", 
                              colClasses=c(rep("character", 4),rep("numeric", 2)),
                              header = TRUE, 
                              stringsAsFactors = FALSE,
                              sep = "|")
    
    cached_data_max_date <- format(max(as.Date(cached_data$created_at,"%Y-%m-%d")), "%Y-%m-%d")
    
    update_twitter_cache(cached_data_max_date, format(Sys.Date(), "%Y-%m-%d") )
    message("tweet archive updated")
  })
  
  cached_data <- reactive({
    
    df_tweet_archive <- read.table("./data/tweet_data.txt", 
                                  colClasses=c(rep("character", 4),rep("numeric", 2)),
                                  header = TRUE, 
                                  stringsAsFactors = FALSE,
                                  sep = "|")
    
    message("tweet archive read")
    
    return(df_tweet_archive)
  })
  
  daily_summary <- reactive({
    
    df_daily_tweets <- cached_data() %>%
      group_by(year,week) %>%
      summarise(Tweets = n()) 
    
    df_daily_users <- cached_data() %>%
      group_by(year,week) %>%
      summarise(Users = n_distinct(user_id))
    
    df_daily <- df_daily_tweets %>%
      left_join(df_daily_users, by = c("year" = "year", "week" = "week")) %>%
      arrange(year, week)
    
    return(df_daily)
  })
  
  word_frequencies <- reactive({
    remove_reg <- "&amp;|&lt;|&gt;"
    
    df_word_frequency <- cached_data() %>% 
      #filter(week(created_at) == max(week(created_at))) %>%
      filter(!str_detect(text, "^RT")) %>%
      mutate(text = str_remove_all(text, remove_reg)) %>%
      unnest_tokens(word, text, token = "tweets") %>%
      filter(!word %in% stop_words$word,
             !word %in% str_remove_all(stop_words$word, "'"),
             str_detect(word, "[a-z]")) %>% 
      #group_by(year = year(created_at), week = week(created_at)) %>% 
      count(word, sort = TRUE) %>% 
      mutate(freq = n/ sum(n)) %>%
      top_n(10, n) %>%
      arrange(n)
  })
  
  output$tweet_count <- renderMyIO({
    req( daily_summary() )
    
    myIO() %>%
      addIoLayer(
        type = "bar",
        color = "steelblue",
        label = "Users",
        data = daily_summary(),
        mapping = list(
          x_var = "week",
          y_var = "Users"
        )
      ) %>%
      addIoLayer(
        type = "bar",
        color = "orange",
        label = "Tweets",
        data = daily_summary(),
        mapping = list(
          x_var = "week",
          y_var = "Tweets"
        ),
        options = list(
          barSize = "small"
        )
      ) %>%
      setAxisFormat(xAxis = ".0f", xLabel = "Weeks") %>%
      defineCategoricalAxis() %>%
      #suppressLegend() %>%
      setmargin(bottom = 80)
  })
  
  output$word_count <- renderMyIO({
    req( word_frequencies() )
    myIO() %>%
      addIoLayer(
        type = "bar",
        color = "purple",
        label = "words",
        data = word_frequencies(),
        mapping = list(
          x_var = "word",
          y_var = "n"
        )
      ) %>%
      flipAxis()%>%
      suppressLegend()%>%
      defineCategoricalAxis(xAxis = FALSE, yAxis = TRUE) %>%
      setmargin(left = 80)
    
  })
 
}
    
## To be copied in the UI
# mod_times_series_ui("times_series_ui_1")
    
## To be copied in the server
# callModule(mod_times_series_server, "times_series_ui_1")
 
