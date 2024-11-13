stop("This file should not be sourced!")



# UN HDR Composite indices -----------------------------------------------

readr::read_csv("inst/extdata/unhdr/HDR21-22_Composite_indices_complete_time_series.csv") |>
  tidyr::pivot_longer(
    cols = -c(iso3, country, hdicode, region),
    names_to = c("indicator", "year"),
    names_ptypes = list(
      indicator = character(),
      year = integer()
    ),
    names_transform = list(
      year = as.integer
    ),
    names_pattern = "(.*)_(\\d{4})$"
  ) -> gdt_un_hdr_composite

usethis::use_data(gdt_un_hdr_composite, overwrite = TRUE)

# Open documentation file -----------------------------------------------

usethis::edit_file(here::here("R/data_doc_demography.R"))
