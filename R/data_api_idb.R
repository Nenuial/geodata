#' One year population pyramid data (legacy function)
#' @param country A string with the country name
#' @param year An integer with the year
#'
#' @return A dataframe with age, female, and male population
#'
#' @export
#' @examplesIf interactive()
#' # Not run: needs a valid IDB API key
#'
#' gdt_idb_pyramid_1y("Switzerland", 2020)
#'
gdt_idb_pyramid_1y <- function(country, year) {
  geotools::gtl_chk_idb_api_key()

  country_code <- countrycode::countrycode(
    country,
    origin = "country.name", destination = "iso2c",
    custom_match = c(
      "Gaza" = "XG",
      "Kosovo" = "XK",
      "West Bank" = "XW"
    )
  )

  gdt_idb_get(country = country_code, year = year, sex = "male") |>
    dplyr::mutate(pop = pop * -1) |>
    dplyr::select(age, male = pop) |>
    dplyr::left_join(
      gdt_idb_get(country = country_code, year = year, sex = "female") |>
        dplyr::select(age, female = pop),
      by = "age"
    ) |>
    dplyr::arrange(age)
}

#' One year population pyramid data (tidy)
#' @param country A string with the country name
#' @param year An integer with the year
#'
#' @return A dataframe with age, gender, and population
#'
#' @export
#' @examplesIf interactive()
#' # Not run: needs a valid IDB API key
#'
#' gdt_idb_pyramid("Switzerland", 2020)
#'
gdt_idb_pyramid <- function(country, year) {
  geotools::gtl_chk_idb_api_key()

  country_code <- countrycode::countrycode(
    country,
    origin = "country.name", destination = "iso2c",
    custom_match = c(
      "Gaza" = "XG",
      "Kosovo" = "XK",
      "West Bank" = "XW"
    )
  )

  gdt_idb_get(country = country_code, year = year, sex = "male") |>
    dplyr::mutate(pop = pop * -1) |>
    dplyr::select(age, male = pop) |>
    dplyr::left_join(
      gdt_idb_get(country = country_code, year = year, sex = "female") |>
        dplyr::select(age, female = pop),
      by = "age"
    ) |>
    tidyr::pivot_longer(-age, names_to = "gender", values_to = "population")
}

#' Return 5y population data
#'
#' @param country A string with the country name
#' @param year An integer with the year
#'
#' @return A dataframe
#' @export
#' @examplesIf interactive()
#' # Not run: needs a valid IDB API key
#'
#' gdt_idb_pyramid_5y("Switzerland", 2020)
#'
gdt_idb_pyramid_5y <- function(country, year) {
  geotools::gtl_chk_idb_api_key()

  country_code <- countrycode::countrycode(
    country,
    origin = "country.name", destination = "iso2c",
    custom_match = c(
      "Gaza" = "XG",
      "Kosovo" = "XK",
      "West Bank" = "XW"
    )
  )

  gdt_idb_get(
    country = country_code, year = year,
    concept = "Male midyear population by 5-year age groups"
  ) |>
    gdt_idb_tidy_5y_pyramid_data() -> male

  gdt_idb_get(
    country = country_code, year = year,
    concept = "Female midyear population by 5-year age groups"
  ) |>
    gdt_idb_tidy_5y_pyramid_data() -> female

  dplyr::bind_rows(male, female)
}

#' Cleanup 5y pyramid data
#'
#' @param df A get_idb dataframe
#'
#' @return A tidy dataframe
#' @keywords internal
gdt_idb_tidy_5y_pyramid_data <- function(df) {
  df |>
    tidyr::pivot_longer(
      -c("code", "year", "name"),
      names_to = c("gender", "cohort"),
      names_pattern = "([fm]pop)(.*)",
      values_to = "population"
    ) |>
    dplyr::mutate(
      gender = stringr::str_replace(gender, "fpop", "female"),
      gender = stringr::str_replace(gender, "mpop", "male"),
      cohort = stringr::str_replace(cohort, "_", "-"),
      cohort = stringr::str_replace(cohort, "100-", "100+")
    ) |>
    dplyr::mutate(
      sort = as.integer(stringr::str_extract(cohort, "^\\d{1,3}"))
    ) |>
    dplyr::arrange(sort)
}

#' Query the IDB API with retries and a disk cache
#'
#' Calls [idbr::get_idb()], or [gdt_idb_get_1y()] for the queries by sex and
#' age, and keeps the result in the user cache folder of geodata, so a query is
#' sent once per machine. When the API is temporarily unavailable (maintenance,
#' busy, timeout), the call is retried after 5, 15 and 45 seconds; any other
#' error is raised at once.
#'
#' @param ... Arguments passed to [idbr::get_idb()]
#'
#' @return The data frame returned by [idbr::get_idb()]
#' @keywords internal
gdt_idb_get <- function(...) {
  file <- file.path(gdt_idb_cache_dir(), paste0(rlang::hash(list(...)), ".rds"))
  if (file.exists(file)) {
    return(readRDS(file))
  }

  query <- if (is.null(list(...)$sex)) idbr::get_idb else gdt_idb_get_1y
  waits <- c(5, 15, 45)
  for (attempt in seq_len(length(waits) + 1)) {
    data <- tryCatch(query(...), error = identity)
    if (!inherits(data, "error")) break
    if (attempt > length(waits) || !gdt_idb_is_transient(data)) stop(data)
    rlang::inform(sprintf("The IDB API is unavailable, retrying in %d s.", waits[attempt]))
    Sys.sleep(waits[attempt])
  }

  # a cache that cannot be written only costs a new query next time
  try(
    {
      dir.create(dirname(file), recursive = TRUE, showWarnings = FALSE)
      saveRDS(data, file)
    },
    silent = TRUE
  )
  data
}

#' Query the one-year IDB API by sex and age
#'
#' Since November 2026 the one-year IDB API wants the country as a geography
#' (`for=genc standard countries and areas:CH`), which [idbr::get_idb()] 1.2
#' does not send. This function asks for the population by single year of age
#' and returns the same columns as [idbr::get_idb()].
#'
#' @param country An ISO 2 country code (GENC)
#' @param year The year
#' @param sex "male", "female" or "both"
#'
#' @return A tibble with code, year, name, pop, sex and age
#' @keywords internal
gdt_idb_get_1y <- function(country, year, sex) {
  key <- Sys.getenv("IDB_API")
  if (!nzchar(key)) key <- Sys.getenv("CENSUS_API_KEY")

  rows <- httr2::request("https://api.census.gov/data/timeseries/idb/1year") |>
    httr2::req_url_query(
      get = "NAME,POP",
      SEX = c(both = 0, male = 1, female = 2)[[sex]],
      YR = year,
      AGE = paste(0:100, collapse = ","),
      `for` = paste0("genc standard countries and areas:", country),
      key = key
    ) |>
    httr2::req_error(body = function(resp) httr2::resp_body_string(resp)) |>
    httr2::req_perform()
  # the API answers 204, without a body, when it has nothing for the query
  if (httr2::resp_status(rows) == 204) {
    rlang::abort(sprintf("The IDB has no data for %s in %s.", country, year))
  }
  rows <- httr2::resp_body_json(rows, simplifyVector = TRUE)

  colnames(rows) <- rows[1, ]
  rows <- rows[-1, , drop = FALSE]
  tibble::tibble(
    code = rows[, "genc standard countries and areas"],
    year = as.numeric(rows[, "YR"]),
    name = rows[, "NAME"],
    pop = as.numeric(rows[, "POP"]),
    sex = c("0" = "Both", "1" = "Male", "2" = "Female")[rows[, "SEX"]] |> unname(),
    age = as.numeric(rows[, "AGE"])
  )
}

#' Is an IDB error temporary?
#'
#' @param error An error condition from [idbr::get_idb()]
#'
#' @return `TRUE` when retrying could help
#' @keywords internal
gdt_idb_is_transient <- function(error) {
  grepl(
    "maintenance|busy|try again|timed? ?out|could not resolve|failed to connect|50[234]",
    conditionMessage(error),
    ignore.case = TRUE
  )
}

#' IDB cache folder
#'
#' @return The path of the folder holding the cached IDB queries
#' @keywords internal
gdt_idb_cache_dir <- function() {
  file.path(rappdirs::user_cache_dir("geodata"), "idb")
}

#' Clear the IDB cache
#'
#' The IDB queries are kept on disk, so the population pyramids don't depend on
#' the API at each render. Clear the cache when the Census Bureau publishes
#' revised figures.
#'
#' @return The number of cached queries removed, invisibly
#' @export
#'
#' @examples
#' gdt_idb_clear_cache()
gdt_idb_clear_cache <- function() {
  files <- list.files(gdt_idb_cache_dir(), pattern = "\\.rds$", full.names = TRUE)
  unlink(files)
  rlang::inform(sprintf("Removed %d cached IDB queries.", length(files)))
  invisible(length(files))
}
