stop("This file should not be sourced!")

# Regional life expectancy ------------------------------------------------

xls <- here::here("inst/extdata/oc_russie/rosstat/population/2021_life_expectancy.xlsx")
lex <- tidyxl::xlsx_cells(xls)
lex_format <- tidyxl::xlsx_formats(xls)

lex %>%
  dplyr::mutate(bold = lex_format$local$font$bold[local_format_id]) %>%
  dplyr::filter(row > 4) %>%
  unpivotr::behead_if(!bold, direction = "left", name = "region") %>%
  dplyr::select(region, lex = numeric) %>%
  tidyr::drop_na() %>%
  # IMPORTANT : remove Arkhangelsk Oblast and Tyumen Oblast because they agregate nearby autonomous regions
  dplyr::filter(region != "Архангельская область" & region != "Тюменская область") %>%
  dplyr::mutate(
    adm1_code = geotools::admincode(
      region,
      origin = "region.name.ru.regex",
      origin_regex = T,
      destination = "adm1",
      warn = F,
      country = "Russia"
    )
  ) %>% tidyr::drop_na() -> oc_russie_2019_esperance_vie

usethis::use_data(oc_russie_2019_esperance_vie, overwrite = T)


# Regional fertility rates ------------------------------------------------

# The Main databank is missing Kemerovo Oblast (for whatever fucked up reason…)
# Source: https://showdata.gks.ru/report/278974
# So we use an alternative dataset.
# Source: https://rosstat.gov.ru/storage/mediabank/7-1(2).xlsx

xls <- here::here("inst/extdata/oc_russie/rosstat/population/2021_fertility_rates.xlsx")
tfr <- tidyxl::xlsx_cells(xls)
tfr_format <- tidyxl::xlsx_formats(xls)

tfr %>%
  dplyr::mutate(bold = tfr_format$local$font$bold[local_format_id]) %>%
  dplyr::filter(
    sheet == "по субъектам РФ с 2018 года",
    row > 5
  ) %>%
  unpivotr::behead("N", "year") %>%
  unpivotr::behead_if(!bold, direction = "W", name = "region") %>%
  dplyr::select(region, year, tfr = numeric) %>%
  tidyr::drop_na() %>%
  # IMPORTANT : remove Arkhangelsk Oblast and Tyumen Oblast because they agregate nearby autonomous regions
  dplyr::filter(region != "Архангельская область" & region != "Тюменская область") %>%
  dplyr::mutate(
    adm1_code = geotools::admincode(
      region,
      origin = "region.name.ru.regex",
      origin_regex = T,
      destination = "adm1",
      warn = F,
      country = "Russia"
    )
  ) %>% tidyr::drop_na() -> oc_russie_2019_fecondite

usethis::use_data(oc_russie_2019_fecondite, overwrite = T)


# Regional CBR and CDR ----------------------------------------------------

xls <- here::here("inst/extdata/oc_russie/rosstat/population/2021_cbr_cdr.xlsx")
nat_chg <- tidyxl::xlsx_cells(xls)
nat_chg_format <- tidyxl::xlsx_formats(xls)

nat_chg %>%
  dplyr::mutate(bold = nat_chg_format$local$font$bold[local_format_id]) %>%
  dplyr::filter(
    sheet == "Лист1",
    row > 2
  ) %>%
  unpivotr::behead("N", "type") %>%
  unpivotr::behead("N", "indicator") %>%
  unpivotr::behead_if(!bold, direction = "W", name = "region") %>%
  dplyr::select(region, type, indicator, data = numeric) %>%
  dplyr::mutate(
    type = dplyr::case_when(
      stringr::str_detect(type, "Всего")      ~ "absolute",
      stringr::str_detect(type, "населения")  ~ "per1000"
    ),
    indicator = dplyr::case_when (
      stringr::str_detect(indicator, "родившихся")   ~ "cbr",
      stringr::str_detect(indicator, "умерших")      ~ "cdr",
      stringr::str_detect(indicator, "естественный") ~ "rni"
    )
  ) %>%
  tidyr::drop_na(data) %>%
  # IMPORTANT : remove Arkhangelsk Oblast and Tyumen Oblast because they agregate nearby autonomous regions
  dplyr::filter(region != "Архангельская область" & region != "Тюменская область") %>%
  tidyr::fill(type, .direction = "down") %>%
  dplyr::mutate(
    adm1_code = geotools::admincode(
      region,
      origin = "region.name.ru.regex",
      origin_regex = T,
      destination = "adm1",
      warn = F,
      country = "Russia"
    )
  ) -> oc_russie_2019_natalite_mortalite

usethis::use_data(oc_russie_2019_natalite_mortalite, overwrite = T)


# Regional suicide rates --------------------------------------------------

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2021_suicides.csv"),
  skip = 4L,
  col_names = c("region", "codes", 1990:2019)
) %>% dplyr::select(-region) %>%
  dplyr::mutate(
    adm1_code = geotools::admincode(
      codes,
      origin = "oktmo",
      destination = "adm1",
      warn = F,
      country = "Russia"
    ),
    region = geotools::admincode(
      codes,
      origin = "oktmo",
      destination = "region.name.en",
      warn = F,
      country = "Russia"
    )
  ) %>% tidyr::drop_na(region) %>%
  tidyr::pivot_longer(
    tidyselect::num_range("", 1990:2019),
    names_to = "year",
    values_to = "suicides"
  ) %>% tidyr::drop_na(suicides) -> oc_russie_suicides

usethis::use_data(oc_russie_suicides, overwrite = T)

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2021_suicides.csv"),
  skip = 4L,
  col_names = c("region", "codes", 1990:2019)
) %>% dplyr::select(-region) %>%
  dplyr::filter(codes == 643) %>%
  tidyr::pivot_longer(
    tidyselect::num_range("", 1990:2019),
    names_to = "year",
    values_to = "suicides"
  ) %>%
  dplyr::select(-codes) -> oc_russie_suicides_national

usethis::use_data(oc_russie_suicides_national, overwrite = T)


# Abortions ---------------------------------------------------------------

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2021_avortements.csv"),
  skip = 1L, locale = readr::locale(encoding = "windows-1251", decimal_mark = ",")
) %>%
  dplyr::select(-c(X1, X2)) %>%
  tidyr::pivot_longer(
    tidyselect::everything(),
    names_to = "year",
    names_transform = list("year" = readr::parse_number),
    values_to = "abortions"
  ) %>%
  # Change 2003 value (it seems completely wrong)
  # Based on Eberstadt (2010)
  dplyr::mutate(
    abortions = dplyr::case_when(
      year == 2003 ~ 121,
      TRUE         ~ abortions
    )
  ) -> oc_russie_avortements_national

usethis::use_data(oc_russie_avortements_national, overwrite = T)


# Births ------------------------------------------------------------------

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2021_births.csv"),
  skip = 1L, locale = readr::locale(encoding = "windows-1251", decimal_mark = ",")
) %>%
  dplyr::filter(X1 == "Российская Федерация") %>%
  dplyr::select(-c(X1, X2)) %>%
  tidyr::pivot_longer(
    tidyselect::everything(),
    names_to = "year",
    names_transform = list("year" = readr::parse_number),
    values_to = "births"
  ) -> oc_russie_naissances_national

usethis::use_data(oc_russie_naissances_national, overwrite = T)


# Municipality population -------------------------------------------------

fs::dir_ls("inst/extdata/oc_russie/rosstat/population/2021_pop_municipalities/") %>%
  purrr::map_dfr(
    .f = ~readr::read_csv(
      .x,
      skip = 4L,
      col_names = c("name", "oktmo", "2016", "2020"),
      col_types = "ccdd",
      locale = readr::locale(encoding = "windows-1251")
    )
  ) %>% tidyr::drop_na(`2016`:`2020`) %>%
  dplyr::mutate(oktmo = stringr::str_sub(oktmo, start = 1L, end = 8L)) -> oc_russie_2020_population_municipale

usethis::use_data(oc_russie_2020_population_municipale, overwrite = T)


# Population evolution ----------------------------------------------------

xls <- here::here("inst/extdata/oc_russie/rosstat/population/2021_pop_evolution.xlsx")
pop_evol <- tidyxl::xlsx_cells(xls)
pop_evol_format <- tidyxl::xlsx_formats(xls)

pop_evol %>%
  dplyr::filter(row > 1) %>%
  unpivotr::behead(direction = "up", name = "year") %>%
  unpivotr::behead(direction = "left", name = "region") %>%
  dplyr::mutate(character = dplyr::na_if(character, "00000000000")) %>%
  unpivotr::behead(direction = "left-up", name = "oktmo") %>%
  tidyr::drop_na(numeric, year) %>%
  dplyr::select(region, oktmo, year, population = numeric) %>%
  dplyr::mutate(year = readr::parse_number(year)) %>%
  dplyr::select(oktmo, year, population) %>%
  tidyr::pivot_wider(tidyselect::everything(), names_from = "year", values_from = "population") -> pop_evol_interm

# Tyumen and Arkhangelsk regions are not present independently for 1990
# The numbers must therefore be computed by hand. Yes, it's a bit messy
# but it's better than changing the original…

tyu_2020 <-
  pop_evol_interm %>% dplyr::filter(oktmo == "71000000000") %>% dplyr::pull(`1990`) -
  pop_evol_interm %>% dplyr::filter(oktmo == "71100000000") %>% dplyr::pull(`1990`) -
  pop_evol_interm %>% dplyr::filter(oktmo == "71140000000") %>% dplyr::pull(`1990`)

arkh_2020 <-
  pop_evol_interm %>% dplyr::filter(oktmo == "11000000000") %>% dplyr::pull(`1990`) -
  pop_evol_interm %>% dplyr::filter(oktmo == "11100000000") %>% dplyr::pull(`1990`)

pop_evol_interm %>%
  dplyr::mutate(
    `1990` = dplyr::case_when(
      is.na(`1990`) & oktmo == "11001000000" ~ arkh_2020,
      is.na(`1990`) & oktmo == "71001000000" ~ tyu_2020,
      TRUE ~ `1990`
    )
  ) %>%
  dplyr::mutate(
    adm1_code = geotools::admincode(
      oktmo,
      origin = "oktmo",
      destination = "adm1",
      warn = F,
      country = "Russia"
    ),
    region = geotools::admincode(
      oktmo,
      origin = "oktmo",
      destination = "region.name.en",
      warn = F,
      country = "Russia"
    )
  ) %>%
  tidyr::drop_na(region) %>%
  dplyr::mutate(solde = (`2020` - `1990`) / `2020` * 100) -> oc_russie_2020_evolution_population

usethis::use_data(oc_russie_2020_evolution_population, overwrite = T)


# Mariages ----------------------------------------------------------------

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2021_mariages.csv"),
  skip = 1L, locale = readr::locale(encoding = "windows-1251", decimal_mark = ",")
) %>%
  dplyr::rename(region = 1, oktmo = 2) %>%
  tidyr::pivot_longer(
    -c(region, oktmo),
    names_to = "year",
    names_transform = list(year = readr::parse_number),
    values_to = "mariages"
  ) %>%
  dplyr::mutate(
    adm1_code = geotools::admincode(
      oktmo,
      origin = "oktmo",
      destination = "adm1",
      warn = F,
      country = "Russia"
    ),
    region = geotools::admincode(
      oktmo,
      origin = "oktmo",
      destination = "region.name.en",
      warn = F,
      country = "Russia"
    )
  ) %>%
  tidyr::drop_na() -> oc_russie_mariages

usethis::use_data(oc_russie_mariages, overwrite = T)

# Divorces ----------------------------------------------------------------

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2021_divorces.csv"),
  skip = 1L, locale = readr::locale(encoding = "windows-1251", decimal_mark = ",")
) %>%
  dplyr::rename(region = 1, oktmo = 2) %>%
  tidyr::pivot_longer(
    -c(region, oktmo),
    names_to = "year",
    names_transform = list(year = readr::parse_number),
    values_to = "divorces"
  ) %>%
  dplyr::mutate(
    adm1_code = geotools::admincode(
      oktmo,
      origin = "oktmo",
      destination = "adm1",
      warn = F,
      country = "Russia"
    ),
    region = geotools::admincode(
      oktmo,
      origin = "oktmo",
      destination = "region.name.en",
      warn = F,
      country = "Russia"
    )
  ) %>%
  tidyr::drop_na() -> oc_russie_divorces

usethis::use_data(oc_russie_divorces, overwrite = T)


# Divorces et mariages (absolu) -------------------------------------------

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2021_divorces_absolu.csv"),
  skip = 1L, locale = readr::locale(encoding = "windows-1251", decimal_mark = ",")
) %>%
  dplyr::rename(region = 1, oktmo = 2) %>%
  tidyr::pivot_longer(
    -c(region, oktmo),
    names_to = "year",
    names_transform = list(year = readr::parse_number),
    values_to = "divorces"
  ) %>%
  dplyr::filter(region != "все население") %>%
  dplyr::mutate(
    adm1_code = geotools::admincode(
      oktmo,
      origin = "oktmo",
      destination = "adm1",
      warn = F,
      country = "Russia"
    ),
    region = geotools::admincode(
      oktmo,
      origin = "oktmo",
      destination = "region.name.en",
      warn = F,
      country = "Russia"
    )
  ) -> divorces

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2021_mariages_absolu.csv"),
  skip = 1L, locale = readr::locale(encoding = "windows-1251", decimal_mark = ",")
) %>%
  dplyr::rename(region = 1, oktmo = 2) %>%
  tidyr::pivot_longer(
    -c(region, oktmo),
    names_to = "year",
    names_transform = list(year = readr::parse_number),
    values_to = "mariages"
  ) %>%
  dplyr::filter(region != "все население") %>%
  dplyr::mutate(
    adm1_code = geotools::admincode(
      oktmo,
      origin = "oktmo",
      destination = "adm1",
      warn = F,
      country = "Russia"
    ),
    region = geotools::admincode(
      oktmo,
      origin = "oktmo",
      destination = "region.name.en",
      warn = F,
      country = "Russia"
    )
  ) -> mariages

divorces %>%
  dplyr::left_join(
    mariages,
    by = c("region", "oktmo", "year", "adm1_code")
  ) -> mariages_divorces

mariages_divorces %>%
  tidyr::drop_na() -> oc_russie_mariages_divorces

# Utile que si on veut les chiffres absolue par régions…
# usethis::use_data(oc_russie_mariages_divorces, overwrite = T)

mariages_divorces %>%
  dplyr::filter(oktmo == "643") %>%
  dplyr::select(year, divorces, mariages) %>%
  tidyr::pivot_longer(
    -year,
    names_to = "indicator",
    values_to = "data"
  ) -> oc_russie_mariages_divorces_national

usethis::use_data(oc_russie_mariages_divorces_national, overwrite = T)


# Ethnic groups -----------------------------------------------------------
# ICOMPLETE Work…
# xml2::read_html("inst/extdata/oc_russie/rosstat/population/2021_ethnies.htm") %>%
#   rvest::html_table(fill = T) %>%
#   purrr::pluck(1) %>%
#   unpivotr::as_cells() %>%
#   unpivotr::behead(direction = "up", name = "Bla bla")


# Migration arrivals ------------------------------------------------------

xml2::read_html("inst/extdata/oc_russie/rosstat/population/2021_migration.html") %>%
  rvest::html_table() %>%
  purrr::pluck(1) %>%
  unpivotr::as_cells() %>%
  dplyr::filter(row > 3) %>%
  unpivotr::behead_if(stringr::str_detect(chr, "total"), direction = "left-up", name = "type") %>%
  unpivotr::behead(direction = "up", name = "year") %>%
  unpivotr::behead(direction = "left", name = "country") %>%
  dplyr::mutate(data = ifelse(is.na(chr), int, chr)) %>%
  dplyr::mutate(
    data = dplyr::case_when(
      data == "one"           ~ "1",
      data == "four"          ~ "4",
      data == "five"          ~ "5",
      data == "ten"           ~ "10",
      data == "eleven"        ~ "11",
      data == "thirteen"      ~ "13",
      data == "eighteen"      ~ "18",
      data == "thirty"        ~ "30",
      data == "fifty"         ~ "50",
      data == "one hundred"   ~ "100",
      data == "..."           ~ NA_character_,
      data == "-"             ~ NA_character_,
      TRUE                    ~ data
    )
  ) %>%
  dplyr::mutate(data = readr::parse_number(data)) %>%
  dplyr::mutate(
    type = dplyr::case_when(
      stringr::str_detect(type, "Arrived")    ~ "arrival",
      stringr::str_detect(type, "Departed")   ~ "departure"
    )
  ) %>%
  dplyr::mutate(adm1_code = countrycode::countrycode(
    country, "country.name", "iso3c",
    origin_regex = TRUE, warn = F
  )) %>%
  tidyr::drop_na(adm1_code) %>%
  dplyr::select(adm1_code, country, year, type, migration = data) -> oc_russie_2019_migration

usethis::use_data(oc_russie_2019_migration, overwrite = T)

# Open documentation file -------------------------------------------------

usethis::edit_file(here::here("R/data_doc_oc_russie.R"))
