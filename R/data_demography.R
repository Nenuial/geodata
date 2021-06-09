#' Get general demographic informations
#'
#' @param country A country code
#' @param years The year for which the information is needed
#'
#' @return A tibble
#' @export
gdt_table_demography <- function(country, years) {
  start <- min(years)
  end <- max(years)
  indicator_values <- c(
    pop = "Population (total)",
    cbr = geotools::translate_enfr("Crude birth rate (‰)", "Taux de natalité (‰)"),
    cdr = geotools::translate_enfr("Crude death rate (‰)", "Taux de mortalité (‰)"),
    rni = geotools::translate_enfr("Rate of natural increase (‰)", "Taux d'accroissement (‰)"),
    imr = geotools::translate_enfr("Infant mortality rate (‰)", "Taux de mortalité infantile (‰)"),
    tfr = geotools::translate_enfr("Total fertility rate", "Indice de fécondité"),
    lex = geotools::translate_enfr("Life expectancy", "Espérance de vie"),
    lem = geotools::translate_enfr("- male", "- hommes"),
    lef = geotools::translate_enfr("- female", "- femmes")
  )
  indicator_name <- geotools::translate_enfr("Indicator", "Indicateur")

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
  ) %>%
    dplyr::filter(date %in% years) %>%
    dplyr::mutate("4-rni" = `2-cbr` - `3-cdr`) %>%
    dplyr::select(-c(iso2c, iso3c, country)) %>%
    tidyr::pivot_longer(-date, names_to = "indicator", values_to = "data") %>%
    tidyr::pivot_wider(tidyselect::everything(), names_from = "date", values_from = "data") %>%
    dplyr::arrange(indicator) %>%
    dplyr::mutate(indicator = stringr::str_remove(indicator, "\\d-")) %>%
    dplyr::mutate(indicator = stringr::str_replace_all(indicator, pattern = names(indicator_values),
                                                       replacement = indicator_values)) %>%
    dplyr::rename({{ indicator_name }} := indicator)
}

#' Get life expectancy from the Human Mortality Database
#'
#' @param countries A list of country names
#' @param age The life expectancy age
#' @param type The type (one of `male`, `female` or `total`)
#'
#' @return A tibble with 3 columns: `year`, `country` and `lex`
#' @export
gdt_hmd_lex <- function(countries, age, type = c("male", "female", "total")) {
  type <- match.arg(type)

  countries %>%
    purrr::map(
      .f = ~gdt_hmd_lex_clean(.x, age, type)
    ) %>%
    purrr::reduce(
      .f = ~dplyr::inner_join(.x, .y, by = "year")
    ) %>%
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

  lexdata %>%
    as.data.frame() %>%
    tibble::as_tibble(rownames = "year") %>%
    dplyr::rename({{ label }} := x) %>%
    dplyr::mutate(year = readr::parse_number(year))
}

