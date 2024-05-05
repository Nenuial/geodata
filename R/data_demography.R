#' General demographic informations
#'
#' @param country A country code
#' @param years The year for which the information is needed
#'
#' @return A tibble
#' @export
#' @examples
#' gdt_table_demography("Switzerland", 2020)
#'
gdt_table_demography <- function(country, years) {
  start <- min(years)
  end <- max(years)
  indicator_values <- c(
    pop = "Population (total)",
    cbr = geotools::gtl_translate_enfr("Crude birth rate (\u2030)", "Taux de natalit\u00e9 (\u2030)"),
    cdr = geotools::gtl_translate_enfr("Crude death rate (\u2030)", "Taux de mortalit\u00e9 (\u2030)"),
    rni = geotools::gtl_translate_enfr("Rate of natural increase (\u2030)", "Taux d'accroissement (\u2030)"),
    imr = geotools::gtl_translate_enfr("Infant mortality rate (\u2030)", "Taux de mortalit\u00e9 infantile (\u2030)"),
    tfr = geotools::gtl_translate_enfr("Total fertility rate", "Indice de f\u00e9condit\u00e9"),
    lex = geotools::gtl_translate_enfr("Life expectancy", "Esp\u00e9rance de vie"),
    lem = geotools::gtl_translate_enfr("- male", "- hommes"),
    lef = geotools::gtl_translate_enfr("- female", "- femmes")
  )
  indicator_name <- geotools::gtl_translate_enfr("Indicator", "Indicateur")

  wbstats::wb_data(
    indicator = c(
      "1-pop" = "SP.POP.TOTL",
      "2-cbr" = "SP.DYN.CBRT.IN",
      "3-cdr" = "SP.DYN.CDRT.IN",
      "5-imr" = "SP.DYN.IMRT.IN",
      "6-tfr" = "SP.DYN.TFRT.IN",
      "7-lex" = "SP.DYN.LE00.IN",
      "8-lem" = "SP.DYN.LE00.MA.IN",
      "9-lef" = "SP.DYN.LE00.FE.IN"
    ),
    country = country,
    start_date = start,
    end_date = end
  ) |>
    dplyr::filter(date %in% years) |>
    dplyr::mutate("4-rni" = `2-cbr` - `3-cdr`) |>
    dplyr::select(-c(iso2c, iso3c, country)) |>
    tidyr::pivot_longer(-date, names_to = "indicator", values_to = "data") |>
    tidyr::pivot_wider(
      id_cols = tidyselect::everything(),
      names_from = "date", values_from = "data"
    ) |>
    dplyr::arrange(indicator) |>
    dplyr::mutate(indicator = stringr::str_remove(indicator, "\\d-")) |>
    dplyr::mutate(indicator = stringr::str_replace_all(indicator,
      pattern = names(indicator_values),
      replacement = indicator_values
    )) |>
    dplyr::rename({{ indicator_name }} := indicator)
}
