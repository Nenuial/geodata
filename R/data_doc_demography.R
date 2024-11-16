#' HMD Demography indicators
#'
#' A table with demography indicators
#' for all HDM countries (see `geotools::gtl_hmd_codes()`)
#'
#' @format A tibble with 5 columns and 4709 rows
#' \describe{
#'   \item{Code}{The HMD country code}
#'   \item{Year}{The year}
#'   \item{Population}{The population}
#'   \item{CBR}{Crude Birth Rate}
#'   \item{CDR}{Crude Death Rate}
#' }
#' @source <https://www.mortality.org/>
"gdt_hmd_demography"

#' HMD Demography indicators
#'
#' A table with demography indicators
#' for all HDM countries (see `geotools::gtl_hmd_codes()`)
#'
#' @format A tibble with 7 columns and 206824 rows
#' \describe{
#'   \item{iso3}{The ISO3 country code}
#'   \item{country}{The country}
#'   \item{hdicode}{The 2022 HDI quartile}
#'   \item{indicator}{The HDR indicator}
#'   \item{value}{The value}
#' }
#' @source <https://www.mortality.org/>
"gdt_un_hdr_composite"
