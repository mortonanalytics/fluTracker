get_essence_data <- function(start_date, end_date){
  
  #start_date <- "11May2020"
  
  #end_date <- "12May2020"
  
  date_string <- glue("startDate={start_date}&endDate={end_date}")
  
  query_text <- paste0("api/dataDetails?", 
                       date_string, 
                       "&datasource=va_er",
                       "&timeResolution=daily&geographySystem=region",
                       "&medicalGroupingSystem=essencesyndromes&medicalGrouping=ili",
                       "&field=Date&field=Region&field=Category_flat&field=C_Patient_County&field=Sex",
                       "&field=Age&field=AdmissionTypeCategory&field=Insurance_Coverage&field=FacilityType",
                       "&field=WeekYear&field=DeathDateTime&field=C_Death&field=AgeGroup",
                       collapse = "")
  
  results <- fromJSON(
    content(
      httr::GET(paste0("https://essence.syndromicsurveillance.org/nssp_essence/", query_text, collapse = ""), timeout(20), authenticate(Sys.getenv("user"), Sys.getenv("password"))), "text"
    )
  )

  df <- results[[1]]

  df_ili <- df[grepl("*ILI*", df$Category_flat), ]

  return(df_ili)
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
    summarise(total_ili = n()) %>%
    ungroup() %>%
    left_join(df_geoid, by=c("Region" = "county"))
  
  return(final)
}

percent <- function(x, digits = 2, format = "f", ...) {
  paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}
