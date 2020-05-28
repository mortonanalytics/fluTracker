get_essence_data <- function(start_date, end_date){
  
  #start_date <- "01Oct2019"
  
  #end_date <- "19May2020"
  
  date_string <- glue("startDate={start_date}&endDate={end_date}")
  
  query_text <- paste0("api/dataDetails?", 
                       date_string, 
                       "&datasource=va_er",
                       "&timeResolution=daily&geographySystem=region",
                       "&medicalGroupingSystem=essencesyndromes&medicalGrouping=ili",
                       "&field=Date&field=Region&field=Category_flat&field=C_Patient_County&field=Sex",
                       "&field=Age&field=AdmissionTypeCategory&field=Insurance_Coverage&field=FacilityType",
                       "&field=WeekYear&field=DeathDateTime&field=C_Death&field=AgeGroup&field=C_BioSense_ID",
                       collapse = "")
  
  results <- fromJSON(
    content(
      httr::GET(paste0("https://essence.syndromicsurveillance.org/nssp_essence/", query_text, collapse = ""), timeout(20), authenticate( Sys.getenv("user"), Sys.getenv("password") ))
      , "text"
    )
  )

  df <- results[[1]]

  df_ili <- df[grepl("*ILI*", df$Category_flat), ]

  return(df_ili)
}

update_cached_data <- function(start_date, end_date){
  
  cached_data <- read.table('./data/essence.txt', sep = "|", stringsAsFactors = FALSE, header = T) %>%
    filter(as.Date(Date, "%m/%d/%Y") <= Sys.Date() )
  
  cached_data_min_date <- format(min(as.Date(cached_data$Date,"%m/%d/%Y")), "%d%b%Y")
  cached_data_max_date <- format(max(as.Date(cached_data$Date,"%m/%d/%Y")), "%d%b%Y")
  
  #### check if new data is needed ####
  min_diff <- cached_data_min_date > start_date
  max_diff <- cached_data_max_date < end_date
  
  if(min_diff | max_diff){
    
    #### update cached data ####
    tryCatch({
      
      df <- get_essence_data(start_date, end_date)
      
      ids <- unique(df$C_BioSense_ID)
      cached_ids <- unique(cached_data$C_BioSense_ID)
      ids <- ids[ !ids %in% cached_ids ]
      new_rows <- df[ df$C_BioSense_ID %in% ids,  ]
      
      if(nrow(new_rows) > 0) {
        
        print("new essence rows")
        
        final <- rbind(cached_data, new_rows)
      
        write.table(final, './data/essence.txt', sep = "|", row.names = FALSE)
        
        print("table written successfully")
        
        } else {
        return(NA)
      }
      
    },
    error=function(cond) {
      message("Here's the essence error message:")
      message(cond)
      # Choose a return value in case of error
      return(NA)
    }, finally = {
      message("essence finally")
      
      return(NA)
    })
    
  }
  
}

process_value_box_data <- function(df){
  
  df_totals <- df %>%
    summarise(
      total_ili = n(),
      total_death = length(C_Death[C_Death == "Yes"])
      )
  
  df_dailys <- df %>%
    group_by(Date)%>%
    summarise(
      new_ili = n(),
      new_death = length(C_Death[C_Death == "Yes"])
    )%>%
    ungroup() %>%
    mutate(
      change_in_ili = (new_ili - lag(new_ili)) / lag(new_ili),
      change_in_death = new_death - lag(new_death) 
      ) %>%
    filter(Date == max(Date))
  
  final <- list(
    total_ili = df_totals$total_ili,
    new_ili = df_dailys$new_ili,
    change_in_ili = df_dailys$change_in_ili,
    total_death = df_totals$total_death,
    new_death = df_dailys$new_death,
    change_in_death = df_dailys$change_in_death
  )
  
  return(final)
}

process_map_data <- function(df){
  
  df_geoid <- read.delim("./data/county_geoids.txt", sep = "|", header = TRUE, stringsAsFactors = FALSE)
  
  final <- df %>%
    group_by(Region) %>%
    summarise(
      'ILI Cases' = n(),
      'ILI Deaths' = length(C_Death[C_Death == "Yes"])
              ) %>%
    ungroup() %>%
    left_join(df_geoid, by=c("Region" = "county"))
  
  return(final)
}

process_summary_data <- function(df, category){
  
  grouper <- sym(category)
  
  final <- df %>%
    group_by( !!grouper ) %>%
    summarise(
      'ILI Cases' = n()
    ) %>%
    ungroup() 
  
  return(final)
}

percent <- function(x, digits = 2, format = "f", ...) {
  paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}

update_twitter_cache <- function(start_date, end_date){
  
  
  df_tweet_archive <- read.table("./data/tweet_data.txt", 
                                 colClasses=c(rep("character", 4),rep("numeric", 2)),
                                 header = TRUE, 
                                 stringsAsFactors = FALSE,
                                 sep = "|")
  
  cached_data_min_date <- format(min(as.Date(df_tweet_archive$created_at,"%Y-%m-%d")), "%Y-%m-%d")
  cached_data_max_date <- format(max(as.Date(df_tweet_archive$created_at,"%Y-%m-%d")), "%Y-%m-%d")
  
  #### check if new data is needed ####
  min_diff <- cached_data_min_date > start_date
  max_diff <- cached_data_max_date < end_date
  
  if(min_diff | max_diff){
    
    #### update cached data ####
    tryCatch({
      
      rt <- get_twitter_data(start_date, end_date)
  
      df_tweet_combined <- rt %>%
        bind_rows(df_tweet_archive) %>%
        distinct(status_id, .keep_all = TRUE)
      
      write.table(df_tweet_combined, './data/tweet_data.txt', sep = "|", row.names = FALSE)
      print("twitter completed update")
      
    },
    error=function(cond) {
      message("Here's the twitter error message:")
      message(cond)
      # Choose a return value in case of error
      return(NA)
    }, finally = {
      message("twitter finally")
      
      return(NA)
    })
    
  }
}

get_twitter_data <- function(start_date, end_date){
  
  ## authenticate via web browser
  token <- create_token(
    app = "WV-fluTracker",
    consumer_key = Sys.getenv("api_key"),
    consumer_secret = Sys.getenv("api_secret_key"),
    access_token = Sys.getenv("access_token"),
    access_secret = Sys.getenv("access_token_secret"))
  
  #### query elements
  
  fromDate <- format(start_date, "%Y%m%d%H%M")
  toDate <- format(end_date , "%Y%m%d%H%M")
  
  query_text <- paste0(c('(fever', 'headache', 'sick', '"respiratory virus"', 'ache', '"stuffy nose"', 'dehydration', 'flu', 'influenza', 'contagious', 'cough)'),
                       collapse = " OR ")
  
  query_text <- paste0(query_text, "(place:2d83c71ce16cd187)",collapse = " AND ")
  
  #### query ####
  rt <- search_30day(
    q = query_text,
    env_name = "dev",
    n=300,
    fromDate = fromDate,
    toDate = toDate
  ) %>%
    #### query processing ####
    tweets_data()%>%
    filter(is_retweet == FALSE) %>%
    select(status_id, created_at, user_id, text) %>%
    mutate(created_at = format(created_at, "%Y-%m-%d"),
           year = year(created_at),
           week = week(created_at)
    )
  
}