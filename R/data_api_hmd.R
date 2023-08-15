#' Get mortality table from Human Mortality Database
#'
#' @param country A string with the country name
#'
#' @return A demogdata object
#' @export
gdt_hmd_mortality <- function(country) {
  destination_code <- geotools::gtl_opt_short_language(valid = c("en", "fr", "ar", "es", "ru", "zh"))

  gdt_hmd_mx_cached(
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
gdt_hmd_e0_table <- function(country) {
  gdt_hmd_e0_cached(
    country = countrycode::countrycode(country, "country.name", "iso3c"),
    username = keyring::key_list(service = "mortality.org")[["username"]],
    password = keyring::key_get(service = "mortality.org")
  ) -> data

  from <- attr(data, "tsp")[[1]]

  data |>
    tibble::as_tibble(rownames = "year") |>
    dplyr::mutate(year = as.numeric(year) + from - 1)
}
