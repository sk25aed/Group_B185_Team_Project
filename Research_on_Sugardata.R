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
              