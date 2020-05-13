df <- get_essence_data(start_date = "01Oct2019", end_date = "13May2020")
df_clean <- df %>%
  select(Region, C_Patient_County)

my_list <- split(df_clean, f = df_clean$Region)

new_list <- lapply(my_list, function(x){
  region_name <- unique(x$Region)
  print(region_name)
  region_id <- table(x$C_Patient_County)
  region_id <- region_id[substr(names(region_id), 1,2) == "54"]
  region_id <- sort(-region_id)
  region_id <- names(region_id)[1]
  
  region_id <- ifelse(region_name == "WV_Summers", "54089", region_id)
  region_id <- ifelse(region_name == "WV_Doddridge", "54017", region_id)
  region_id <- ifelse(region_name == "WV_Wayne", "54099", region_id)
  print(length(region_id))
  print(region_id)
  final <- data.frame(county = region_name,
                      geoid = region_id,
                      stringsAsFactors = F)
  return(final)
})

df_final <- do.call("rbind", new_list)

write.table(df_final, file = "C:/Users/Morton/Documents/GitHub/fluTracker/app/data/county_geoids.txt", sep = "|", row.names = FALSE)
