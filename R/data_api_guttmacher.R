#' Get abortion rate from the Guttmacher API
#'
#' @return A tibble
#' @export
#' @examples
#' gdt_gutt_get_abortion_rates() |>
#'   head(5)
#'
gdt_gutt_get_abortion_rates <- function() {
  url <- "https://api.guttmacher.org/measure/data/729"

  url |>
    httr2::request() |>
    httr2::req_perform() |>
    httr2::resp_body_json() -> data

  data |>
    purrr::pluck("response", "data") |>
    purrr::transpose() |>
    tibble::as_tibble() |>
    dplyr::select(country_id, abortion_rate = datum) |>
    dplyr::filter(country_id != "NULL") |>
    dplyr::mutate(
      country_id = as.character(country_id),
      abortion_rate = as.numeric(abortion_rate)
    ) |>
    dplyr::mutate(
      iso3 = countrycode::countrycode(country_id, "iso2c", "iso3c")
    )
}
