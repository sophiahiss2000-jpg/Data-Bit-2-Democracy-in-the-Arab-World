setwd("C:/Users/Sophia Hiss/Desktop/Sophia Daten/AA Uni/Master/MIA/courses/Spring26/Data Journalism/DataBits_Playground/DataBit2")
getwd()

library(tidyverse)
library(sf)
library(rnaturalearth)
library(leaflet)
library(htmlwidgets)
library(plotly)
install.packages("writexl")
library(writexl)
library(ggrepel)

# 1) Ordner setzen
ordner <- "C:/Users/Sophia Hiss/Desktop/Sophia Daten/AA Uni/Master/MIA/courses/Spring26/Data Journalism/DataBits_Playground/DataBit2"

# 2) Funktion für eine Wave
process_wave <- function(datei, wave, year) {
  df <- read_csv(file.path(ordner, datei), show_col_types = FALSE)
  
  nms_lower <- tolower(names(df))
  
  # COUNTRY finden
  country_var <- names(df)[nms_lower == "country"]
  
  # WT finden
  weight_var <- names(df)[nms_lower %in% c("wt", "weight")]
  
  # Q516_4 finden (verschiedene Schreibweisen)
  q_var <- names(df)[nms_lower %in% c("q516_4", "q5164")]
  
  # Checks
  if (length(country_var) == 0) {
    stop(paste("Keine Länder-Spalte in", datei, "gefunden."))
  }
  
  if (length(weight_var) == 0) {
    stop(paste("Keine Gewichts-Spalte in", datei, "gefunden."))
  }
  
  if (length(q_var) == 0) {
    stop(paste("Keine Q516_4-Spalte in", datei, "gefunden."))
  }
  
  df %>%
    mutate(
      COUNTRY_std = .data[[country_var[1]]] %>%
        as.character() %>%
        stringr::str_remove("^\\d+\\.\\s*") %>%
        stringr::str_trim(),
      WT_std = .data[[weight_var[1]]],
      Q516_std = .data[[q_var[1]]]
    ) %>%
    select(COUNTRY_std, WT_std, Q516_std) %>%
    filter(!is.na(COUNTRY_std)) %>%
    mutate(
      wave = wave,
      year = year
    ) %>%
    group_by(wave, year, COUNTRY_std) %>%
    summarise(
      observations_total = n(),
      pct_q516_4_1_2 = weighted.mean(Q516_std %in% c(1, 2), WT_std, na.rm = TRUE),
      .groups = "drop"
    )
}


# 3) Alle gewünschten Waves einlesen
ab2_summary <- process_wave("AB2.csv", "Wave II", 2011)
ab3_summary <- process_wave("AB3.csv", "Wave III", 2013)
ab4_summary <- process_wave("AB4.csv", "Wave IV", 2016)
ab5_summary <- process_wave("AB5.csv", "Wave V", 2018)
ab7_summary <- process_wave("AB7.csv", "Wave VII", 2022)
ab8_summary <- process_wave("AB8.csv", "Wave VIII", 2024)

# 4) Alles zusammenführen
all_waves_summary <- bind_rows(
  ab2_summary,
  ab3_summary,
  ab4_summary,
  ab5_summary,
  ab7_summary,
  ab8_summary
)

# 5) Ländercodes in Namen umwandeln
all_waves_summary <- all_waves_summary %>%
  rename(country = COUNTRY_std) %>%
  select(wave, year, country, observations_total, pct_q516_agree)

# 6) Ergebnis anschauen
print(all_waves_summary)


# 7) Debug ausgaben 
ab2 <- readr::read_csv(file.path(ordner, "AB2.csv"), show_col_types = FALSE)
ab3 <- readr::read_csv(file.path(ordner, "AB3.csv"), show_col_types = FALSE)

table(ab2$q5164, useNA = "ifany")
table(ab3$q5164, useNA = "ifany")

#Finale Funktion

country_lookup <- c(
  "1"  = "Algeria",
  "5"  = "Egypt",
  "7"  = "Iraq",
  "8"  = "Jordan",
  "9"  = "Kuwait",
  "10" = "Lebanon",
  "11" = "Libya",
  "12" = "Mauritania",
  "13" = "Morocco",
  "15" = "Palestine",
  "16" = "Qatar",
  "19" = "Sudan",
  "21" = "Tunisia",
  "22" = "Yemen"
)

process_wave1 <- function(datei, wave_label, year_value) {
  df <- readr::read_csv(file.path(ordner, datei), show_col_types = FALSE)
  
  nms_lower <- tolower(names(df))
  
  country_var <- names(df)[nms_lower == "country"]
  weight_var  <- names(df)[nms_lower %in% c("wt", "weight")]
  q_var       <- names(df)[nms_lower %in% c("q516_4", "q5164")]
  
  if (length(country_var) == 0) {
    stop(paste("Keine Länder-Spalte in", datei, "gefunden."))
  }
  if (length(weight_var) == 0) {
    stop(paste("Keine Gewichts-Spalte in", datei, "gefunden."))
  }
  if (length(q_var) == 0) {
    stop(paste("Keine Q516-Spalte in", datei, "gefunden."))
  }
  
  df %>%
    mutate(
      country_raw = .data[[country_var[1]]] %>%
        as.character() %>%
        stringr::str_remove("^\\d+\\.\\s*") %>%
        stringr::str_trim(),
      
      COUNTRY_std = dplyr::recode(country_raw, !!!country_lookup, .default = country_raw),
      
      WT_std = suppressWarnings(as.numeric(.data[[weight_var[1]]])),
      
      Q516_raw = .data[[q_var[1]]] %>%
        as.character() %>%
        stringr::str_trim() %>%
        stringr::str_to_lower(),
      
      q516_agree = dplyr::case_when(
        Q516_raw %in% c(
          "1", "2",
          "1. i strongly agree",
          "2. i agree",
          "i strongly agree",
          "i somewhat agree"
        ) ~ 1,
        is.na(Q516_raw) ~ NA_real_,
        TRUE ~ 0
      ),
      
      wave = wave_label,
      year = year_value
    ) %>%
    filter(!is.na(COUNTRY_std)) %>%
    group_by(wave, year, COUNTRY_std) %>%
    summarise(
      observations_total = n(),
      agree_q516_n = sum(q516_agree == 1, na.rm = TRUE),
      any_weights_missing = any(is.na(WT_std)),
      valid_q516_n = sum(!is.na(q516_agree)),
      valid_weighted_n = sum(!is.na(q516_agree) & !is.na(WT_std)),
      pct_q516_agree = if (sum(!is.na(q516_agree)) == 0) {
        NA_real_
      } else if (sum(!is.na(q516_agree) & !is.na(WT_std)) == 0) {
        mean(q516_agree, na.rm = TRUE)
      } else {
        weighted.mean(
          q516_agree[!is.na(q516_agree) & !is.na(WT_std)],
          WT_std[!is.na(q516_agree) & !is.na(WT_std)]
        )
      },
      .groups = "drop"
    )
}

process_wave <- function(datei, wave_label, year_value) {
  df <- readr::read_csv(file.path(ordner, datei), show_col_types = FALSE)
  
  nms_lower <- tolower(names(df))
  
  country_var <- names(df)[nms_lower == "country"]
  weight_var  <- names(df)[nms_lower %in% c("wt", "weight")]
  q_var       <- names(df)[nms_lower %in% c("q516_4", "q5164")]
  
  if (length(country_var) == 0) {
    stop(paste("Keine Länder-Spalte in", datei, "gefunden."))
  }
  if (length(weight_var) == 0) {
    stop(paste("Keine Gewichts-Spalte in", datei, "gefunden."))
  }
  if (length(q_var) == 0) {
    stop(paste("Keine Q516-Spalte in", datei, "gefunden."))
  }
  
  df %>%
    mutate(
      country_raw = .data[[country_var[1]]] %>%
        as.character() %>%
        stringr::str_remove("^\\d+\\.\\s*") %>%
        stringr::str_trim(),
      
      COUNTRY_std = dplyr::recode(country_raw, !!!country_lookup, .default = country_raw),
      
      WT_std = suppressWarnings(as.numeric(.data[[weight_var[1]]])),
      
      Q516_raw = .data[[q_var[1]]] %>%
        as.character() %>%
        stringr::str_trim() %>%
        stringr::str_to_lower(),
      
      q516_agree = dplyr::case_when(
        Q516_raw %in% c(
          "1", "2",
          "1. i strongly agree",
          "2. i agree",
          "i strongly agree",
          "i somewhat agree"
        ) ~ 1,
        is.na(Q516_raw) ~ NA_real_,
        TRUE ~ 0
      ),
      
      wave = wave_label,
      year = year_value
    ) %>%
    filter(!is.na(COUNTRY_std)) %>%
    group_by(wave, year, COUNTRY_std) %>%
    summarise(
      observations_total = n(),
      agree_q516_n = sum(q516_agree == 1, na.rm = TRUE),
      any_weights_missing = any(is.na(WT_std)),
      valid_q516_n = sum(!is.na(q516_agree)),
      valid_weighted_n = sum(!is.na(q516_agree) & !is.na(WT_std)),
      pct_q516_agree = if (sum(!is.na(q516_agree)) == 0) {
        NA_real_
      } else if (sum(!is.na(q516_agree) & !is.na(WT_std)) == 0) {
        mean(q516_agree, na.rm = TRUE)
      } else {
        weighted.mean(
          q516_agree[!is.na(q516_agree) & !is.na(WT_std)],
          WT_std[!is.na(q516_agree) & !is.na(WT_std)]
        )
      },
      .groups = "drop"
    )
}

# 8) Alle gewünschten Waves einlesen
ab2_summary <- process_wave("AB2.csv", "Wave II", "2010-2011")
ab3_summary <- process_wave("AB3.csv", "Wave III", "2012-2014")
ab4_summary <- process_wave("AB4.csv", "Wave IV", "2016-2017")
ab5_summary <- process_wave("AB5.csv", "Wave V", "2018-2019")
ab7_summary <- process_wave("AB7.csv", "Wave VII", "2021-2022")
ab8_summary <- process_wave("AB8.csv", "Wave VIII", "2023-2024")

# 9) Alle waves zusammenführen 

all_waves_summary <- bind_rows(
  ab2_summary,
  ab3_summary,
  ab4_summary,
  ab5_summary,
  ab7_summary,
  ab8_summary
)

# 10) Ländercodes in Namen umwandeln
all_waves_summary <- all_waves_summary %>%
  rename(country = COUNTRY_std) %>%
  select(wave, year, country, observations_total, agree_q516_n, pct_q516_agree)

# 11) Ergebnis anschauen
print(all_waves_summary)


#12 Prepare dataset with percentages 
all_waves_summary <- all_waves_summary %>%
  mutate(
    pct_q516_agree_pct = pct_q516_agree * 100
  )

#MAP MAKING

#Load Country shapes and keep countries needed
world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")
mena_countries <- c(
  "Algeria", "Egypt", "Iraq", "Jordan", "Kuwait", "Lebanon",
  "Libya", "Mauritania", "Morocco", "Palestine", "Qatar",
  "Sudan", "Tunisia", "Yemen", "Saudi Arabia"
)
mena_map <- world %>%
  filter(admin %in% mena_countries)

# Fix country names mismatches: 
unique(mena_map$admin)
names(mena_map)
names(survey_map_data)
mena_map <- mena_map %>%
  rename(country = name)

#Mutate Unique in DF
survey_map_data <- all_waves_summary %>%
  mutate(country = as.character(country))


#Function to build one interactive map for one wave

make_wave_map <- function(wave_name) {
  
  wave_data <- survey_map_data %>%
    filter(wave == wave_name)
  
  map_data <- mena_map %>%
    left_join(wave_data, by = "country")
  
  pal <- colorNumeric(
    palette = "YlOrRd",
    domain = map_data$pct_q516_agree_pct,
    na.color = "#d9d9d9"
  )
  
  leaflet(map_data) %>%
    addProviderTiles("CartoDB.Positron") %>%
    addPolygons(
      fillColor = ~pal(pct_q516_agree_pct),
      fillOpacity = 0.8,
      color = "white",
      weight = 1,
      smoothFactor = 0.2,
      popup = ~paste0(
        "<strong>", country, "</strong><br>",
        "Wave: ", wave, "<br>",
        "Agree: ", round(pct_q516_agree_pct, 1), "%<br>",
        "N: ", observations_total
      ),
      highlightOptions = highlightOptions(
        weight = 2,
        color = "#333",
        bringToFront = TRUE
      )
    ) %>%
    addLegend(
      pal = pal,
      values = ~pct_q516_agree_pct,
      title = "Agree (%)",
      position = "bottomright"
    )
}

make_wave_map("Wave V")

#Make map for each wave 

wave_list <- unique(survey_map_data$wave)

wave_maps <- lapply(wave_list, make_wave_map)
names(wave_maps) <- wave_list

wave_maps[["Wave II"]]
wave_maps[["Wave III"]]
wave_maps[["Wave IV"]]
wave_maps[["Wave V"]]
wave_maps[["Wave VI"]]
wave_maps[["Wave VII"]]
wave_maps[["Wave VIII"]]


#INteractive Map with changing waves

class(all_waves_summary)
class(map_df)
class(world)
class(mena_map)

map_data_df <- all_waves_summary %>%
  mutate(
    pct_q516_agree_pct = pct_q516_agree * 100
  )

class(map_data_df)

map_df_plotly <- map_data_df %>%
  mutate(
    country_plotly = case_when(
      country == "Palestine" ~ "Palestine",
      TRUE ~ country
    )
  )

fig <- plot_geo(map_df_plotly) %>%
  add_trace(
    type = "choropleth",
    locations = ~country_plotly,
    locationmode = "country names",
    z = ~pct_q516_agree_pct,
    frame = ~wave,
    ids = ~country_plotly,
    text = ~paste0(
      "<b>", country, "</b><br>",
      "Wave: ", wave, "<br>",
      "Period: ", year, "<br>",
      "Agree: ", round(pct_q516_agree_pct, 1), "%<br>",
      "N: ", observations_total
    ),
    hoverinfo = "text",
    colorscale = "Viridis_r",
    zmin = 50,
    zmax = 100,
    colorbar = list(title = "(Strongly) Agree (%)")
  ) %>%
  layout(
    title = list(
      text = "Democratic systems are better than other systems",
      y = 0.95
    ),
    margin = list(t = 60),
    geo = list(
      scope = "world",
      projection = list(type = "mercator"),
      fitbounds = "locations",
      showcountries = TRUE,
      showcoastlines = FALSE,
      showland = TRUE,
      landcolor = toRGB("gray95"),
      bgcolor = "white"
    )
  ) %>%
  animation_opts(
    frame = 1000,
    transition = 0,
    redraw = TRUE
  ) %>%
  animation_slider(
    currentvalue = list(prefix = "Wave: ")
  ) %>%
  animation_button(
    x = 1,
    xanchor = "right",
    y = 0,
    yanchor = "bottom"
  )

fig
map_df_plotly %>%
  count(wave)
write.csv(map_data_df, 
          "map_data_df.csv", 
          row.names = FALSE)

# Multiple line PLot 

df_plot <- map_data_df %>%
  mutate(
    year = factor(
      year,
      levels = c("2010-2011", "2012-2014", "2016-2017", "2018-2019", "2021-2022", "2023-2024")
    )
  ) %>%
  filter(!is.na(pct_q516_agree_pct))

last_points <- df_plot %>%
  arrange(country, year) %>%
  group_by(country) %>%
  slice_tail(n = 1) %>%
  ungroup()

ggplot(df_plot, aes(x = year, y = pct_q516_agree_pct, color = country, group = country)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  geom_text_repel(
    data = last_points,
    aes(label = country),
    direction = "y",
    hjust = 0,
    nudge_x = 0.2,
    show.legend = FALSE
  ) +
  labs(
    title = "Support for democracy across Arab Barometer waves",
    subtitle = "Share of respondents agreeing with Q516 by country",
    x = "Survey wave year",
    y = "Agreeing respondents (%)"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "none",
    plot.margin = margin(5.5, 80, 5.5, 5.5)
  ) +
  coord_cartesian(clip = "off")

