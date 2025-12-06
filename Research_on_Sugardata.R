## Loading required library
library(tidyverse)

##importing data
df_raw <- read_csv("combined_df .csv")
names(df_raw)
summary(df_raw)
head(df_raw)

## Cleaning and numeric conversion
year_cols <- c("2018/19", "2019/20", "2020/21",
              "2021/22", "2022/23", "May2023/24")
df_clean <- df_raw |>
                mutate(
                  across(
                    all_of(year_cols),
                    ~ as.numeric(gsub(",", "", .x))
                  )
                )       
summary(df_clean[, year_cols])
##filter to production and import only
df_pe <- df_clean |>
  filter(Action %in% c("production", "export")
##building global total per year
df_long <- df_pe |>
  pivot_longer(
    cols      = all_of(year_cols),
    names_to  = "Year",
    values_to = "Volume"
  )
##aggregate to global totals by Action and Years
df_global <- df_long |>
  group_by(Action, Year) |>
  summarise(
    TotalVolume = sum(Volume, na.rm = TRUE),
    .groups     = "drop"
  )

         
         