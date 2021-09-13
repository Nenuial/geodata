stop("This file should not be sourced!")

# CAREFUL DO NOT RUN CARELESSLY !! EXPENSIVE COMPUTATION TIME (WikiData informations)

osmextract::oe_read("inst/extdata/oc_russie/osm/boundaries-russia.osm.pbf", layer="multipolygons") -> russia

russia_adm6 %>%
  dplyr::mutate(wkdt_code = stringr::str_extract(other_tags, '(Q\\d*)')) %>%
  tidyr::drop_na(wkdt_code) -> russia_adm6_wkd_ids

russia_adm6_wkd_ids %>%
  dplyr::mutate(wkdt_data = purrr::map(
    .x = wkdt_code,
    .f = purrr::possibly(~ WikidataR::get_item(.x), otherwise = list())
  )) -> russia_adm6_wkd_data


russia_adm6_wkd_data %>%
  dplyr::mutate(wkdt_oktmo = purrr::map(
    .x = wkdt_data,
    .f = ~ WikidataR::extract_claims(.x, "P764")
  )) -> russia_adm6_oktmo

russia_adm6_oktmo %>%
  dplyr::mutate(wkdt_oktmo_id = purrr::map(
    wkdt_oktmo,
    purrr::possibly(~ purrr::pluck(.x, 1,1,"mainsnak","datavalue","value"), otherwise = NA_integer_)
  )) %>%
  dplyr::select(-c(wkdt_code, wkdt_data, wkdt_oktmo)) %>%
  dplyr::rename(oktmo = wkdt_oktmo_id) -> oc_russie_adm6_gis

usethis::use_data(oc_russie_adm6_gis, overwrite = T)

# Cleanup (remove large GPKG file)
fs::file_delete("inst/extdata/oc_russie/osm/boundaries-russia.gpkg")
