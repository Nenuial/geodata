#' Get mortality table from Human Mortality Database
#'
#' Fetches the mortality table from the HMD database. This function
#' needs valid credentials for HMD stored using the
#' {[keyring](https://keyring.r-lib.org)} package under a service
#' labelled *mortality.org*.
#'
#' @param country A string with the country name
#'
#' @return A demogdata object
#' @export
#' @examplesIf interactive()
#' # This example isn't run because it
#' # would need HMD credentials
#'
#' gdt_hmd_mortality("France")
gdt_hmd_mortality <- function(country) {
  destination_code <- geotools::gtl_opt_short_language(valid = c("en", "fr", "ar", "es", "ru", "zh"))

  demography::hmd.mx(
    country = countrycode::countrycode(country, "country.name", "iso3c"),
    label = countrycode::countrycode(country, "country.name", paste0("un.name.", destination_code)),
    username = keyring::key_list(service = "mortality.org")[["username"]],
    password = keyring::key_get(service = "mortality.org")
  )
}

#' Get life expectancy table from Human Mortality Database
#'
#' @param country A string with the country name
#'
#' @return A tibble
#' @export
#' @examplesIf interactive()
#' # This example isn't run because it
#' # would need HMD credentials
#'
#' gdt_hmd_e0_table("Switzerland")
gdt_hmd_e0_table <- function(country) {
  demography::hmd.e0(
    country = countrycode::countrycode(country, "country.name", "iso3c"),
    username = keyring::key_list(service = "mortality.org")[["username"]],
    password = keyring::key_get(service = "mortality.org")
  ) -> data

  from <- attr(data, "tsp")[[1]]

  data |>
    tibble::as_tibble(rownames = "year") |>
    dplyr::mutate(year = as.numeric(year) + from - 1)
}


#' Get life expectancy from the Human Mortality Database
#'
#' @param countries A vector of country names
#' @param age The life expectancy age
#' @param type The type (one of `male`, `female` or `total`)
#'
#' @return A tibble with 3 columns: `year`, `country` and `lex`
#' @export
#' @examplesIf interactive()
#' # This example isn't run because it
#' # would need HMD credentials
#' c("Switzerland", "France") |>
#'   gdt_hmd_lex(age = 65, type = "total") |>
#'   head(5)
#'
gdt_hmd_lex <- function(countries, age, type = c("male", "female", "total")) {
  type <- match.arg(type)

  countries |>
    purrr::map(
      .f = ~ gdt_hmd_lex_clean(.x, age, type)
    ) |>
    purrr::reduce(
      .f = ~ dplyr::inner_join(.x, .y, by = "year")
    ) |>
    tidyr::pivot_longer(-year, names_to = "country", values_to = "lex")
}

#' Get clean tibble for LEX data
#'
#' @param country The country name
#' @param age The life expectancy age
#' @param type The type (one of `male`, `female` or `total`)
#'
#' @return A tibble
#' @keywords internal
gdt_hmd_lex_clean <- function(country, age, type) {
  demodata <- gdt_hmd_mortality(country)
  lexdata <- demography::life.expectancy(demodata, age = age, series = type)
  label <- demodata$label

  lexdata |>
    as.data.frame() |>
    tibble::as_tibble(rownames = "year") |>
    dplyr::rename({{ label }} := x) |>
    dplyr::mutate(year = readr::parse_number(year))
}

#' HMD raw births data
#'
#' @param country Country code
#'
#' @return A dataframe
#' @export
#' @examplesIf interactive()
#' # This example isn't run because it
#' # would need HMD credentials
#' gdt_hmd_birth_raw("CHE") |>
#'   head(5)
#'
gdt_hmd_birth_raw <- function(country) {
  gdt_hmd_download(country, "Births")
}

#' HMD raw population data
#'
#' @param country Country code
#'
#' @return A dataframe
#' @export
#' @examplesIf interactive()
#' # This example isn't run because it
#' # would need HMD credentials
#' gdt_hmd_population_raw("CHE") |>
#'   head(5)
#'
gdt_hmd_population_raw <- function(country) {
  gdt_hmd_download(country, "Population")
}

#' HMD raw death data
#'
#' @param country Country code
#'
#' @return A dataframe
#' @export
#' @examplesIf interactive()
#' # This example isn't run because it
#' # would need HMD credentials
#' gdt_hmd_death_raw("CHE") |>
#'   head(5)
#'
gdt_hmd_death_raw <- function(country) {
  gdt_hmd_download(country, "Deaths_1x1")
}

#' Download HMD data
#' Function to download and read HDM data into a dataframe
#'
#' @param country Country code
#' @param indicator String indicating the indicator to download (usually one of `Population`, `Births` or `Death_1x1`)
#'
#' @return A dataframe
#'
#' @keywords internal
gdt_hmd_download <- function(country, indicator) {
  url <- paste0(
    "https://www.mortality.org/hmd/",
    country, "/STATS/", indicator, ".txt"
  )
  credentials <- paste0(
    keyring::key_list("mortality.org")[["username"]],
    ":", keyring::key_get("mortality.org")
  )

  RCurl::getURL(
    url = url,
    userpwd = credentials
  ) |>
    textConnection() |>
    utils::read.table(
      skip = 2, header = TRUE,
      na.strings = "."
    )
}
