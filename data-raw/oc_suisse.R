stop("This file should not be sourced!")

# Suffrage féminin -------------------------------------------------------

oc_suisse_suffrage_feminin <- readr::read_csv(here::here("inst/extdata/oc_suisse/misc/suffrage_feminin.csv"))

usethis::use_data(oc_suisse_suffrage_feminin, overwrite = TRUE)


# Votation suffrage féminin VS -------------------------------------------

oc_suisse_1970_04_12_suffrage_feminin_vs <- readr::read_csv(
  here::here("inst/extdata/oc_suisse/misc/1970-04-12_suffrage_feminin_vs.csv")
)

usethis::use_data(oc_suisse_1970_04_12_suffrage_feminin_vs, overwrite = TRUE)


# Immigration italienne 1981-2019 ----------------------------------------

tidyxl::xlsx_cells(
  here::here("inst/extdata/oc_suisse/ofs/population/px-x-0103010000_151_20210107-202901.xlsx"),
  check_filetype = TRUE
) |>
  dplyr::filter(
    row < 6,
    row > 2,
    !(col %in% c(2, 3))
  ) |>
  unpivotr::behead("W", name = "indicator") |>
  unpivotr::behead("N", name = "year", formatters = list(character = readr::parse_integer)) |>
  dplyr::select(indicator, year, data = numeric) |>
  tidyr::pivot_wider(names_from = "indicator", values_from = "data") |>
  dplyr::rename(population = 2, immigration = 3) -> oc_suisse_2021_immigration_italienne

usethis::use_data(oc_suisse_2021_immigration_italienne, overwrite = TRUE)


# Religion 2020 ----------------------------------------------------------

readr::read_csv("inst/extdata/oc_suisse/ofs/religion/religion_2000.csv") |>
  dplyr::rename(Commune = 1) |>
  dplyr::filter(stringr::str_detect(Commune, "\\.{6}")) |>
  tidyr::extract(Commune, into = c("ID", "Commune"), regex = "\\.{6}(\\d{4})\\s(.*)") |>
  dplyr::mutate(ID = readr::parse_integer(ID)) |>
  dplyr::rowwise() |>
  dplyr::mutate(Total = sum(dplyr::c_across(-c(ID, Commune)), na.rm = TRUE)) |>
  dplyr::mutate(dplyr::across(-c(ID, Commune), ~ round(. / Total * 100, 2))) |>
  dplyr::ungroup() |>
  tidyr::pivot_longer(-c(ID, Commune), names_to = "Religion", values_to = "Pourcentage") -> oc_suisse_2000_religion

usethis::use_data(oc_suisse_2000_religion, overwrite = TRUE)

# Open documentation file ------------------------------------------------

usethis::edit_file(here::here("R/data_doc_oc_suisse.R"))
