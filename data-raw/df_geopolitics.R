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

# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_df_geopolitics.R"))
