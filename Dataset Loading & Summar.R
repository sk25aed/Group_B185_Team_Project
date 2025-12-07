
library(tidyverse)


setwd("F:/RProject")

df <- read_csv("combined_df.csv")

head(df)
str(df)
summary(df)

write.csv(summary(df), "data_summary.csv")
