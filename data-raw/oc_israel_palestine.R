stop("This file should not be sourced!")

# Immigration Israel 1949 - 2017 ------------------------------------------

oc_israel_palestine_immigration_israel <- readr::read_csv(here::here("inst/extdata/cbs_israel/immigration.csv"))

usethis::use_data(oc_israel_palestine_immigration_israel, overwrite = T)

# Foreign population by origin --------------------------------------------

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
      country == "United States of America" ~ "United States of America and Puerto Rico",
      country == "India, Pakistan " ~ "India, Pakistan and Sri Lanka",
      TRUE ~ country
    )
  ) |>
  dplyr::mutate(
    continent = stringr::str_replace(continent, " - total", "")
  ) -> oc_israel_palestine_2008_population_nae

usethis::use_data(oc_israel_palestine_2008_population_nae, overwrite = T)

# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_oc_israel_palestine.R"))
