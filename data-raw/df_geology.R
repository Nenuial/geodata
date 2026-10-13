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

# Find the earthquake: Swiss basemap -------------------------------------
# Natural Earth 10m (countries and Swiss cantons from rnaturalearthhires, lakes
# from the 10m lakes and the more detailed European lakes), in Swiss LV95

natural_earth_path <- here::here("inst/extdata/df_geology/natural_earth")
fs::dir_create(natural_earth_path)

c("lakes", "lakes_europe") |>
  purrr::walk(\(type) {
    rnaturalearth::ne_download(
      scale = 10, type = type, category = "physical",
      destdir = natural_earth_path, load = FALSE
    )
  })

# wider than the map, so that the crop edges stay outside it
swiss_window <- c(xmin = 4.5, xmax = 12, ymin = 44.5, ymax = 49)

# one geometry column called geometry (the GeoPackages use geom)
basemap_layer <- function(data, layer, name) {
  sf::st_sf(layer = layer, name = name, geometry = sf::st_geometry(data))
}

crop_to_swiss_window <- function(data) {
  withr::local_options(sf_use_s2 = FALSE)
  data |>
    sf::st_make_valid() |>
    sf::st_crop(swiss_window) |>
    suppressMessages() |>
    suppressWarnings()
}

rnaturalearthhires::countries10 |>
  crop_to_swiss_window() |>
  (\(countries) basemap_layer(countries, "country", countries$NAME_EN))() -> swiss_countries

rnaturalearthhires::states10 |>
  dplyr::filter(adm0_a3 == "CHE") |>
  crop_to_swiss_window() |>
  (\(cantons) basemap_layer(cantons, "canton", cantons$name))() -> swiss_cantons

c("lakes", "lakes_europe") |>
  purrr::map(\(type) {
    rnaturalearth::ne_load(
      scale = 10, type = type, category = "physical",
      destdir = natural_earth_path, returnclass = "sf"
    ) |>
      dplyr::select(name)
  }) |>
  purrr::list_rbind() |>
  sf::st_as_sf() |>
  crop_to_swiss_window() |>
  (\(lakes) lakes[!sf::st_is_empty(lakes), ])() |>
  (\(lakes) basemap_layer(lakes, "lake", lakes$name))() -> swiss_lakes

rbind(swiss_countries, swiss_cantons, swiss_lakes) |>
  sf::st_transform(2056) -> df_geology_swiss_basemap

usethis::use_data(df_geology_swiss_basemap, overwrite = TRUE)

# Find the earthquake: stations and epicentre -----------------------------
# Visp earthquake of 1855; distances and S - P delays used in the exercise,
# P waves at 6 km/s

tibble::tribble(
  ~station, ~lat,  ~lon, ~distance, ~s_minus_p,
  "Sion",   46.23, 7.36,        38,        4.5,
  "Bern",   46.95, 7.45,        78,        9.3,
  "Lugano", 46.00, 8.95,        90,       10.7
) |>
  dplyr::mutate(
    p_arrival = round(distance / 6, 1),
    s_arrival = p_arrival + s_minus_p
  ) -> df_geology_seismic_stations

usethis::use_data(df_geology_seismic_stations, overwrite = TRUE)

tibble::tibble(name = "Visp", year = 1855, lat = 46.30, lon = 7.85) -> df_geology_epicentre

usethis::use_data(df_geology_epicentre, overwrite = TRUE)

# Find the earthquake: synthetic seismograms ------------------------------
# Same earthquake recorded at the three stations, 100 samples per second:
# noise, a small fast P wave, then an S wave about three times larger,
# both decaying

withr::with_seed(1855, {
  time <- seq(0, 40, by = 0.01)

  arrival <- function(time, onset, amplitude, frequency, decay) {
    t <- time - onset
    ifelse(
      t < 0,
      0,
      amplitude * (1 - exp(-t / 0.05)) * exp(-t / decay) *
        sin(2 * pi * frequency * t + stats::runif(1, 0, pi))
    )
  }

  df_geology_seismic_stations |>
    purrr::pmap(\(station, p_arrival, s_arrival, ...) {
      tibble::tibble(
        station = station,
        time = time,
        amplitude = stats::rnorm(length(time), sd = 0.04) +
          arrival(time, p_arrival, amplitude = 1, frequency = 6, decay = 1.2) +
          arrival(time, s_arrival, amplitude = 3, frequency = 2.5, decay = 3.5)
      )
    }) |>
    purrr::list_rbind() |>
    dplyr::mutate(amplitude = round(amplitude, 4)) -> df_geology_seismograms
})

usethis::use_data(df_geology_seismograms, overwrite = TRUE)

# Find the earthquake: GDP per capita -------------------------------------
# World Bank, GDP per capita (current US$), Haiti 2010 and Japan 2016

c(HTI = 2010, JPN = 2016) |>
  purrr::imap(\(year, iso3c) {
    httr2::request("https://api.worldbank.org/v2/country") |>
      httr2::req_url_path_append(iso3c, "indicator", "NY.GDP.PCAP.CD") |>
      httr2::req_url_query(format = "json", date = year) |>
      httr2::req_timeout(120) |>
      httr2::req_retry(max_tries = 5) |>
      httr2::req_perform() |>
      httr2::resp_body_json() |>
      purrr::pluck(2, 1) -> value

    tibble::tibble(
      country = value$country$value,
      iso3c = iso3c,
      year = as.integer(value$date),
      gdp_per_capita = value$value
    )
  }) |>
  purrr::list_rbind() |>
  dplyr::mutate(indicator = "NY.GDP.PCAP.CD", retrieved = Sys.Date()) -> df_geology_gdp_per_capita

usethis::use_data(df_geology_gdp_per_capita, overwrite = TRUE)

# Vesuvius: municipalities ------------------------------------------------
# ISTAT generalised boundaries and population (estimate) on 1 January 2026,
# municipalities within 40 km of the crater (the maps show about 25 km
# around it), in UTM 33N
# Red zone: Direttiva del Presidente del Consiglio dei Ministri,
# 14 February 2014 (GU 12 May 2014); 22 municipalities entirely,
# Napoli, Nola and Pomigliano d'Arco partly

istat_path <- here::here("inst/extdata/df_geology/istat")
fs::dir_create(istat_path)

httr2::request(
  "https://www.istat.it/storage/cartografia/confini_amministrativi/generalizzati/2026/Limiti01012026_g.zip"
) |>
  httr2::req_perform(path = file.path(istat_path, "Limiti01012026_g.zip"))

httr2::request("https://demo.istat.it/data/posas/POSAS_2026_it_Comuni.zip") |>
  httr2::req_perform(path = file.path(istat_path, "POSAS_2026_it_Comuni.zip"))

istat_dir <- withr::local_tempdir()
utils::unzip(file.path(istat_path, "Limiti01012026_g.zip"), exdir = istat_dir)

readr::read_delim(
  unz(file.path(istat_path, "POSAS_2026_it_Comuni.zip"), "POSAS_2026_it_Comuni.csv"),
  delim = ";",
  skip = 1,
  col_types = readr::cols(.default = "c")
) |>
  dplyr::filter(`Età` == "999") |>
  dplyr::transmute(code = `Codice comune`, population = as.integer(Totale)) -> istat_population

red_zone_full <- c(
  "Boscoreale", "Boscotrecase", "Cercola", "Ercolano", "Massa di Somma", "Ottaviano",
  "Palma Campania", "Poggiomarino", "Pollena Trocchia", "Pompei", "Portici",
  "Sant'Anastasia", "San Gennaro Vesuviano", "San Giorgio a Cremano",
  "San Sebastiano al Vesuvio", "San Giuseppe Vesuviano", "Somma Vesuviana", "Terzigno",
  "Torre Annunziata", "Torre del Greco", "Trecase", "Scafati"
)
red_zone_partial <- c("Napoli", "Nola", "Pomigliano d'Arco")

vesuvius_crater <- sf::st_sfc(sf::st_point(c(14.426, 40.821)), crs = 4326) |>
  sf::st_transform(32633)

list.files(istat_dir, "Com01012026_g_WGS84.shp$", recursive = TRUE, full.names = TRUE) |>
  sf::read_sf() |>
  sf::st_transform(32633) |>
  sf::st_filter(sf::st_buffer(vesuvius_crater, 40000)) |>
  dplyr::left_join(istat_population, by = c("PRO_COM_T" = "code")) |>
  dplyr::transmute(
    code = PRO_COM_T,
    name = COMUNE,
    province = dplyr::case_when(
      COD_PROV == 61 ~ "Caserta",
      COD_PROV == 63 ~ "Napoli",
      COD_PROV == 64 ~ "Avellino",
      COD_PROV == 65 ~ "Salerno"
    ),
    population,
    red_zone = dplyr::case_when(
      name %in% red_zone_full ~ "entirely",
      name %in% red_zone_partial ~ "partly",
      .default = "no"
    )
  ) -> df_geology_vesuvius_municipalities

stopifnot(sum(df_geology_vesuvius_municipalities$red_zone != "no") == 25)

usethis::use_data(df_geology_vesuvius_municipalities, overwrite = TRUE)

# Vesuvius: crater and ancient sites --------------------------------------
# Approximate coordinates

tibble::tribble(
  ~name,          ~type,          ~lat,    ~lon,
  "Vesuvius",     "crater",       40.821, 14.426,
  "Pompeii",      "ancient site", 40.749, 14.487,
  "Herculaneum",  "ancient site", 40.806, 14.348
) -> df_geology_vesuvius_sites

usethis::use_data(df_geology_vesuvius_sites, overwrite = TRUE)

# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_df_geology.R"))
