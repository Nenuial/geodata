#' One year population pyramid data (legacy function)
#' @param country A FIPS code for the country
#' @param year An integer with the year
#'
#' @return A dataframe with age, female, and male population
#'
#' @export
gdt_idb_pyramid_1y <- function(country, year) {
  util_chk_idb_api_key()

  idbr::get_idb(country = country, year = year, sex = "male") |>
    dplyr::mutate(pop = pop * -1) |>
    dplyr::select(age, male = pop) |>
    dplyr::left_join(
      idbr::get_idb(country = country, year = year, sex = "female") |>
        dplyr::select(age, female = pop),
      by = "age"
    ) |>
    dplyr::arrange(dplyr::desc(age))
}

#' Five year population pyramid data (legacy function)
#' @param country A FIPS code for the country
#' @param year An integer with the year
#'
#' @return A dataframe with age, female, and male population
#'
#' @export
gdt_idb_pyramid_5y<- function(country, year) {
  util_chk_idb_api_key()

  idbr::idb5(country, toString(year),
             concept = "Female midyear population by 5-year age groups") %>%
    dplyr::select(tidyselect::contains("FPOP")) %>%
    tidyr::pivot_longer(tidyselect::everything(),
                        names_to = "age", names_pattern = "FPOP(.*)",
                        values_to = "female") -> female

  idbr::idb5(country, toString(year),
             concept = "Male midyear population by 5-year age groups") %>%
    dplyr::select(tidyselect::contains("MPOP")) %>%
    tidyr::pivot_longer(tidyselect::everything(),
                        names_to = "age", names_pattern = "MPOP(.*)",
                        values_to = "male") -> male

  population <- dplyr::left_join(male, female, by = "age") %>%
    dplyr::mutate(order = as.numeric(stringr::str_extract(age, "(^[\\d]*)")),
                  age = stringr::str_replace(age, "_", "-"),
                  age = stringr::str_replace(age, "100-", "100+")) %>%
    dplyr::arrange(dplyr::desc(order)) %>%
    dplyr::select(-order)

  return(population)
}

#' One year population pyramid data (tidy)
#' @param country A string with the country name
#' @param year An integer with the year
#'
#' @return A dataframe with age, gender, and population
#'
#' @export
gdt_idb_pyramid <- function(country, year) {
  util_chk_idb_api_key()

  country_code <- countrycode::countrycode(country, origin = "country.name", destination = "fips")

  idbr::get_idb(country = country_code, year = year, sex = "male") %>%
    dplyr::mutate(pop = pop * -1) %>%
    dplyr::select(age, male = pop) %>%
    dplyr::left_join(
      idbr::get_idb(country = country_code, year = year, sex = "female") %>%
        dplyr::select(age, female = pop),
      by = "age"
    ) %>%
    tidyr::pivot_longer(-age, names_to = "gender", values_to = "population")
}
