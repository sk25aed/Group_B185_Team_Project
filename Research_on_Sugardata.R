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
  filter(Action %in% c("production", "export"))
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
## one row per Year, columns for production and export
df_research <- df_global |>
  pivot_wider(
    names_from  = Action,
    values_from = TotalVolume
  ) |>
##ordering years correctly
 mutate(
    Year = factor(Year, levels = year_cols)
  )
## Inspecting final research sub‑dataset
df_research
summary(df_research)
## visualization
##Time‑series line plot for production and export
year_labels <- df_research$Year
x <- seq_along(year_labels)
y_min <- min(df_research$production, df_research$export, na.rm = TRUE) * 0.95
y_max <- max(df_research$production, df_research$export, na.rm = TRUE) * 1.05

par(mar = c(5, 5, 4, 2)) 
plot(x, df_research$production,
     type = "n",
     xaxt = "n",
     ylim = c(y_min, y_max),
     xlab = "Marketing year (2018/19-May2023/24)",
     ylab = "Volume of sugar",
     main = "Global Sugar Production and Export")

axis(1, at = x, labels = year_labels)

lines(x, df_research$production,
      type = "o",
      col  = "blue",
      lwd  = 2,
      pch  = 16)

lines(x, df_research$export,
      type = "o",
      col  = "red",
      lwd  = 2,
      lty  = 2,
      pch  = 17)

legend("topleft",
       legend = c("Global production", "Global exports"),
       col    = c("blue", "red"),
       lty    = c(1, 2),
       pch    = c(16, 17),
       bty    = "n",
       cex    = 0.9)
## Scatter plot of production vs export.
plot(df_research$production, df_research$export,
     xlab = "Global sugar production (thousand tonnes)",
     ylab = "Global sugar exports (thousand tonnes)",
     main = "Scatterplot of Global Production vs Export")
abline(lm(export ~ production, data = df_research),
       col = "darkgreen", lwd = 2)
## Histogram for the production and export
hist(df_research$production, 
     main = "Histogram of Global Production", 
     xlab = "Production (thousand tonnes)") 
hist(df_research$export, 
     main = "Histogram of Global Export", 
     xlab = "Export (thousand tonnes)") 
## Basic descriptive statistics summary(df_research[, c("production", "export")])



         
         
