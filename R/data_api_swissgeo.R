#' Get swiss geodata
#'
#' @param geolevel One of "national", "canton", "district", "municipality", "zh_counting_districts" or "lakes"
#' @param latest Latest geo data (otherwise beginning of the year data)
#' @param verbose Boolean
#'
#' @return An sf object
#' @export
#' @examples
#' gdt_opendata_swiss_geodata("national")
#'
gdt_opendata_swiss_geodata <- function(geolevel = c("national", "canton", "district", "municipality", "zh_counting_districts", "lakes"), latest = TRUE, verbose = FALSE) {
  # Address of data API
  data_source <- "https://ckan.opendata.swiss/api/3/action/package_show?id=geodaten-zu-den-eidgenoessischen-abstimmungsvorlagen"

  # Check input
  geolevel <- match.arg(geolevel)

  # Call geodata api
  geotools::gtl_chk_api_call(data_source)
  cnt <- geotools::gtl_dwnl_api_json(data_source)

  # Get info
  if (latest) {
    gd_info <- cnt[["result"]][["resources"]][[2]][["title"]]
    gd_url <- cnt[["result"]][["resources"]][[2]][["download_url"]]
    gd_layers <- sf::st_layers(gd_url)[1][["name"]]
  } else {
    gd_info <- cnt[["result"]][["resources"]][[1]][["title"]]
    gd_url <- cnt[["result"]][["resources"]][[1]][["download_url"]]
    gd_layers <- sf::st_layers(gd_url)[1][["name"]]
  }
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
    gd <- sf::st_read(gd_url, layer = gd_layers[stringr::str_detect(gd_layers, "zaelhlkreise_")], quiet = TRUE) |>
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

  sf::st_crs(gd) <- sf::st_crs("EPSG:21781")

  # Return
  return(gd)
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
