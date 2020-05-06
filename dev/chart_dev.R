library(dplyr)
library(myIO)


#### national ILI totals ####
ili_nat_df <- read.csv('./inst/app/data/national_ILINet.csv', stringsAsFactors = FALSE)%>%
  filter(YEAR >= 2015) %>%
  select(YEAR, WEEK, ILITOTAL) %>%
  mutate(YEAR = as.character(YEAR),
         WEEK = as.numeric(WEEK),
         ILITOTAL = as.numeric(ILITOTAL))

colorKey <- unlist(unique(ili_nat_df$YEAR))
colorScheme <- viridis::viridis(length(colorKey))

myIO() %>%
  addIoLayer("line",
             label = "ili",
             data = ili_nat_df,
             color = colorScheme,
             mapping = list(
               x_var = "WEEK",
               y_var = "ILITOTAL",
               group = "YEAR"
             )) %>%
  setAxisFormat(xAxis = ".0f") %>%
  setAxisLimits(xlim = list(min = 0.5, max = 54), ylim = list(min = 0))

#### state ILI totals ####
ili_wv_df <- read.csv('./inst/app/data/state_ILINet.csv', stringsAsFactors = FALSE)%>%
  filter(YEAR >= 2015) %>%
  select(YEAR, WEEK, ILITOTAL) %>%
  mutate(YEAR = as.character(YEAR),
         WEEK = as.numeric(WEEK),
         ILITOTAL = as.numeric(ILITOTAL))

colorKey <- unlist(unique(ili_wv_df$YEAR))
colorScheme <- viridis::viridis(length(colorKey))

myIO() %>%
  addIoLayer("line",
             label = "ili",
             data = ili_wv_df,
             color = colorScheme,
             mapping = list(
               x_var = "WEEK",
               y_var = "ILITOTAL",
               group = "YEAR"
             )) %>%
  setAxisFormat(xAxis = ".0f") %>%
  setAxisLimits(xlim = list(min = 0.5, max = 54), ylim = list(min = 0))

