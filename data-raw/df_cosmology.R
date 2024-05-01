stop("This file should not be sourced!")

# Solar system objects ----------------------------------------------------

df_cosmology_solar_system_objects <- readr::read_csv(here::here("inst/extdata/df_cosmology/solar_system_objects.csv"))

usethis::use_data(df_cosmology_solar_system_objects, overwrite = TRUE)

# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_df_cosmology.R"))
