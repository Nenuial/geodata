stop("This file should not be sourced!")

# Chokepoints: daily transits ----------------------------------------------
# IMF PortWatch, daily transit calls through chokepoints (AIS estimates),
# from the ArcGIS feature service behind portwatch.imf.org
# Credit: "Sources: UN Global Platform; IMF PortWatch (portwatch.imf.org)"

portwatch_url <- paste0(
  "https://services9.arcgis.com/weJ1QsnbMYJlCHdG/arcgis/rest/services/",
  "Daily_Chokepoints_Data/FeatureServer/0/query"
)
chokepoint_ids <- paste0("chokepoint", c(1, 2, 4, 5, 6, 7))
count_fields <- c(
  "n_total", "n_tanker", "n_container", "n_dry_bulk", "n_general_cargo", "n_roro", "n_cargo"
)

# the service returns at most 1000 records per request
portwatch_page <- function(offset) {
  httr2::request(portwatch_url) |>
    httr2::req_url_query(
      where = glue::glue(
        "portid IN ({paste0(\"'\", chokepoint_ids, \"'\", collapse = \",\")}) ",
        "AND date >= DATE '2021-01-01'"
      ),
      outFields = paste(c("date", "portid", "portname", count_fields), collapse = ","),
      orderByFields = "portid,date",
      resultOffset = offset,
      resultRecordCount = 1000,
      f = "json"
    ) |>
    httr2::req_timeout(120) |>
    httr2::req_retry(max_tries = 5) |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("features") |>
    purrr::map(\(feature) tibble::as_tibble(feature$attributes)) |>
    purrr::list_rbind()
}

pages <- list()
repeat {
  page <- portwatch_page(offset = 1000 * length(pages))
  pages <- c(pages, list(page))
  if (nrow(page) < 1000) break
}

fs::dir_create(here::here("inst/extdata/df_geopolitics"))

purrr::list_rbind(pages) |>
  readr::write_csv(here::here("inst/extdata/df_geopolitics/portwatch_chokepoints_daily.csv"))

readr::read_csv(
  here::here("inst/extdata/df_geopolitics/portwatch_chokepoints_daily.csv"),
  col_types = readr::cols(date = "D", portid = "c", portname = "c", .default = "i")
) |>
  dplyr::transmute(
    date,
    chokepoint = portid,
    name = portname,
    dplyr::across(dplyr::all_of(count_fields))
  ) |>
  dplyr::arrange(chokepoint, date) -> df_geopolitics_chokepoints_daily

# every chokepoint every day
n_days <- as.integer(max(df_geopolitics_chokepoints_daily$date) - as.Date("2021-01-01")) + 1
stopifnot(
  !anyDuplicated(df_geopolitics_chokepoints_daily[c("chokepoint", "date")]),
  all(table(df_geopolitics_chokepoints_daily$chokepoint) == n_days)
)

usethis::use_data(df_geopolitics_chokepoints_daily, overwrite = TRUE)

# Read a conflict: sites --------------------------------------------------
# Coordinates (P625) of the Wikidata items of the sites shown on the maps

conflict_sites <- tibble::tribble(
  ~map, ~name, ~type, ~qid,
  "preah_vihear", "Preah Vihear", "temple", "Q45949",
  "preah_vihear", "Ta Muen Thom", "temple", "Q3401369",
  "preah_vihear", "Ta Krabey (Ta Kwai)", "temple", "Q1511068",
  "iran_war", "Tehran", "capital", "Q3616",
  "iran_war", "Fordow", "nuclear site", "Q757565",
  "iran_war", "Natanz", "nuclear site", "Q6012307",
  "iran_war", "Isfahan", "nuclear site", "Q5684976",
  "iran_war", "Strait of Hormuz", "strait", "Q79883",
  "iran_war", "Al Udeid air base", "air base", "Q542588",
  "iran_war", "Doha", "capital", "Q3861",
  "iran_war", "Islamabad", "capital", "Q1362",
  "iran_war", "Muscat", "capital", "Q3826"
)

httr2::request("https://query.wikidata.org/sparql") |>
  httr2::req_url_query(
    query = glue::glue(
      "SELECT ?item ?coord WHERE {{ VALUES ?item {{ {paste0('wd:', conflict_sites$qid, collapse = ' ')} }} ",
      "?item wdt:P625 ?coord . }}"
    ),
    format = "json"
  ) |>
  httr2::req_user_agent("geodata (https://github.com/Nenuial/geodata)") |>
  httr2::req_perform() |>
  httr2::resp_body_json() |>
  purrr::pluck("results", "bindings") |>
  purrr::map(\(binding) {
    coordinates <- stringr::str_match(binding$coord$value, "Point\\(([-0-9.]+) ([-0-9.]+)\\)")
    tibble::tibble(
      qid = basename(binding$item$value),
      lon = as.numeric(coordinates[, 2]),
      lat = as.numeric(coordinates[, 3])
    )
  }) |>
  purrr::list_rbind() -> wikidata_coordinates

conflict_sites |>
  dplyr::left_join(wikidata_coordinates, by = "qid") -> df_geopolitics_conflict_sites

stopifnot(!anyNA(df_geopolitics_conflict_sites$lon))

usethis::use_data(df_geopolitics_conflict_sites, overwrite = TRUE)

# Read a conflict: relief around Preah Vihear -----------------------------
# Copernicus DEM GLO-90 tiles, aggregated to about 900 m, with a hillshade

dem_path <- here::here("inst/extdata/df_geopolitics/copernicus_dem")
fs::dir_create(dem_path)

tidyr::expand_grid(lat = 13:15, lon = 102:105) |>
  dplyr::mutate(tile = glue::glue("Copernicus_DSM_COG_30_N{lat}_00_E{lon}_00_DEM")) |>
  dplyr::pull(tile) |>
  purrr::map_chr(\(tile) {
    path <- file.path(dem_path, paste0(tile, ".tif"))
    if (!file.exists(path)) {
      httr2::request(glue::glue("https://copernicus-dem-90m.s3.amazonaws.com/{tile}/{tile}.tif")) |>
        httr2::req_perform(path = path)
    }
    path
  }) -> dem_tiles

dem <- dem_tiles |>
  purrr::map(terra::rast) |>
  terra::sprc() |>
  terra::merge() |>
  terra::crop(terra::ext(102.3, 105.7, 13.3, 15.7)) |>
  terra::aggregate(fact = 10, fun = "mean")

hillshade <- terra::shade(
  terra::terrain(dem, "slope", unit = "radians"),
  terra::terrain(dem, "aspect", unit = "radians"),
  angle = 40,
  direction = 315
)

c(dem, hillshade) |>
  terra::as.data.frame(xy = TRUE) |>
  rlang::set_names(c("lon", "lat", "elevation", "hillshade")) |>
  dplyr::filter(!is.na(hillshade)) |>
  # lon and lat kept as they are: rounding would make the grid uneven
  dplyr::mutate(
    elevation = as.integer(round(elevation)),
    hillshade = round(hillshade, 3)
  ) |>
  tibble::as_tibble() -> df_geopolitics_preah_vihear_relief

usethis::use_data(df_geopolitics_preah_vihear_relief, overwrite = TRUE)

# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_df_geopolitics.R"))
