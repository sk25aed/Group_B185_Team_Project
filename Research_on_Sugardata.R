## Loading required library
library(tidyverse)

##importing data
df_raw <- read_csv("combined_df .csv")
names(df_raw)
summary(df_raw)
head(df_raw)