##cleaning data for Brazil 
df_brazil <- df_clean |>
  filter(Name == "Brazil", Action %in% c("production", "export")) |>
  pivot_longer(
    cols      = all_of(year_cols),
    names_to  = "Year",
    values_to = "Volume"
  ) |>
  pivot_wider(
    names_from  = Action,
    values_from = Volume
  ) |>
mutate(Year = factor(Year, levels = year_cols))

##Plot For Brazil

plot(df_brazil$production, df_brazil$export,
     xlab = "Brazil production",
     ylab = "Brazil export",
     main = "Brazil Production vs Export")

abline(lm(export ~ production, data = df_brazil),
       col = "red")