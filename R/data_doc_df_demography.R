#' DF Demography: Population growth
#'
#' A table with population growth.
#' Data was manually scraped…
#'
#' @format A tibble with 2 columns and 66 rows
#' \describe{
#'   \item{year}{The year}
#'   \item{growth}{The growth rate in percent}
#' }
#' @source <https://www.census.gov/data-tools/demo/idb/>
"df_demography_population_growth"

#' DF Demography: Historical world population
#'
#' A table with historical world population numbers.
#'
#' @format A tibble with 2 columns and 105 rows
#' \describe{
#'   \item{year}{The year}
#'   \item{growth}{The world population estimate}
#' }
#' @source <https://www.census.gov/data/tables/time-series/demo/international-programs/historical-est-worldpop.html>
"df_demography_population_historical"

#' DF Demography: World population projections
#'
#' A table with the UN World Population Projections
#'
#' @format A tibble with 3 columns and 258 rows
#' \describe{
#'   \item{year}{The year}
#'   \item{growth}{The UN WPP scenario (one of `low`, `medium` or `high`)}
#'   \item{population}{The population estimate}
#' }
#' @source wpp2019 rstat package
"df_demography_population_estimates"
