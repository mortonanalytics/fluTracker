# library(httr)
# library(jsonlite)
# 
# get_essence_data <- function(start_date, end_date){
#   query_text <- "api/dataDetails?startDate=10May2020&endDate=11May2020&datasource=va_er&timeResolution=daily&geographySystem=region&medicalGroupingSystem=essencesyndromes"
#   
#   results <- fromJSON(
#     content(
#       GET(paste0("https://essence.syndromicsurveillance.org/nssp_essence/", query_text, collapse = ""), authenticate("rmorton01", "TtBg$011#222")), "text"
#     )
#   )
#   
#   df <- results[[1]]
#   
#   df_ili <- df[grepl("*ILI*", df$Category_flat), ]
#   
#   return(df_ili)
# }


