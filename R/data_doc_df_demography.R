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

#' DF Demography: World population period estimates 2019
#'
#' A table with the UN World Population Projections
#'
#' @format A tibble with 25 columns and 14940 rows
#' \describe{
#'   \item{LocID}{Location ID}
#'   \item{Location}{Location}
#'   \item{VarID}{Variant ID}
#'   \item{Variant}{Variant}
#'   \item{Time}{Period}
#'   \item{MidPeriod}{Middle of the period}
#'   \item{TFR}{Total fertility (live births per woman)}
#'   \item{NRR}{Net reproduction rate (surviving daughters per woman)}
#'   \item{CBR}{Crude birth rate (births per 1,000 population)}
#'   \item{Births}{Number of births, both sexes combined (thousands)}
#'   \item{LEx}{Life expectancy at birth for both sexes combined (years)}
#'   \item{LExMale}{Male life expectancy at birth (years)}
#'   \item{LExFemale}{Female life expectancy at birth (years)}
#'   \item{IMR}{Infant mortality rate, q(1), for both sexes combined (infant deaths per 1,000 live births)}
#'   \item{Q5}{Under-five mortality, 5q0, for both sexes combined (deaths under age five per 1,000 live births)}
#'   \item{CDR}{Crude death rate (deaths per 1,000 population)}
#'   \item{Deaths}{Number of deaths, both sexes combined (thousands)}
#'   \item{DeathsMale}{Number of male deaths (thousands)}
#'   \item{DeathsFemale}{Number of female deaths (thousands)}
#'   \item{CNMR}{Net migration rate (per 1,000 population)}
#'   \item{NetMigrations}{Net number of migrants, both sexes combined (thousands)}
#'   \item{GrowthRate}{Average annual rate of population change (percentage)}
#'   \item{NatIncr}{Rate of natural increase (per 1,000 population)}
#'   \item{SRB}{Sex ratio at birth (male births per female births)}
#'   \item{MAC}{Female mean age of childbearing (years)}
#' }
#' @source <https://population.un.org/wpp2019/Download/Standard/Population/>
"un_wpp_2019_period_estimates"
