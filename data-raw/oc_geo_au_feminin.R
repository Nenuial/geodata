stop("This file should not be sourced!")

# Espérance de vie - WPP2012 ----------------------------------------------

e0F_2012 <- utils::read.delim(file=here::here('inst/extdata/unwpp/2012/e0F.txt'),
                              comment.char='#', check.names=FALSE)
e0M_2012 <- utils::read.delim(file=here::here('inst/extdata/unwpp/2012/e0M.txt'),
                              comment.char='#', check.names=FALSE)

e0F_2012 |>
  dplyr::select(un_code = country_code, lexf = `2005-2010`) |>
  dplyr::mutate(period = "2005-2010", .after = "un_code") |>
  dplyr::left_join(
    e0M_2012 |>
      dplyr::select(un_code = country_code, lexm = `2005-2010`),
    by = "un_code"
  ) |>
  dplyr::mutate(lexdelta = lexf - lexm) -> oc_geo_au_feminin_wpp2012_lex

usethis::use_data(oc_geo_au_feminin_wpp2012_lex, overwrite = T)

# Espérance de vie - WPP2019 ----------------------------------------------

e0F_2019 <- read.delim(file=here::here('inst/extdata/unwpp/2019/e0F.txt'),
                       comment.char='#', check.names=FALSE)
e0M_2019 <- read.delim(file=here::here('inst/extdata/unwpp/2019/e0M.txt'),
                       comment.char='#', check.names=FALSE)

e0F_2019 |>
  dplyr::select(un_code = country_code, `2005-2010`, `2015-2020`) |>
  tidyr::pivot_longer(-c("un_code"), names_to = "period", values_to = "lexf") |>
  dplyr::left_join(
    e0M_2019 |>
      dplyr::select(un_code = country_code, `2005-2010`, `2015-2020`) |>
      tidyr::pivot_longer(-c("un_code"), names_to = "period", values_to = "lexm"),
    by = c("un_code", "period")
  ) |>
  dplyr::mutate(lexdelta = lexf - lexm)  -> oc_geo_au_feminin_wpp2019_lex

usethis::use_data(oc_geo_au_feminin_wpp2019_lex, overwrite = T)

# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_oc_geo_au_feminin.R"))
