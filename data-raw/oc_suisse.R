# Suffrage féminin --------------------------------------------------------

oc_suisse_suffrage_feminin <- readr::read_csv(here::here("inst/extdata/oc_suisse/misc/suffrage_feminin.csv"))

usethis::use_data(oc_suisse_suffrage_feminin, overwrite = T)


# Votation suffrage féminin VS --------------------------------------------

oc_suisse_1970_04_12_suffrage_feminin_vs <- readr::read_csv(here::here("inst/extdata/oc_suisse/misc/1970-04-12_suffrage_feminin_vs.csv"))

usethis::use_data(oc_suisse_1970_04_12_suffrage_feminin_vs, overwrite = T)


# Immigration italienne 1981-2019 -----------------------------------------

tidyxl::xlsx_cells(
  here::here("inst/extdata/oc_suisse/ofs/population/px-x-0103010000_151_20210107-202901.xlsx"),check_filetype = T
) %>%
  dplyr::filter(
    row < 6,
    row > 2,
    !(col %in% c(2,3))
  ) %>%
  unpivotr::behead("W", name = "indicator") %>%
  unpivotr::behead("N", name = "year", formatters = list(character = readr::parse_integer)) %>%
  dplyr::select(indicator, year, data = numeric) %>%
  tidyr::pivot_wider(names_from = "indicator", values_from = "data") %>%
  dplyr::rename(population = 2, immigration = 3) -> oc_suisse_2021_immigration_italienne

usethis::use_data(oc_suisse_2021_immigration_italienne, overwrite = T)


# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_oc_suisse.R"))
