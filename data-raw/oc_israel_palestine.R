stop("This file should not be sourced!")

# Immigration Israel 1949 - 2017 -------------------------------------------------------------

oc_israel_palestine_immigration_israel <- readr::read_csv(here::here("inst/extdata/cbs_israel/immigration.csv"))

usethis::use_data(oc_israel_palestine_immigration_israel, overwrite = T)

# Foreign population by origin ---------------------------------------------------------------

xls <- here::here("inst/extdata/cbs_israel/2008_population_born_abroad.xlsx")
fbp <- tidyxl::xlsx_cells(xls)
fbp_format <- tidyxl::xlsx_formats(xls)
bold <- fbp_format$local$font$bold

fbp |>
  dplyr::filter(row >= 10) |>
  dplyr::filter(col %in% c(2, 24)) |>
  unpivotr::behead_if(
    bold[local_format_id],
    direction = "right-up",
    name = "continent"
  ) |>
  unpivotr::behead("right", name = "country") |>
  dplyr::select(country, continent, population = numeric) |>
  tidyr::drop_na() |>
  dplyr::mutate(population = population * 100) |>
  dplyr::mutate(
    country = dplyr::case_when(
      country == "United States of America" ~ "USA and Puerto Rico",
      country == "India, Pakistan " ~ "India, Pakistan and Sri Lanka",
      TRUE ~ country
    )
  ) |>
  dplyr::mutate(
    continent = stringr::str_replace(continent, " - total", "")
  ) -> oc_israel_palestine_2008_population_nae

usethis::use_data(oc_israel_palestine_2008_population_nae, overwrite = T)


# Jewish immigration before 1948 --------------------------------------------------------------

tibble::tribble(
  ~period, ~immigration,
  "1882 - 1903", 25000,
  "1904 - 1914", 40000,
  "1919 - 1923", 35000,
  "1924 - 1931", 80000,
  "1932 - 1939", 200000,
  "1939 - 1945", 70000
) -> oc_israel_palestine_immigration_juive_avant_1948

usethis::use_data(oc_israel_palestine_immigration_juive_avant_1948, overwrite = T)

# Open documentation file ---------------------------------------------------------------------

usethis::edit_file(here::here("R/data_doc_oc_israel_palestine.R"))
