stop("This file should not be sourced!")

# Electricity production by source ----------------------------------------

owidR::owid("per-capita-energy-stacked") |>
  tidyr::pivot_longer(-c(entity, code, year), names_to = 'source', values_to = 'amount') -> oc_ecocitoyennete_energy_consumption_per_source

usethis::use_data(oc_ecocitoyennete_energy_consumption_per_source, overwrite = T)

# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_oc_ecocitoyennete.R"))
