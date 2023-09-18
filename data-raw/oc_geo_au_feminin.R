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


# Population mondiale -----------------------------------------------------
popF_2019 <- read.delim(file=here::here('inst/extdata/unwpp/2019/popF.txt'),
                        comment.char='#', check.names=FALSE)
popM_2019 <- read.delim(file=here::here('inst/extdata/unwpp/2019/popM.txt'),
                        comment.char='#', check.names=FALSE)

popF_2019 |>
  dplyr::rename(un_code = country_code) |>
  tidyr::pivot_longer(-c("un_code", "name", "age"),
                      names_to = "year", values_to = "female") |>
  dplyr::left_join(
    popM_2019 |>
      dplyr::rename(un_code = country_code) |>
      tidyr::pivot_longer(-c("un_code", "name", "age"),
                          names_to = "year", values_to = "male"),
    by = c("un_code", "name", "age", "year")
  ) |>
  dplyr::mutate(ratio = male/female) -> oc_geo_au_feminin_wpp2019_sex_ratio

usethis::use_data(oc_geo_au_feminin_wpp2019_sex_ratio, overwrite = T)


# Avortements en Suisse ---------------------------------------------------

readxl::read_excel(here::here("inst/extdata/ofs/14_Health/14_03_abortions.xlsx")) |>
  tidyr::pivot_longer(-c("year"), names_to = "type", values_to = "rate") -> oc_geo_au_feminin_2021_ofs_avortements

usethis::use_data(oc_geo_au_feminin_2021_ofs_avortements, overwrite = T)


# FGM indirect data -------------------------------------------------------

readxl::read_excel(here::here("inst/extdata/equalitynow/FGM_indirect_data.xlsx")) |>
  dplyr::mutate(iso = countrycode::countrycode(Country, "country.name", "iso3c")) -> oc_geo_au_feminin_2020_fgm_indirect_data

usethis::use_data(oc_geo_au_feminin_2020_fgm_indirect_data, overwrite = T)

# Violences domestiques en Suisse -----------------------------------------

readxl::read_excel(here::here("inst/extdata/gfs_bern/2019_violences_sexuelles.xlsx"),
                   sheet = "Expériences") -> oc_geo_au_feminin_2019_gfs_violences_sexuelles_experiences

readxl::read_excel(here::here("inst/extdata/gfs_bern/2019_violences_sexuelles.xlsx"),
                   sheet = "Actes") -> oc_geo_au_feminin_2019_gfs_violences_sexuelles_actes

readxl::read_excel(here::here("inst/extdata/gfs_bern/2019_violences_sexuelles.xlsx"),
                   sheet = "Police") -> oc_geo_au_feminin_2019_gfs_violences_sexuelles_police

usethis::use_data(oc_geo_au_feminin_2019_gfs_violences_sexuelles_experiences, overwrite = T)
usethis::use_data(oc_geo_au_feminin_2019_gfs_violences_sexuelles_actes, overwrite = T)
usethis::use_data(oc_geo_au_feminin_2019_gfs_violences_sexuelles_police, overwrite = T)

# Suffrage des femmes dans le monde ---------------------------------------


readr::read_csv("inst/extdata/owid/universal-suffrage-women-lexical.csv") |>
  dplyr::filter(female_suffrage_lied == 1) |>
  dplyr::slice(1, .by = c("Entity", "Code")) |>
  dplyr::select(-female_suffrage_lied) -> oc_geo_au_feminin_owid_suffrage_feminin

usethis::use_data(oc_geo_au_feminin_owid_suffrage_feminin, overwrite = T)


# Femmes et politique (Suisse) --------------------------------------------

elect_cn <- tidyxl::xlsx_cells(here::here("inst/extdata/ofs/17_Politics/je-f-17.02.02.02.01.04.xlsx"))
elect_cn |>
  dplyr::filter(row > 1 & row <= 4) |>
  unpivotr::behead(direction = "up-left", name = "year") |>
  unpivotr::behead(direction = "up", name = "measure") |>
  unpivotr::behead(direction = "left", name = "type") |>
  dplyr::filter(measure == "F en %") |>
  dplyr::select(year, percentage = numeric) -> oc_geo_au_feminin_ofs_election_femmes_conseil_national

elect_ce <- tidyxl::xlsx_cells(here::here("inst/extdata/ofs/17_Politics/su-f-17.02.03.03.xlsx"))
elect_ce |>
  dplyr::filter(row > 1 & row < 4) |>
  unpivotr::behead(direction = "up", name = "year") |>
  unpivotr::behead(direction = "left", name = "type") |>
  tidyr::extract(year, into = "year", "(?:\\d{4}/)?(\\d{4})") |>
  tidyr::drop_na(year) |>
  dplyr::select(year, percentage = numeric) -> oc_geo_au_feminin_ofs_election_femmes_conseil_etats

elect_cf <- tidyxl::xlsx_cells(here::here("inst/extdata/ofs/17_Politics/je-f-17.02.04.03.xlsx"))
elect_cf |>
  dplyr::filter(row > 1, row <= 4) |>
  unpivotr::behead(direction = "up-left", name = "year") |>
  unpivotr::behead(direction = "up", name = "measure") |>
  dplyr::filter(measure == "F") |>
  tidyr::extract(year, into = "year", "(\\d{4})") |>
  dplyr::select(year, percentage = numeric) |>
  dplyr::mutate(percentage = percentage / 7 * 100) -> oc_geo_au_feminin_ofs_election_femmes_conseil_federal

usethis::use_data(oc_geo_au_feminin_ofs_election_femmes_conseil_national, overwrite = T)
usethis::use_data(oc_geo_au_feminin_ofs_election_femmes_conseil_etats, overwrite = T)
usethis::use_data(oc_geo_au_feminin_ofs_election_femmes_conseil_federal, overwrite = T)

# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_oc_geo_au_feminin.R"))
