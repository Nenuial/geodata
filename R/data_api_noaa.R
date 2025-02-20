#' Retrieve climate data
#'
#' Retrieve climate data from the rnoaa::ncdc NOAA API and compute averages over the
#' time period 1990-2019.
#'
#' @param data_type The type of data needed. Must be one of *temperature*
#'   or *precipitation*.
#' @param location_id The ID for the weather station.
#'
#' @return A vector with climate data (precipitation or temperature) for each month
#' @export
#' @examplesIf interactive()
#' # Not run: needs a valid NOAA API key
#' gdt_noaa_climate_data("CITY:SZ000003")
#'
gdt_noaa_climate_data <- function(location_id, data_type = c("temperature", "precipitation")) {
  rlang::arg_match(data_type)

  data_id <- dplyr::case_when(
    data_type == "temperature" ~ "MNTM",
    data_type == "precipitation" ~ "TPCP"
  )

  out <- rnoaa::ncdc(
    datasetid = "GHCNDMS", locationid = location_id, datatypeid = data_id,
    startdate = "1990-01-01", enddate = "1999-12-31", limit = 500
  )
  dat <- out$data
  out <- rnoaa::ncdc(
    datasetid = "GHCNDMS", locationid = location_id, datatypeid = data_id,
    startdate = "2000-01-01", enddate = "2009-12-31", limit = 500
  )
  dat <- rbind(dat, out$data)
  out <- rnoaa::ncdc(
    datasetid = "GHCNDMS", locationid = location_id, datatypeid = data_id,
    startdate = "2010-01-01", enddate = "2019-12-31", limit = 500
  )
  dat <- rbind(dat, out$data)

  dat |>
    dplyr::mutate(month = lubridate::month(lubridate::ymd_hms(date))) |>
    dplyr::select(month, value) |>
    dplyr::group_by(month) |>
    dplyr::summarise(value = mean(value)) |>
    dplyr::mutate(value = round(value / 10, digits = 1)) -> clean_data

  clean_data
}

#' Read NCDC city list from cachedir
#'
#' @return A dataframe of NCDC locations (cities)
#' @export
#' @examplesIf interactive()
#' # Not run: needs local data
#' ncdc_city_list <- gdt_ncdc_city_list()
#'
gdt_ncdc_city_list <- function() {
  cachedir <- rappdirs::user_cache_dir("geodata")
  filename <- file.path(cachedir, "ncdc_cities.RData")
  if (!file.exists(filename)) gdt_update_ncdc_city_list()

  fileage <- lubridate::interval(
    start = fs::file_info(filename)$change_time,
    end = lubridate::now()
  )
  if (lubridate::day(lubridate::as.period(fileage)) > 200) gdt_update_ncdc_city_list()

  readRDS(filename)
}

#' Update NCDC city list
#'
#' This updates the list of cities available for climate data, and computes the
#' corresponding country column and store the data locally.
#'
#' @return NULL
#' @export
#' @examplesIf interactive()
#' # Not run: computationally intensive
#' gdt_update_ncdc_city_list()
#'
gdt_update_ncdc_city_list <- function() {
  message("Updating NCDC City list\u2026 This will take a few minutes.")

  cachedir <- rappdirs::user_cache_dir("geodata")
  filename <- file.path(cachedir, "ncdc_cities.RData")
  if (!file.exists(cachedir)) dir.create(cachedir, recursive = TRUE)

  out <- rnoaa::ncdc_locs(datasetid = "GHCNDMS", locationcategoryid = "CITY", limit = 1000)
  dat <- out$data
  out <- rnoaa::ncdc_locs(datasetid = "GHCNDMS", locationcategoryid = "CITY", limit = 1000, offset = 1001)
  dat <- rbind(dat, out$data)

  dat |>
    dplyr::mutate(
      mindate = lubridate::ymd(mindate),
      maxdate = lubridate::ymd(maxdate),
      iso = stringr::str_sub(name, -2),
      city = stringr::str_extract(name, "^[^,]*"),
      country = countrycode::countrycode(iso, "fips", "country.name",
        custom_match = c(
          "NT" = "Cura\u00e7ao",
          "RB" = "Serbia"
        ),
        warn = FALSE
      )
    ) |>
    dplyr::mutate(address = glue::glue("{city}, {country}")) |>
    stats::na.omit() |>
    dplyr::filter(
      mindate < lubridate::ymd("1990-01-01"),
      maxdate > lubridate::ymd("2015-01-01"),
      datacoverage >= .9
    ) |>
    tidygeocoder::geocode(address = address, method = "osm") -> cities

  saveRDS(cities, file = filename)

  NULL
}
