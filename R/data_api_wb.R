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
#' @examples
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
#' @examples
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
