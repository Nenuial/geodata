stop("This file should not be sourced!")


# Gender balance by region ------------------------------------------------

readxl::read_excel(
  here::here(
    "inst/extdata/oc_chine/nbs/population/2018_china_nbs_population_by_gender_and_region.xlsx"
  )
) |>
  dplyr::mutate(ratio = male / female) |>
  dplyr::mutate(
    adm1_code = geotools::admincode(
      region,
      origin = "region.name.en.regex",
      origin_regex = TRUE,
      destination = "adm1",
      warn = FALSE,
      country = "China"
    ),
    .before = "region"
  ) -> oc_chine_2018_sex_ratio_par_region

usethis::use_data(oc_chine_2018_sex_ratio_par_region, overwrite = TRUE)

readxl::read_excel(here::here("inst/extdata/oc_chine/nbs/population/2018_china_nbs_sex_ratio_by_region.xlsx")) |>
  dplyr::mutate(
    adm1_code = geotools::admincode(
      region,
      origin = "region.name.en.regex",
      origin_regex = TRUE,
      destination = "adm1",
      warn = FALSE,
      country = "China"
    ),
    .before = "region"
  ) -> oc_chine_2018_sex_ratio_naissance_par_region

usethis::use_data(oc_chine_2018_sex_ratio_par_region, overwrite = TRUE)

# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_oc_chine.R"))
