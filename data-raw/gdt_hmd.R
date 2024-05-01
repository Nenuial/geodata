stop("This file should not be sourced!")

# Cleanup the data that has multiple age rows
clean_summary <- function(data, type) {
  data |>
    dplyr::mutate(Year = as.numeric(Year)) |>
    dplyr::select(-Age) |>
    dplyr::group_by(Year) |>
    dplyr::summarise_all(~sum(., na.rm = TRUE)) |>
    dplyr::rename_at(dplyr::vars(-Year), ~glue::glue("{.}_{type}"))
}

# Fetch data from HDM website and cleanup
cleanup <- function(code) {
  geodata::gdt_hmd_birth_raw(code) |>
    dplyr::mutate(Year = as.numeric(Year)) |>
    dplyr::rename_at(dplyr::vars(-Year), ~glue::glue("{.}_birth")) -> birth

  geodata::gdt_hmd_death_raw(code) |>
    clean_summary("death") -> death

  geodata::gdt_hmd_population_raw(code) |>
    clean_summary("population") -> population

  population |>
    dplyr::full_join(birth, by = "Year") |>
    dplyr::full_join(death, by = "Year") |>
    dplyr::mutate_at(dplyr::vars(-c("Year")), floor) |>
    dplyr::select(Year, contains("Total")) |>
    tidyr::drop_na(Year, Total_population) |>
    dplyr::mutate(
      CBR = round(Total_birth / Total_population * 1000, digits = 2),
      CDR = round(Total_death / Total_population * 1000, digits = 2)
    ) |>
    dplyr::mutate(Code = code) |>
    dplyr::select(Code, Year, Population = Total_population, CBR, CDR)
}

geotools::gtl_hmd_codes() |>
  dplyr::pull("code") |>
  purrr::map_df(cleanup) -> gdt_hmd_demography

usethis::use_data(gdt_hmd_demography, overwrite = TRUE)

# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_demography.R"))
