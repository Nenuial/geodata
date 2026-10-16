stop("This file should not be sourced!")

# Solar system objects ----------------------------------------------------

df_cosmology_solar_system_objects <- readr::read_csv(here::here("inst/extdata/df_cosmology/solar_system_objects.csv"))

usethis::use_data(df_cosmology_solar_system_objects, overwrite = TRUE)

# Hubble 1929 --------------------------------------------------------------
# Hubble E. (1929), A relation between distance and radial velocity among
# extra-galactic nebulae, PNAS 15(3): 168-173, Table 1 (24 nebulae)
# Transcribed by GeoKey, checked against the published table

readr::read_csv(
  here::here("inst/extdata/df_cosmology/hubble1929_table1.csv"),
  col_types = readr::cols(object = "c", r_mpc = "d", v_kms = "i")
) |>
  # a plain tibble, without the attributes of readr
  dplyr::transmute(object, r_mpc, v_kms) -> df_cosmology_hubble1929

stopifnot(nrow(df_cosmology_hubble1929) == 24)

usethis::use_data(df_cosmology_hubble1929, overwrite = TRUE)

# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_df_cosmology.R"))
