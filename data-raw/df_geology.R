stop("This file should not be sourced!")

# Plate detective regions -------------------------------------------------

tibble::tribble(
  ~region, ~name,                      ~lon_min, ~lon_max, ~lat_min, ~lat_max,
  "A",     "Japan",                         128,      150,       30,       46,
  "B",     "Central Andes",                 -82,      -60,      -35,       -5,
  "C",     "Iceland / North Atlantic",      -40,        0,       55,       72,
  "D",     "Himalaya / Tibet",               70,      100,       20,       42,
  "E",     "California",                   -125,     -114,       32,       42
) -> df_geology_regions

usethis::use_data(df_geology_regions, overwrite = TRUE)

# USGS earthquakes --------------------------------------------------------
# Magnitude 5+ from 1975 to 2025 per region, USGS ComCat (public domain)
# https://earthquake.usgs.gov/fdsnws/event/1/

fs::dir_create(here::here("inst/extdata/df_geology"))

usgs_path <- function(region) {
  here::here(glue::glue("inst/extdata/df_geology/usgs_{region}.geojson"))
}

df_geology_regions |>
  purrr::pwalk(\(region, lon_min, lon_max, lat_min, lat_max, ...) {
    httr2::request("https://earthquake.usgs.gov/fdsnws/event/1/query") |>
      httr2::req_url_query(
        format = "geojson",
        minmagnitude = 5,
        starttime = "1975-01-01",
        endtime = "2025-12-31",
        minlongitude = lon_min,
        maxlongitude = lon_max,
        minlatitude = lat_min,
        maxlatitude = lat_max
      ) |>
      httr2::req_perform(path = usgs_path(region))
  })

df_geology_regions$region |>
  purrr::map(\(region) {
    jsonlite::parse_json(readr::read_file(usgs_path(region)))$features |>
      purrr::map(\(quake) {
        tibble::tibble(
          region = region,
          lon = quake$geometry$coordinates[[1]],
          lat = quake$geometry$coordinates[[2]],
          depth = quake$geometry$coordinates[[3]],
          mag = quake$properties$mag,
          time = as.POSIXct(quake$properties$time / 1000, origin = "1970-01-01", tz = "UTC"),
          place = quake$properties$place %||% NA_character_
        )
      }) |>
      purrr::list_rbind()
  }) |>
  purrr::list_rbind() |>
  dplyr::mutate(year = as.integer(format(time, "%Y")), .after = time) |>
  dplyr::arrange(region, time) -> df_geology_earthquakes

usethis::use_data(df_geology_earthquakes, overwrite = TRUE)

# Smithsonian GVP Holocene volcanoes --------------------------------------
# Global Volcanism Program, Volcanoes of the World, Smithsonian Institution
# https://volcano.si.edu/

gvp_path <- here::here("inst/extdata/df_geology/gvp_holocene_volcanoes.json")

httr2::request("https://webservices.volcano.si.edu/geoserver/GVP-VOTW/ows") |>
  httr2::req_url_query(
    service = "WFS",
    version = "2.0.0",
    request = "GetFeature",
    typeName = "GVP-VOTW:Smithsonian_VOTW_Holocene_Volcanoes",
    outputFormat = "application/json"
  ) |>
  httr2::req_perform(path = gvp_path)

jsonlite::parse_json(readr::read_file(gvp_path))$features |>
  purrr::map(\(volcano) {
    tibble::tibble(
      name = volcano$properties$Volcano_Name,
      lon = volcano$geometry$coordinates[[1]],
      lat = volcano$geometry$coordinates[[2]],
      type = volcano$properties$Primary_Volcano_Type,
      last_eruption = volcano$properties$Last_Eruption_Year %||% NA_integer_
    )
  }) |>
  purrr::list_rbind() -> volcanoes

df_geology_regions |>
  purrr::pmap(\(region, lon_min, lon_max, lat_min, lat_max, ...) {
    volcanoes |>
      dplyr::filter(
        dplyr::between(lon, lon_min, lon_max),
        dplyr::between(lat, lat_min, lat_max)
      ) |>
      dplyr::mutate(region = region, .before = 1)
  }) |>
  purrr::list_rbind() -> df_geology_volcanoes

usethis::use_data(df_geology_volcanoes, overwrite = TRUE)

# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_df_geology.R"))
