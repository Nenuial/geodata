#' Get abortion rate from the Guttmacher Institute
#'
#' Average annual number of abortions per 1,000 women aged 15-49 for the
#' period 2015-2019. The Guttmacher API and Data Center were retired in
#' July 2025, the data now comes from the archived snapshot in
#' [oc_geo_au_feminin_gutt_abortion_rates].
#'
#' @return A tibble
#' @export
#' @examples
#' gdt_gutt_get_abortion_rates() |>
#'   head(5)
#'
gdt_gutt_get_abortion_rates <- function() {
  geodata::oc_geo_au_feminin_gutt_abortion_rates |>
    dplyr::select(country_id, abortion_rate, iso3)
}
