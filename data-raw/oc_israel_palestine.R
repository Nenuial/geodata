stop("This file should not be sourced!")

# Immigration Israel 1949 - 2017 ------------------------------------------

oc_israel_palestine_immigration_israel <- readr::read_csv(here::here("inst/extdata/cbs_israel/immigration.csv"))

usethis::use_data(oc_israel_palestine_immigration_israel, overwrite = T)

# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_oc_israel_palestine.R"))
