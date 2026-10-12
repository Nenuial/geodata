#' Demography data
#'
#' This function downloads the data for *population*, *crude birth rate* and *crude death rate*
#'
#' @param country A string with the country name or iso code
#'
#' @return A tibble with the requested data:
#' \describe{
#'   \item{population}{Total population}
#'   \item{birth_rate}{Crude Birth Rate (per mil)}
#'   \item{death_rate}{Crude Death Rate (per mil)}
#' }
#' @export
#' @examplesIf interactive()
#' gdt_wb_demo("Switzerland")
#'
gdt_wb_demo <- function(country) {
  wbstats::wb_data(
    country = country,
    start_date = "1960",
    end_date = format(Sys.Date(), "%Y"),
    indicator = c(
      population = "SP.POP.TOTL",
      birth_rate = "SP.DYN.CBRT.IN",
      death_rate = "SP.DYN.CDRT.IN"
    )
  )
}

#' Life expectancy data
#'
#' This function downloads the data for *total life expectancy*, *male life expectancy* and *female life expectancy*
#'
#' @param country A string with the country name or iso code
#'
#' @return A tibble with the requested data:
#' \describe{
#'   \item{lex}{Total life expectancy}
#'   \item{lex_male}{Male life expectancy}
#'   \item{lex_female}{Female life expectancy}
#' }
#' @export
#' @examplesIf interactive()
#' gdt_wb_lex("Switzerland")
#'
gdt_wb_lex <- function(country) {
  wbstats::wb_data(
    country = country,
    start_date = "1960",
    end_date = format(Sys.Date(), "%Y"),
    indicator = c(
      lex = "SP.DYN.LE00.IN",
      lex_male = "SP.DYN.LE00.MA.IN",
      lex_female = "SP.DYN.LE00.FE.IN"
    )
  )
}

#' Total fertility rate data
#'
#' This function downloads the *total fertility rate* (children per woman)
#' of one or more countries.
#'
#' @param countries A character vector of country names or iso codes
#' @param start The first year
#' @param end The last year (default: the current year)
#'
#' @return A tibble with the columns of `wbstats::wb_data()` and:
#' \describe{
#'   \item{tfr}{Total fertility rate (children per woman)}
#' }
#' @export
#' @examplesIf interactive()
#' gdt_wb_tfr(c("France", "Switzerland"))
#'
gdt_wb_tfr <- function(countries, start = 1960, end = format(Sys.Date(), "%Y")) {
  wbstats::wb_data(
    country = countries,
    start_date = start,
    end_date = end,
    indicator = c(tfr = "SP.DYN.TFRT.IN")
  )
}

#' Working-age population data
#'
#' This function downloads the population aged 15 to 64 of a country.
#'
#' @param country A string with the country name or iso code
#' @param start The first year
#' @param end The last year (default: the current year)
#'
#' @return A tibble with the columns of `wbstats::wb_data()` and:
#' \describe{
#'   \item{working_age}{Population aged 15 to 64}
#' }
#' @export
#' @examplesIf interactive()
#' gdt_wb_working_age("China")
#'
gdt_wb_working_age <- function(country, start = 1960, end = format(Sys.Date(), "%Y")) {
  wbstats::wb_data(
    country = country,
    start_date = start,
    end_date = end,
    indicator = c(working_age = "SP.POP.1564.TO")
  )
}

#' World population since year 0
#'
#' Historical estimates (`df_demography_population_historical`) until 1959,
#' then the World Bank's yearly estimates from 1960 to today.
#'
#' @param from The first year (default: year 0)
#'
#' @return A tibble:
#' \describe{
#'   \item{year}{The year}
#'   \item{population}{The world population}
#'   \item{source}{`historical` or `World Bank`}
#' }
#' @export
#' @examplesIf interactive()
#' gdt_world_population_history()
#'
gdt_world_population_history <- function(from = 0) {
  wb <- wbstats::wb_data(
    country = "WLD",
    start_date = 1960,
    end_date = format(Sys.Date(), "%Y"),
    indicator = c(population = "SP.POP.TOTL")
  )

  dplyr::bind_rows(
    geodata::df_demography_population_historical |>
      dplyr::filter(year >= from, year < 1960) |>
      dplyr::mutate(source = "historical"),
    wb |>
      dplyr::filter(!is.na(population)) |>
      dplyr::transmute(year = date, population, source = "World Bank")
  )
}
