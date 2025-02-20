stop("This file should not be sourced!")


# Gender balance by region -----------------------------------------------

readxl::read_excel(
  here::here(
    "inst/extdata/oc_chine/nbs/population/2018_china_nbs_population_by_gender_and_region.xlsx"
  )
) |>
  dplyr::mutate(ratio = male / female) |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
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
    adm1_code = geotools::gtl_admin_code(
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


# Gender imbalance by age ------------------------------------------------

city <- readxl::read_excel("inst/extdata/oc_chine/nbs/gender_imbalance/A0301b.xlsx",
  skip = 4,
  col_types = c("text", "skip", "numeric", "numeric", "skip", "skip", "skip", "skip"),
  col_names = c("age", "citymale", "cityfemale")
)

town <- readxl::read_excel("inst/extdata/oc_chine/nbs/gender_imbalance/A0301c.xlsx",
  skip = 4,
  col_types = c("text", "skip", "numeric", "numeric", "skip", "skip", "skip", "skip"),
  col_names = c("age", "townmale", "townfemale")
)

rural <- readxl::read_excel("inst/extdata/oc_chine/nbs/gender_imbalance/A0301d.xlsx",
  skip = 4,
  col_types = c("text", "skip", "numeric", "numeric", "skip", "skip", "skip", "skip"),
  col_names = c("age", "male", "female")
)

urban <- dplyr::left_join(city, town, by = "age")
urban |>
  dplyr::transmute(
    age = age,
    male = citymale + townmale,
    female = cityfemale + townfemale
  ) -> urban

urban |>
  dplyr::mutate(urban = male - female) |>
  dplyr::select(age, urban) -> urban

rural |>
  dplyr::mutate(rural = male - female) |>
  dplyr::select(age, rural) -> rural

urban |>
  dplyr::left_join(rural, by = "age") |>
  dplyr::mutate(age = stringr::str_replace(age, "Age 100 and above", "100")) |>
  dplyr::filter(stringr::str_detect(age, "^\\d{1,3}$")) |>
  tidyr::pivot_longer(cols = -age, names_to = "region", values_to = "genderbalance") |>
  dplyr::mutate(age = readr::parse_number(age)) -> oc_chine_2010_gender_imbalance_by_age

usethis::use_data(oc_chine_2010_gender_imbalance_by_age, overwrite = TRUE)

# Open documentation file ------------------------------------------------

usethis::edit_file(here::here("R/data_doc_oc_chine.R"))
