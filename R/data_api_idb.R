#' One year population pyramid data (legacy function)
#' @param country A FIPS code for the country
#' @param year An integer with the year
#'
#' @return A dataframe with age, female, and male population
#'
#' @export
gdt_idb_pyramid_1y <- function(country, year) {
  util_chk_idb_api_key()

  country_code <- countrycode::countrycode(country, origin = "fips", destination = "iso2c")

  idbr::get_idb(country = country_code, year = year, sex = "male") |>
    dplyr::mutate(pop = pop * -1) |>
    dplyr::select(age, male = pop) |>
    dplyr::left_join(
      idbr::get_idb(country = country_code, year = year, sex = "female") |>
        dplyr::select(age, female = pop),
      by = "age"
    ) |>
    dplyr::arrange(age)
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

  country_code <- countrycode::countrycode(country, origin = "country.name", destination = "iso2c")

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

#' Return 5y population data
#'
#' @return
#' @export
#'
#' @examples
gdt_idb_pyramid_5y <- function(country, year) {
  util_chk_idb_api_key()

  idbr::get_idb(country = country, year = year,
                concept = "Male midyear population by 5-year age groups") |>
    gdt_idb_tidy_5y_pyramid_data() -> male

  idbr::get_idb(country = country, year = year,
                concept = "Female midyear population by 5-year age groups") |>
    gdt_idb_tidy_5y_pyramid_data() -> female

  dplyr::bind_rows(male, female)
}

#' Cleanup 5y pyramid data
#'
#' @param df A get_idb dataframe
#'
#' @return A tidy dataframe
#' @keywords internal
gdt_idb_tidy_5y_pyramid_data <- function(df) {
  df |>
    tidyr::pivot_longer(
      -c("code", "year", "name"),
      names_to = c("gender", "cohort"),
      names_pattern = "([fm]pop)(.*)",
      values_to = "population"
    ) |>
    dplyr::mutate(
      gender = stringr::str_replace(gender, "fpop", "female"),
      gender = stringr::str_replace(gender, "mpop", "male"),
      cohort = stringr::str_replace(cohort, "_", "-"),
      cohort = stringr::str_replace(cohort, "100-", "100+")
    ) |>
    dplyr::mutate(
      sort = as.integer(stringr::str_extract(cohort, "^\\d{1,3}"))
    ) |>
    dplyr::arrange(sort)

}
