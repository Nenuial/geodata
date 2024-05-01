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

dplyr::bind_rows(
  oc_geo_au_feminin_ofs_election_femmes_conseil_national |>
    dplyr::mutate(council = "Conseil National"),
  oc_geo_au_feminin_ofs_election_femmes_conseil_etats |>
    dplyr::mutate(council = "Conseil des États"),
  oc_geo_au_feminin_ofs_election_femmes_conseil_federal |>
    dplyr::mutate(council = "Conseil Fédéral")
) -> oc_geo_au_feminin_ofs_election_femmes


usethis::use_data(oc_geo_au_feminin_ofs_election_femmes_conseil_national, overwrite = T)
usethis::use_data(oc_geo_au_feminin_ofs_election_femmes_conseil_etats, overwrite = T)
usethis::use_data(oc_geo_au_feminin_ofs_election_femmes_conseil_federal, overwrite = T)
usethis::use_data(oc_geo_au_feminin_ofs_election_femmes, overwrite = T)

# Jeunes qui apprennent à coder -------------------------------------------

readr::read_csv(here::here("inst/extdata/oecd/going_digital/indicator_54_20231016_all.csv")) |>
  dplyr::select(ISO, Country, Scope, Time, Value) |>
  tidyr::separate_wider_delim(Scope, " aged ", names = c("Gender", "Age")) ->
  oc_geo_au_feminin_oecd_programmation_16_24_ans

usethis::use_data(oc_geo_au_feminin_oecd_programmation_16_24_ans, overwrite = T)


# Social Institutions and Gender Index ------------------------------------

readr::read_csv(here::here("inst/extdata/oecd/SIGI2023.csv")) |>
  dplyr::select(-c(`Flag Codes`, Flags, TIME)) ->
  oc_geo_au_feminin_2023_oecd_sigi

usethis::use_data(oc_geo_au_feminin_2023_oecd_sigi, overwrite = T)


# Gender Inequality Index -------------------------------------------------

xls <- here::here("inst/extdata/unhdr/HDR21-22_Statistical_Annex_GII_Table.xlsx")
un_gii <- tidyxl::xlsx_cells(xls)
un_gii_format <- tidyxl::xlsx_formats(xls)

un_gii |>
  dplyr::filter(col > 1 & col < 4) |>
  dplyr::filter(row > 3 & row <= 203) |>
  dplyr::mutate(bold = un_gii_format$local$font$bold[local_format_id]) |>
  unpivotr::behead(direction = "up", name = "indicator") |>
  unpivotr::behead(direction = "up", name = "measure") |>
  unpivotr::behead(direction = "up", name = "header") |>
  unpivotr::behead_if(bold, direction = "left-up", name = "category") |>
  unpivotr::behead(direction = "left", name = "country") |>
  dplyr::select(country, gii = numeric) |>
  tidyr::drop_na() |>
  dplyr::mutate(iso = countrycode::countrycode(country,
                                               origin = "country.name",
                                               destination = "iso3c")) ->
  oc_geo_au_feminin_2021_unhdr_gii

usethis::use_data(oc_geo_au_feminin_2021_unhdr_gii, overwrite = T)


# Déséquilibre filles/garçons à la naissance - WPP2022 --------------------

readr::read_csv("inst/extdata/unwpp/WPP2022_Demographic_Indicators_Medium.csv") |>
  dplyr::select(UN_Code = LocID, Region = LocTypeName, Location, Year = Time, SRB) |>
  dplyr::mutate(
    iso = countrycode::countrycode(UN_Code, origin = "un", destination = "iso3c")
  ) -> oc_geo_au_feminin_sex_ratio

usethis::use_data(oc_geo_au_feminin_sex_ratio, overwrite = T)



# Avortement par cantons ----------------------------------------------------------------------

xls <- here::here("inst/extdata/ofs/14_Health/je-f-14.03.07.02.23.xlsx")
ofs_abortion <- tidyxl::xlsx_cells(xls)
ofs_abortion_format <- tidyxl::xlsx_formats(xls)

ofs_abortion |>
  dplyr::filter(row > 3 & row <= 40 & sheet == 2022) |>
  dplyr::mutate(bold = ofs_abortion_format$local$font$bold[local_format_id]) |>
  unpivotr::behead(direction = "up-left", name = "age_group") |>
  unpivotr::behead(direction = "up", name = "unit") |>
  unpivotr::behead_if(bold, direction = "left-up", name = "region") |>
  unpivotr::behead(direction = "left", name = "canton") |>
  dplyr::mutate(canton = dplyr::if_else(region == "Zurich", "Zurich", canton)) |>
  dplyr::mutate(canton = dplyr::if_else(region == "Tessin", "Tessin", canton)) |>
  dplyr::select(age_group, unit, region, canton, abortion = numeric) |>
  tidyr::drop_na(canton) -> oc_geo_au_feminin_2022_ofs_avortements_par_canton

usethis::use_data(oc_geo_au_feminin_2022_ofs_avortements_par_canton, overwrite = T)



# Avortement par tranche d'âges ---------------------------------------------------------------

xls <- here::here("inst/extdata/ofs/14_Health/je-f-14.03.07.02.23.xlsx")
ofs_abortion <- tidyxl::xlsx_cells(xls)
ofs_abortion_format <- tidyxl::xlsx_formats(xls)

ofs_abortion |>
  dplyr::filter(row > 3 & row <= 6 & sheet == 2022) |>
  dplyr::mutate(bold = ofs_abortion_format$local$font$bold[local_format_id]) |>
  unpivotr::behead(direction = "up-left", name = "age_group") |>
  unpivotr::behead(direction = "up", name = "unit") |>
  unpivotr::behead_if(bold, direction = "left-up", name = "region") |>
  dplyr::filter(age_group != "Total") |>
  dplyr::select(age_group, unit, abortion = numeric) -> oc_geo_au_feminin_2022_ofs_avortements_par_ages

usethis::use_data(oc_geo_au_feminin_2022_ofs_avortements_par_ages, overwrite = T)



# Avortement par régions ----------------------------------------------------------------------

xls <- here::here("inst/extdata/ofs/14_Health/je-f-14.03.07.02.20.xlsx")
ofs_abortion <- tidyxl::xlsx_cells(xls)
ofs_abortion_format <- tidyxl::xlsx_formats(xls)

ofs_abortion |>
  dplyr::filter(row >= 4 & row <= 37 & sheet == "Taux pour mille femmes") |>
  dplyr::mutate(bold = ofs_abortion_format$local$font$bold[local_format_id]) |>
  unpivotr::behead(direction = "up", name = "annee") |>
  dplyr::filter(bold == TRUE) |>
  unpivotr::behead(direction = "left", name = "region") |>
  dplyr::select(annee, region, avortement = numeric) |>
  dplyr::filter(region != "Total ") -> oc_geo_au_feminin_ofs_avortements_par_region

usethis::use_data(oc_geo_au_feminin_ofs_avortements_par_region, overwrite = T)



# Votations sur l'avortement ------------------------------------------------------------------

tibble::tribble(
  ~Votation, ~Oui, ~Non,
  "février 2014 - initiative pour radier les coûts de l'interruption de grossesse de l'assurance de base", 30.2, 69.8,
  "juin 2002 - initiative «pour la protection de l'enfant à naître et l'aide à sa mère dans la détresse»", 18.2, 81.8,
  "juin 2002 - inscription du régime du délai dans le Code pénal", 72.2, 27.8,
  "juin 1985 - initiative «pour le droit à la vie»", 31, 69,
  "mai 1978 - loi fédérale sur la protection de la grossesse et le caractère punissable de son interruption", 31.2, 68.8,
  "septembre 1977 - initiative «pour la solution du délai»", 48.3, 51.7
) -> oc_geo_au_feminin_votations_avortement

usethis::use_data(oc_geo_au_feminin_votations_avortement, overwrite = T)


# Open documentation file ---------------------------------------------------------------------

usethis::edit_file(here::here("R/data_doc_oc_geo_au_feminin.R"))
