#' UN World Population Prospects 2024: demographic indicators
#'
#' The demographic indicators of the medium variant of the World Population
#' Prospects 2024 (estimates to 2023, projections from 2024 to 2100): population,
#' growth, births, deaths, CBR, CDR, TFR, life expectancy… for countries and
#' regions. Populations, births and deaths are in thousands.
#'
#' The CSV file (17 MB) is downloaded once into the user cache folder of geodata.
#'
#' @param countries ISO3 codes of the countries (`NULL` for all countries and regions)
#' @param years Years (`NULL` for all years)
#'
#' @return A tibble with the columns of the UN file (`ISO3_code`, `Location`, `Time`, `TFR`, `LEx`…)
#' @source United Nations, World Population Prospects 2024
#'   (<https://population.un.org/wpp/>), CC BY 3.0 IGO
#' @export
#' @examplesIf interactive()
#' # Not run: downloads 17 MB the first time
#'
#' gdt_wpp_indicators(c("CHE", "RUS"), 2000:2023)
#'
gdt_wpp_indicators <- function(countries = NULL, years = NULL) {
  gdt_wpp_download("WPP2024_Demographic_Indicators_Medium.csv.gz") |>
    gdt_wpp_read(countries, years)
}

#' UN World Population Prospects 2024: population by single age and sex
#'
#' The population on 1 July by single year of age (0 to 100+) and sex, medium
#' variant of the World Population Prospects 2024, in thousands. The estimates
#' (1950 to 2023) and the projections (2024 to 2100) are two CSV files of about
#' 65 MB each, downloaded once into the user cache folder of geodata; only those
#' needed for `years` are downloaded.
#'
#' @param countries ISO3 codes of the countries (`NULL` for all countries and regions)
#' @param years Years (`NULL` for all years)
#'
#' @return A tibble with the columns of the UN file (`ISO3_code`, `Location`,
#'   `Time`, `AgeGrp`, `AgeGrpStart`, `PopMale`, `PopFemale`, `PopTotal`…)
#' @source United Nations, World Population Prospects 2024
#'   (<https://population.un.org/wpp/>), CC BY 3.0 IGO
#' @export
#' @examplesIf interactive()
#' # Not run: downloads 62 MB the first time
#'
#' gdt_wpp_single_age("CHE", 2023)
#'
gdt_wpp_single_age <- function(countries = NULL, years = NULL) {
  files <- c(
    "WPP2024_PopulationBySingleAgeSex_Medium_1950-2023.csv.gz",
    "WPP2024_PopulationBySingleAgeSex_Medium_2024-2100.csv.gz"
  )
  needed <- c(is.null(years) || any(years <= 2023), is.null(years) || any(years >= 2024))

  files[needed] |>
    purrr::map(\(file) gdt_wpp_read(gdt_wpp_download(file), countries, years)) |>
    dplyr::bind_rows()
}

#' Download a WPP 2024 file into the cache
#'
#' @param file The name of the CSV file on the UN site
#'
#' @return The path of the cached file
#' @keywords internal
gdt_wpp_download <- function(file) {
  path <- file.path(rappdirs::user_cache_dir("geodata"), "wpp", file)
  if (file.exists(path)) {
    return(path)
  }

  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  rlang::inform(sprintf("Downloading %s from the UN (once).", file))
  # into a temporary file first: an interrupted download leaves no partial file in the cache
  tmp <- paste0(path, ".part")
  on.exit(unlink(tmp))
  httr2::request("https://population.un.org/wpp/assets/Excel%20Files/1_Indicator%20(Standard)/CSV_FILES") |>
    httr2::req_url_path_append(file) |>
    httr2::req_retry(max_tries = 3) |>
    httr2::req_timeout(600) |>
    httr2::req_perform(path = tmp)
  file.rename(tmp, path)

  path
}

#' Read a WPP 2024 file
#'
#' @param path The path of the CSV file
#' @param countries ISO3 codes (`NULL` for all)
#' @param years Years (`NULL` for all)
#'
#' @return A tibble
#' @keywords internal
gdt_wpp_read <- function(path, countries, years) {
  # the text columns of the file (AgeGrp only in the single-age files: "100+")
  header <- names(readr::read_csv(path, n_max = 0, show_col_types = FALSE))
  text <- intersect(
    c("Notes", "ISO3_code", "ISO2_code", "SDMX_code", "LocTypeName", "Location", "Variant", "AgeGrp"),
    header
  )
  types <- rlang::set_names(rep("c", length(text)), text)

  data <- readr::read_csv(
    path,
    col_types = do.call(readr::cols, c(list(.default = readr::col_double()), as.list(types))),
    progress = FALSE
  )
  if (!is.null(countries)) data <- dplyr::filter(data, ISO3_code %in% countries)
  if (!is.null(years)) data <- dplyr::filter(data, Time %in% years)

  data
}
