# UN WPP Period estimates -------------------------------------------------

readr::read_csv("inst/extdata/unwpp/WPP2019_Period_Indicators_Medium.csv") -> un_wpp_2019_period_estimates

usethis::use_data(un_wpp_2019_period_estimates, overwrite = TRUE)


# WPP IDB World population estimates --------------------------------------
# Historical
# https://www.census.gov/data/tables/time-series/demo/international-programs/historical-est-worldpop.html
#
# World Population Growth
# It's fucking complicated… But data can be *manually* scraped here
# https://www.census.gov/data-tools/demo/idb/
#
# Forecasts
# See WPP (package wpp2019)

data_path <- here::here("inst/extdata/df_demography/wpp_idb_world_population.xlsx")
df_demography_population_growth <- readxl::read_excel(data_path, sheet = "uscb_growth")
df_demography_population_historical <- readxl::read_excel(data_path, sheet = "uscb_historical")
df_demography_population_current <- readxl::read_excel(data_path, sheet = "uscb_current")
df_demography_population_estimates <- readxl::read_excel(data_path, sheet = "un_estimates")

df_demography_population_historical |>
  dplyr::bind_rows(df_demography_population_current) -> df_demography_population_historical

df_demography_population_estimates |>
  tidyr::pivot_longer(-year, names_to = "estimate", values_to = "population") -> df_demography_population_estimates

usethis::use_data(df_demography_population_growth, overwrite = TRUE)
usethis::use_data(df_demography_population_historical, overwrite = TRUE)
usethis::use_data(df_demography_population_estimates, overwrite = TRUE)

# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_df_demography.R"))
