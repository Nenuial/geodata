#' Get swiss geodata
#'
#' The geometries of the Federal Statistical Office for the federal votes, from
#' opendata.swiss. Each file holds the communes as they stood at a date; the
#' newest is used unless `date` is given.
#'
#' @param geolevel One of "national", "canton", "district", "municipality", "zh_counting_districts" or "lakes"
#' @param latest Unused: the newest geometries are used unless `date` is given. Kept for compatibility.
#' @param date A date (or a string such as "2020-06-01"): the geometries in force at that date
#' @param verbose Boolean
#'
#' @return An sf object in the Swiss LV03 coordinates (EPSG:21781)
#' @export
#' @examples
#' gdt_opendata_swiss_geodata("national")
#' gdt_opendata_swiss_geodata("canton", date = "2020-06-01")
#'
gdt_opendata_swiss_geodata <- function(
  geolevel = c("national", "canton", "district", "municipality", "zh_counting_districts", "lakes"),
  latest = TRUE, date = NULL, verbose = FALSE
) {
  # Address of data API
  data_source <- "https://ckan.opendata.swiss/api/3/action/package_show?id=geodaten-zu-den-eidgenoessischen-abstimmungsvorlagen"

  # Check input
  geolevel <- match.arg(geolevel)

  # Call geodata api
  geotools::gtl_chk_api_call(data_source)
  cnt <- geotools::gtl_dwnl_api_json(data_source)

  # Choose the file by the date in its title ("Stand am 01.01.2026"): the
  # resources are listed in no particular order
  resources <- cnt[["result"]][["resources"]]
  dates <- purrr::map_chr(resources, \(x) stringr::str_extract(x[["title"]][["de"]], "\\d{2}\\.\\d{2}\\.\\d{4}")) |>
    as.Date(format = "%d.%m.%Y")
  if (is.null(date)) {
    pick <- which.max(dates)
  } else {
    valid <- which(dates <= as.Date(date))
    if (length(valid) == 0) {
      stop(sprintf("No Swiss geodata before %s: the oldest is from %s.", as.Date(date), min(dates, na.rm = TRUE)))
    }
    pick <- valid[which.max(dates[valid])]
  }
  gd_info <- resources[[pick]][["title"]]
  gd_url <- resources[[pick]][["download_url"]]
  gd_layers <- sf::st_layers(gd_url)[1][["name"]]
  if (verbose) cat(paste0(gd_info[!gd_info == ""], collapse = "\n"), "\n\n")

  # Load geodata and join votes
  if (geolevel == "municipality") {
    # Load
    gd <- sf::st_read(gd_url, layer = gd_layers[stringr::str_detect(gd_layers, "voge_")], quiet = TRUE)

    # Mutate if variable vogenr exists
    if ("vogenr" %in% names(gd)) {
      gd <- gd |>
        dplyr::mutate(id = vogenr) |>
        dplyr::select(-vogenr)
    }
    if ("vogeId" %in% names(gd)) {
      gd <- gd |>
        dplyr::mutate(id = vogeId) |>
        dplyr::select(-vogeId)
    }

    # Adjust variable mun_id
    gd <- gd |>
      dplyr::rename(mun_id = id) |>
      dplyr::mutate(mun_id = as.character(mun_id)) |>
      dplyr::select(mun_id, geometry)
  }
  if (geolevel == "district") {
    # Load
    gd <- sf::st_read(gd_url, layer = gd_layers[stringr::str_detect(gd_layers, "bezk_")], quiet = TRUE)

    # Mutate if variable vogenr exists
    if ("bezkId" %in% names(gd)) {
      gd <- gd |>
        dplyr::mutate(id = bezkId) |>
        dplyr::select(-bezkId)
    }

    # Adjust variable district_id
    gd <- gd |>
      dplyr::rename(district_id = id) |>
      dplyr::mutate(district_id = as.character(district_id)) |>
      dplyr::select(district_id, geometry)
  }
  if (geolevel == "canton") {
    # Load
    gd <- sf::st_read(gd_url, layer = gd_layers[stringr::str_detect(gd_layers, "kant_")], quiet = TRUE) |>
      dplyr::rename(canton_id = kantId) |>
      dplyr::rename(canton_name = kantName) |>
      dplyr::mutate(canton_id = as.character(canton_id)) |>
      dplyr::select(canton_id, geometry)
  }
  if (geolevel == "zh_counting_districts") {
    gd <- sf::st_read(gd_url, layer = gd_layers[stringr::str_detect(gd_layers, "kreise_")], quiet = TRUE) |>
      dplyr::rename(mun_id = id) |>
      dplyr::rename(mun_name = name) |>
      dplyr::mutate(mun_id = as.character(mun_id)) |>
      dplyr::select(mun_id, geometry)
  }
  if (geolevel == "lakes") {
    gd <- sf::st_read(gd_url, layer = gd_layers[stringr::str_detect(gd_layers, "seen_")], quiet = TRUE) |>
      dplyr::select(id, geometry)
  }
  if (geolevel == "national") {
    gd <- sf::st_read(gd_url, layer = gd_layers[stringr::str_detect(gd_layers, "suis_")], quiet = TRUE) |>
      dplyr::select(id, geometry)
  }

  # the files have no CRS: LV03 until 2025, LV95 since (coordinates above 2 million)
  if (is.na(sf::st_crs(gd))) {
    lv95 <- sf::st_bbox(gd)[["xmin"]] > 1e6
    sf::st_crs(gd) <- sf::st_crs(if (lv95) "EPSG:2056" else "EPSG:21781")
  }

  sf::st_transform(gd, "EPSG:21781")
}

#' Get swiss geodata in geojson format
#'
#' @inheritDotParams gdt_opendata_swiss_geodata
#'
#' @return A geojson map
#' @export
#' @examples
#' gdt_opendata_swiss_geodata_json(geolevel = "national")
#'
gdt_opendata_swiss_geodata_json <- function(...) {
  gdt_opendata_swiss_geodata(...) |>
    geojsonsf::sf_geojson()
}
