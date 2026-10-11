stop("This file should not be sourced!")

# Rosstat showdata -------------------------------------------------------

# The CSV export of showdata is assembled in the browser, so the original data
# is the answer of the OLAP preview (report, headers and data), saved as JSON.
# Rosstat uses the Russian state root certificate: no certificate check.
# Some tables are broken: report 278974 (TFR 2019-2025) has up to three
# values per cell without any way to tell them apart, use 273532 instead.

showdata_download <- function(descr, years, path) {
  base <- "https://showdata.rosstat.gov.ru"
  cookies <- tempfile()
  request <- function(url) {
    httr2::request(base) |>
      httr2::req_url_path(url) |>
      httr2::req_options(ssl_verifypeer = 0) |>
      httr2::req_cookie_preserve(cookies) |>
      httr2::req_headers(
        `X-Requested-With` = "XMLHttpRequest",
        Referer = paste0(base, "/olap2/")
      )
  }

  report <- request(paste0("/olap2/olap2-descriptor-report/", descr, "/")) |>
    httr2::req_perform() |>
    httr2::resp_body_json()
  report$col_header[[1]]$children <- report$col_header[[1]]$children |>
    purrr::map(\(x) {
      if (x$descriptor == -64) x$values <- as.list(paste0(years, "-01-01 00:00:00|-52"))
      x
    })

  token <- readLines(cookies) |>
    stringr::str_subset("csrftoken") |>
    stringr::str_extract("[^\t]+$")
  preview <- function(url) {
    request(url) |>
      httr2::req_headers(`X-CSRFToken` = token) |>
      httr2::req_body_form(
        jkwargs = jsonlite::toJSON(report, auto_unbox = TRUE, null = "null"),
        user_conf = "{}"
      ) |>
      httr2::req_perform() |>
      httr2::resp_body_string() |>
      jsonlite::parse_json()
  }

  list(
    report = report,
    headers = preview("/olap2/olap2-preview/headers"),
    data = preview("/olap2/olap2-preview/data")
  ) |>
    jsonlite::write_json(path, auto_unbox = TRUE, null = "null", digits = NA)
}

# A tibble (codes, year, value) from a saved showdata preview
showdata_read <- function(path) {
  x <- jsonlite::read_json(path)
  # rows: the leaves of the row headers (regions under sex, settlement…)
  leaves <- function(rows) {
    purrr::map(rows, \(r) if (is.null(r$children)) r$extra_row_attrs$code else leaves(r$children)) |>
      unlist()
  }
  codes <- leaves(x$headers$reportHeaders$row_header)
  # column filters: "-64#eq#2024-01-01 00:00:00|-52" (the period)
  years <- x$headers$colFilters |>
    purrr::map_chr(\(f) stringr::str_subset(unlist(f), "^-64#")) |>
    stringr::str_extract("(?<=#eq#)\\d{4}") |>
    as.numeric()
  x$data$reportData$data |>
    purrr::imap(\(row, i) {
      tibble::tibble(
        codes = codes[i],
        year = years,
        value = purrr::map_dbl(row, \(cell) cell$db_value %||% NA_real_)
      )
    }) |>
    purrr::list_rbind()
}

# Regional life expectancy -----------------------------------------------

xls <- here::here("inst/extdata/oc_russie/rosstat/population/2021_life_expectancy.xlsx")
lex <- tidyxl::xlsx_cells(xls)
lex_format <- tidyxl::xlsx_formats(xls)

lex |>
  dplyr::mutate(bold = lex_format$local$font$bold[local_format_id]) |>
  dplyr::filter(row > 4) |>
  unpivotr::behead_if(!bold, direction = "left", name = "region") |>
  dplyr::select(region, lex = numeric) |>
  tidyr::drop_na() |>
  # IMPORTANT : remove Arkhangelsk Oblast and Tyumen Oblast because they agregate nearby autonomous regions
  dplyr::filter(region != "Архангельская область" & region != "Тюменская область") |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      region,
      origin = "region.name.ru.regex",
      origin_regex = TRUE,
      destination = "adm1",
      warn = FALSE,
      country = "Russia"
    )
  ) |>
  tidyr::drop_na() -> oc_russie_2019_esperance_vie

usethis::use_data(oc_russie_2019_esperance_vie, overwrite = TRUE)

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2024_life_expectancy.csv"),
  skip = 4L,
  col_names = c("region", "codes", 2016:2022),
  locale = readr::locale(decimal_mark = ",")
) |>
  dplyr::select(-region) |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      codes,
      origin = "oktmo",
      destination = "adm1",
      warn = FALSE,
      country = "Russia"
    ),
    region = geotools::gtl_admin_code(
      codes,
      origin = "oktmo",
      destination = "region.name.en",
      warn = FALSE,
      country = "Russia"
    )
  ) |>
  tidyr::drop_na(region) |>
  tidyr::pivot_longer(
    tidyselect::num_range("", 2016:2022),
    names_to = "year",
    values_to = "lex"
  ) |>
  tidyr::drop_na(lex) -> oc_russie_2022_esperance_vie

usethis::use_data(oc_russie_2022_esperance_vie, overwrite = TRUE)


# Regional fertility rates -----------------------------------------------

# The Main databank is missing Kemerovo Oblast (for whatever fucked up reason…)
# Source: https://showdata.gks.ru/report/278974
# So we use an alternative dataset.
# Source: https://rosstat.gov.ru/storage/mediabank/7-1(2).xlsx

xls <- here::here("inst/extdata/oc_russie/rosstat/population/2021_fertility_rates.xlsx")
tfr <- tidyxl::xlsx_cells(xls)
tfr_format <- tidyxl::xlsx_formats(xls)

tfr |>
  dplyr::mutate(bold = tfr_format$local$font$bold[local_format_id]) |>
  dplyr::filter(
    sheet == "по субъектам РФ с 2018 года",
    row > 5
  ) |>
  unpivotr::behead("N", "year") |>
  unpivotr::behead_if(!bold, direction = "W", name = "region") |>
  dplyr::select(region, year, tfr = numeric) |>
  tidyr::drop_na() |>
  # IMPORTANT : remove Arkhangelsk Oblast and Tyumen Oblast because they agregate nearby autonomous regions
  dplyr::filter(region != "Архангельская область" & region != "Тюменская область") |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      region,
      origin = "region.name.ru.regex",
      origin_regex = TRUE,
      destination = "adm1",
      warn = FALSE,
      country = "Russia"
    )
  ) |>
  tidyr::drop_na() -> oc_russie_2019_fecondite

usethis::use_data(oc_russie_2019_fecondite, overwrite = TRUE)

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2024_fertility_rates.csv"),
  skip = 4L,
  col_names = c("region", "codes", 2017:2023),
  locale = readr::locale(decimal_mark = ",")
) |>
  dplyr::select(-region) |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      codes,
      origin = "oktmo",
      destination = "adm1",
      warn = FALSE,
      country = "Russia"
    ),
    region = geotools::gtl_admin_code(
      codes,
      origin = "oktmo",
      destination = "region.name.en",
      warn = FALSE,
      country = "Russia"
    )
  ) |>
  tidyr::drop_na(region) |>
  tidyr::pivot_longer(
    tidyselect::num_range("", 2017:2023),
    names_to = "year",
    values_to = "tfr"
  ) |>
  tidyr::drop_na(tfr) -> oc_russie_2023_fecondite

usethis::use_data(oc_russie_2023_fecondite, overwrite = TRUE)

# Source: https://showdata.rosstat.gov.ru/report/273532
showdata_download(
  273532, 2012:2024,
  here::here("inst/extdata/oc_russie/rosstat/population/2026_fertility_rates.json")
)

showdata_read(here::here("inst/extdata/oc_russie/rosstat/population/2026_fertility_rates.json")) |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      codes,
      origin = "oktmo",
      destination = "adm1",
      warn = FALSE,
      country = "Russia"
    ),
    region = geotools::gtl_admin_code(
      codes,
      origin = "oktmo",
      destination = "region.name.en",
      warn = FALSE,
      country = "Russia"
    )
  ) |>
  tidyr::drop_na(region) |>
  dplyr::mutate(year = as.character(year)) |>
  dplyr::select(codes, adm1_code, region, year, tfr = value) |>
  tidyr::drop_na(tfr) -> oc_russie_2024_fecondite

usethis::use_data(oc_russie_2024_fecondite, overwrite = TRUE)


# Regional CBR and CDR ---------------------------------------------------

xls <- here::here("inst/extdata/oc_russie/rosstat/population/2021_cbr_cdr.xlsx")
nat_chg <- tidyxl::xlsx_cells(xls)
nat_chg_format <- tidyxl::xlsx_formats(xls)

nat_chg |>
  dplyr::mutate(bold = nat_chg_format$local$font$bold[local_format_id]) |>
  dplyr::filter(
    sheet == "Лист1",
    row > 2
  ) |>
  unpivotr::behead("N", "type") |>
  unpivotr::behead("N", "indicator") |>
  unpivotr::behead_if(!bold, direction = "W", name = "region") |>
  dplyr::select(region, type, indicator, data = numeric) |>
  dplyr::mutate(
    type = dplyr::case_when(
      stringr::str_detect(type, "Всего") ~ "absolute",
      stringr::str_detect(type, "населения") ~ "per1000"
    ),
    indicator = dplyr::case_when(
      stringr::str_detect(indicator, "родившихся") ~ "cbr",
      stringr::str_detect(indicator, "умерших") ~ "cdr",
      stringr::str_detect(indicator, "естественный") ~ "rni"
    )
  ) |>
  tidyr::drop_na(data) |>
  # IMPORTANT : remove Arkhangelsk Oblast and Tyumen Oblast because they agregate nearby autonomous regions
  dplyr::filter(region != "Архангельская область" & region != "Тюменская область") |>
  tidyr::fill(type, .direction = "down") |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      region,
      origin = "region.name.ru.regex",
      origin_regex = TRUE,
      destination = "adm1",
      warn = FALSE,
      country = "Russia"
    )
  ) -> oc_russie_2019_natalite_mortalite

usethis::use_data(oc_russie_2019_natalite_mortalite, overwrite = TRUE)

# Regional RNI -----------------------------------------------------------

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2024_natural_increase.csv"),
  skip = 4L,
  col_names = c("region", "codes", 2017:2023),
  locale = readr::locale(decimal_mark = ",")
) |>
  dplyr::select(-region) |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      codes,
      origin = "oktmo",
      destination = "adm1",
      warn = FALSE,
      country = "Russia"
    ),
    region = geotools::gtl_admin_code(
      codes,
      origin = "oktmo",
      destination = "region.name.en",
      warn = FALSE,
      country = "Russia"
    )
  ) |>
  tidyr::drop_na(region) |>
  tidyr::pivot_longer(
    tidyselect::num_range("", 2017:2023),
    names_to = "year",
    values_to = "rni"
  ) |>
  tidyr::drop_na(rni) -> oc_russie_2023_accroissement

usethis::use_data(oc_russie_2023_accroissement, overwrite = TRUE)

# showdata stops in 2023 (report 297732). 2024: natural increase and mean
# population of the population estimate (rate = increase / mean population,
# the definition of Rosstat).
# Source: https://rosstat.gov.ru/storage/mediabank/OkPopul_Comp2025_Site.xlsx
# (https://rosstat.gov.ru/folder/12781)

readxl::read_excel(
  here::here("inst/extdata/oc_russie/rosstat/population/2026_population_components.xlsx"),
  sheet = "Всего",
  skip = 7L,
  col_names = c("region_ru", "pop_2024", "change", "natural", "migration", "mtp", "pop_2025", "pop_mean"),
  col_types = c("text", rep("numeric", 7))
) |>
  tidyr::drop_na(pop_mean) |>
  # IMPORTANT : remove Arkhangelsk Oblast and Tyumen Oblast because they agregate nearby autonomous regions
  dplyr::filter(region_ru != "Архангельская область" & region_ru != "Тюменская область") |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      region_ru,
      origin = "region.name.ru.regex",
      origin_regex = TRUE,
      destination = "adm1",
      warn = FALSE,
      country = "Russia"
    ),
    region = geotools::gtl_admin_code(
      adm1_code,
      origin = "adm1",
      destination = "region.name.en",
      warn = FALSE,
      country = "Russia"
    ),
    codes = geotools::gtl_admin_code(
      adm1_code,
      origin = "adm1",
      destination = "oktmo",
      warn = FALSE,
      country = "Russia"
    ),
    year = "2024",
    rni = round(natural / pop_mean * 1000, 1)
  ) |>
  tidyr::drop_na(adm1_code) |>
  dplyr::select(codes, adm1_code, region, year, rni) -> rni_2024

oc_russie_2023_accroissement |>
  dplyr::bind_rows(rni_2024) |>
  dplyr::arrange(codes, year) -> oc_russie_2024_accroissement

usethis::use_data(oc_russie_2024_accroissement, overwrite = TRUE)

# Regional suicide rates -------------------------------------------------

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2021_suicides.csv"),
  skip = 4L,
  col_names = c("region", "codes", 1990:2019)
) |>
  dplyr::select(-region) |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      codes,
      origin = "oktmo",
      destination = "adm1",
      warn = FALSE,
      country = "Russia"
    ),
    region = geotools::gtl_admin_code(
      codes,
      origin = "oktmo",
      destination = "region.name.en",
      warn = FALSE,
      country = "Russia"
    )
  ) |>
  tidyr::drop_na(region) |>
  tidyr::pivot_longer(
    tidyselect::num_range("", 1990:2019),
    names_to = "year",
    values_to = "suicides"
  ) |>
  tidyr::drop_na(suicides) -> oc_russie_suicides

usethis::use_data(oc_russie_suicides, overwrite = TRUE)

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2021_suicides.csv"),
  skip = 4L,
  col_names = c("region", "codes", 1990:2019)
) |>
  dplyr::select(-region) |>
  dplyr::filter(codes == 643) |>
  tidyr::pivot_longer(
    tidyselect::num_range("", 1990:2019),
    names_to = "year",
    values_to = "suicides"
  ) |>
  dplyr::select(-codes) -> oc_russie_suicides_national

usethis::use_data(oc_russie_suicides_national, overwrite = TRUE)


# Abortions --------------------------------------------------------------

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2021_avortements.csv"),
  skip = 1L, locale = readr::locale(encoding = "windows-1251", decimal_mark = ",")
) |>
  dplyr::select(-c(1, 2)) |>
  tidyr::pivot_longer(
    tidyselect::everything(),
    names_to = "year",
    names_transform = list("year" = readr::parse_number),
    values_to = "abortions"
  ) |>
  # Change 2003 value (it seems completely wrong)
  # Based on Eberstadt (2010)
  dplyr::mutate(
    abortions = dplyr::case_when(
      year == 2003 ~ 121,
      TRUE ~ abortions
    )
  ) -> avortements_officiel


# Births -----------------------------------------------------------------

# showdata: births until 2023 (both sexes, whole population: the default of
# report 297696). 2024: operational data (January-December 2024, table 1.2)
# Source: https://showdata.rosstat.gov.ru/olap2/descr/report/297696/
# Source: https://rosstat.gov.ru/storage/mediabank/Edn_12-2024_t1_2.xlsx

showdata_download(
  297696, 1990:2023,
  here::here("inst/extdata/oc_russie/rosstat/population/2026_births.json")
)

readxl::read_excel(
  here::here("inst/extdata/oc_russie/rosstat/population/2026_vital_events_2024.xlsx"),
  skip = 6L,
  col_names = FALSE,
  .name_repair = "minimal"
) |>
  dplyr::select(region = 1, births = 2) |>
  dplyr::filter(region == "Российская Федерация") |>
  dplyr::transmute(year = 2024, births) -> births_2024

showdata_read(here::here("inst/extdata/oc_russie/rosstat/population/2026_births.json")) |>
  dplyr::filter(codes == "643") |>
  dplyr::select(year, births = value) |>
  tidyr::drop_na(births) |>
  dplyr::bind_rows(births_2024) -> oc_russie_naissances_national

usethis::use_data(oc_russie_naissances_national, overwrite = TRUE)


# Abortions (2) ----------------------------------------------------------

# Abortions per 100 births are no longer published after 2017 (missing for
# 2016). They are computed from the number of abortions (pregnancy
# terminations) and the number of births; official values are kept when they
# exist (per 100 deliveries: a few tenths lower than this computation).
# Source: https://rosstat.gov.ru/storage/mediabank/chislo_prer_beremen_2024.xlsx
# (https://rosstat.gov.ru/folder/13721)

readxl::read_excel(
  here::here("inst/extdata/oc_russie/rosstat/population/2026_abortions.xlsx"),
  col_names = FALSE,
  .name_repair = "minimal"
) -> abortions_raw

abortions_raw[4, ] |>
  unlist() |>
  # years with footnotes: "20221)" (without the annexed regions of Ukraine)
  purrr::set_names(abortions_raw[3, ] |> unlist() |> stringr::str_sub(1L, 4L)) |>
  utils::tail(-1) |>
  tibble::enframe(name = "year", value = "total") |>
  dplyr::mutate(year = as.numeric(year), total = as.numeric(total)) -> abortions_total

abortions_total |>
  dplyr::inner_join(oc_russie_naissances_national, by = "year") |>
  dplyr::mutate(computed = round(total / births * 100, 1)) |>
  dplyr::select(year, computed) |>
  dplyr::full_join(avortements_officiel, by = "year") |>
  dplyr::mutate(abortions = dplyr::coalesce(abortions, computed)) |>
  dplyr::select(year, abortions) |>
  dplyr::arrange(year) -> oc_russie_avortements_national

usethis::use_data(oc_russie_avortements_national, overwrite = TRUE)


# Municipality population ------------------------------------------------

fs::dir_ls("inst/extdata/oc_russie/rosstat/population_mun/") |>
  purrr::map_dfr(
    .f = ~ readr::read_csv(
      .x,
      skip = 4L,
      col_names = c("name", "oktmo", "2016", "2020"),
      col_types = "ccdd",
      locale = readr::locale(encoding = "windows-1251")
    )
  ) |>
  tidyr::drop_na(`2016`:`2020`) |>
  dplyr::mutate(oktmo = stringr::str_sub(oktmo, start = 1L, end = 8L)) -> oc_russie_2020_population_municipale

usethis::use_data(oc_russie_2020_population_municipale, overwrite = TRUE)

# Population evolution ---------------------------------------------------

xls <- here::here("inst/extdata/oc_russie/rosstat/population/2021_pop_evolution.xlsx")
pop_evol <- tidyxl::xlsx_cells(xls)
pop_evol_format <- tidyxl::xlsx_formats(xls)

pop_evol |>
  dplyr::filter(row > 1) |>
  unpivotr::behead(direction = "up", name = "year") |>
  unpivotr::behead(direction = "left", name = "region") |>
  dplyr::mutate(character = dplyr::na_if(character, "00000000000")) |>
  unpivotr::behead(direction = "left-up", name = "oktmo") |>
  tidyr::drop_na(numeric, year) |>
  dplyr::select(region, oktmo, year, population = numeric) |>
  dplyr::mutate(year = readr::parse_number(year)) |>
  dplyr::select(oktmo, year, population) |>
  tidyr::pivot_wider(tidyselect::everything(), names_from = "year", values_from = "population") -> pop_evol_interm

# Tyumen and Arkhangelsk regions are not present independently for 1990
# The numbers must therefore be computed by hand. Yes, it's a bit messy
# but it's better than changing the original…

tyu_2020 <-
  pop_evol_interm |>
  dplyr::filter(oktmo == "71000000000") |>
  dplyr::pull(`1990`) -
  pop_evol_interm |>
  dplyr::filter(oktmo == "71100000000") |>
  dplyr::pull(`1990`) -
  pop_evol_interm |>
  dplyr::filter(oktmo == "71140000000") |>
  dplyr::pull(`1990`)

arkh_2020 <-
  pop_evol_interm |>
  dplyr::filter(oktmo == "11000000000") |>
  dplyr::pull(`1990`) -
  pop_evol_interm |>
  dplyr::filter(oktmo == "11100000000") |>
  dplyr::pull(`1990`)

pop_evol_interm |>
  dplyr::mutate(
    `1990` = dplyr::case_when(
      is.na(`1990`) & oktmo == "11001000000" ~ arkh_2020,
      is.na(`1990`) & oktmo == "71001000000" ~ tyu_2020,
      TRUE ~ `1990`
    )
  ) |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      oktmo,
      origin = "oktmo",
      destination = "adm1",
      warn = FALSE,
      country = "Russia"
    ),
    region = geotools::gtl_admin_code(
      oktmo,
      origin = "oktmo",
      destination = "region.name.en",
      warn = FALSE,
      country = "Russia"
    )
  ) |>
  tidyr::drop_na(region) |>
  dplyr::mutate(solde = (`2020` - `1990`) / `2020` * 100) -> oc_russie_2020_evolution_population

usethis::use_data(oc_russie_2020_evolution_population, overwrite = TRUE)

readxl::read_excel(
  here::here("inst/extdata/oc_russie/rosstat/population/2024_population.xlsx"),
  skip = 4L,
  col_names = c("region", "codes", 1990:2023),
) |>
  dplyr::select(-region) |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      codes,
      origin = "oktmo",
      destination = "adm1",
      warn = FALSE,
      country = "Russia"
    ),
    region = geotools::gtl_admin_code(
      codes,
      origin = "oktmo",
      destination = "region.name.en",
      warn = FALSE,
      country = "Russia"
    )
  ) |>
  tidyr::drop_na(region) |>
  tidyr::pivot_longer(
    tidyselect::num_range("", 1990:2023),
    names_to = "year",
    values_to = "pop"
  ) |>
  tidyr::drop_na(pop) -> oc_russie_2023_population

usethis::use_data(oc_russie_2023_population, overwrite = TRUE)

# Mariages ---------------------------------------------------------------

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2021_mariages.csv"),
  skip = 1L, locale = readr::locale(encoding = "windows-1251", decimal_mark = ",")
) |>
  dplyr::rename(region = 1, oktmo = 2) |>
  tidyr::pivot_longer(
    -c(region, oktmo),
    names_to = "year",
    names_transform = list(year = readr::parse_number),
    values_to = "mariages"
  ) |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      oktmo,
      origin = "oktmo",
      destination = "adm1",
      warn = FALSE,
      country = "Russia"
    ),
    region = geotools::gtl_admin_code(
      oktmo,
      origin = "oktmo",
      destination = "region.name.en",
      warn = FALSE,
      country = "Russia"
    )
  ) |>
  tidyr::drop_na() -> oc_russie_mariages

usethis::use_data(oc_russie_mariages, overwrite = TRUE)

# Divorces ---------------------------------------------------------------

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2021_divorces.csv"),
  skip = 1L, locale = readr::locale(encoding = "windows-1251", decimal_mark = ",")
) |>
  dplyr::rename(region = 1, oktmo = 2) |>
  tidyr::pivot_longer(
    -c(region, oktmo),
    names_to = "year",
    names_transform = list(year = readr::parse_number),
    values_to = "divorces"
  ) |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      oktmo,
      origin = "oktmo",
      destination = "adm1",
      warn = FALSE,
      country = "Russia"
    ),
    region = geotools::gtl_admin_code(
      oktmo,
      origin = "oktmo",
      destination = "region.name.en",
      warn = FALSE,
      country = "Russia"
    )
  ) |>
  tidyr::drop_na() -> oc_russie_divorces

usethis::use_data(oc_russie_divorces, overwrite = TRUE)


# Divorces et mariages (absolu) ------------------------------------------

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2021_divorces_absolu.csv"),
  skip = 1L, locale = readr::locale(encoding = "windows-1251", decimal_mark = ",")
) |>
  dplyr::rename(region = 1, oktmo = 2) |>
  tidyr::pivot_longer(
    -c(region, oktmo),
    names_to = "year",
    names_transform = list(year = readr::parse_number),
    values_to = "divorces"
  ) |>
  dplyr::filter(region != "все население") |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      oktmo,
      origin = "oktmo",
      destination = "adm1",
      warn = FALSE,
      country = "Russia"
    ),
    region = geotools::gtl_admin_code(
      oktmo,
      origin = "oktmo",
      destination = "region.name.en",
      warn = FALSE,
      country = "Russia"
    )
  ) -> divorces

readr::read_csv(
  here::here("inst/extdata/oc_russie/rosstat/population/2021_mariages_absolu.csv"),
  skip = 1L, locale = readr::locale(encoding = "windows-1251", decimal_mark = ",")
) |>
  dplyr::rename(region = 1, oktmo = 2) |>
  tidyr::pivot_longer(
    -c(region, oktmo),
    names_to = "year",
    names_transform = list(year = readr::parse_number),
    values_to = "mariages"
  ) |>
  dplyr::filter(region != "все население") |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      oktmo,
      origin = "oktmo",
      destination = "adm1",
      warn = FALSE,
      country = "Russia"
    ),
    region = geotools::gtl_admin_code(
      oktmo,
      origin = "oktmo",
      destination = "region.name.en",
      warn = FALSE,
      country = "Russia"
    )
  ) -> mariages

divorces |>
  dplyr::left_join(
    mariages,
    by = c("region", "oktmo", "year", "adm1_code")
  ) -> mariages_divorces

mariages_divorces |>
  tidyr::drop_na() -> oc_russie_mariages_divorces

# Utile que si on veut les chiffres absolue par régions…
# usethis::use_data(oc_russie_mariages_divorces, overwrite = T)

mariages_divorces |>
  dplyr::filter(oktmo == "643") |>
  dplyr::select(year, divorces, mariages) |>
  tidyr::pivot_longer(
    -year,
    names_to = "indicator",
    values_to = "data"
  ) -> oc_russie_mariages_divorces_national

usethis::use_data(oc_russie_mariages_divorces_national, overwrite = TRUE)


# Ethnic groups ----------------------------------------------------------
# ICOMPLETE Work…
# xml2::read_html("inst/extdata/oc_russie/rosstat/population/2021_ethnies.htm") |>
#   rvest::html_table(fill = T) |>
#   purrr::pluck(1) |>
#   unpivotr::as_cells() |>
#   unpivotr::behead(direction = "up", name = "Bla bla")


# Migration arrivals -----------------------------------------------------

xml2::read_html("inst/extdata/oc_russie/rosstat/population/2021_migration.html") |>
  rvest::html_table() |>
  purrr::pluck(1) |>
  unpivotr::as_cells() |>
  dplyr::filter(row > 3) |>
  unpivotr::behead_if(stringr::str_detect(chr, "total"), direction = "left-up", name = "type") |>
  unpivotr::behead(direction = "up", name = "year") |>
  unpivotr::behead(direction = "left", name = "country") |>
  dplyr::mutate(data = ifelse(is.na(chr), int, chr)) |>
  dplyr::mutate(
    data = dplyr::case_when(
      data == "one" ~ "1",
      data == "four" ~ "4",
      data == "five" ~ "5",
      data == "ten" ~ "10",
      data == "eleven" ~ "11",
      data == "thirteen" ~ "13",
      data == "eighteen" ~ "18",
      data == "thirty" ~ "30",
      data == "fifty" ~ "50",
      data == "one hundred" ~ "100",
      data == "..." ~ NA_character_,
      data == "-" ~ NA_character_,
      TRUE ~ data
    )
  ) |>
  dplyr::mutate(data = readr::parse_number(data)) |>
  dplyr::mutate(
    type = dplyr::case_when(
      stringr::str_detect(type, "Arrived") ~ "arrival",
      stringr::str_detect(type, "Departed") ~ "departure"
    )
  ) |>
  dplyr::mutate(adm1_code = countrycode::countrycode(
    country, "country.name", "iso3c",
    origin_regex = TRUE, warn = FALSE
  )) |>
  tidyr::drop_na(adm1_code) |>
  dplyr::select(adm1_code, country, year, type, migration = data) -> oc_russie_2019_migration

usethis::use_data(oc_russie_2019_migration, overwrite = TRUE)


# Levada : attitude toward countries -------------------------------------

rvest::read_html("https://www.levada.ru/en/ratings/attitudes-towards-countries/") |>
  rvest::html_table(header = TRUE) -> levada_attitudes_tables

levada_attitudes_tables |>
  purrr::pluck(1) |>
  dplyr::rename("attitude" = 1) |>
  dplyr::bind_cols(
    levada_attitudes_tables |>
      purrr::pluck(2)
  ) |>
  dplyr::rename("03.2003" = "03.2003...35", "05.2003" = "05.2003...38") |>
  dplyr::select(-c("03.2003...36", "05.2003...39")) -> levada_attitude_us

levada_attitudes_tables |>
  purrr::pluck(3) |>
  dplyr::rename("attitude" = 1) |>
  dplyr::bind_cols(levada_attitudes_tables |> purrr::pluck(4)) -> levada_attitude_eu

levada_attitude_us |>
  tidyr::pivot_longer(-c("attitude"), names_to = "date", values_to = "percentage") |>
  dplyr::mutate(date = lubridate::parse_date_time(date, "m.Y")) -> oc_russie_levada_attitude_us

levada_attitude_eu |>
  tidyr::pivot_longer(-c("attitude"), names_to = "date", values_to = "percentage") |>
  dplyr::mutate(date = lubridate::parse_date_time(date, "m.Y")) -> oc_russie_levada_attitude_eu

usethis::use_data(oc_russie_levada_attitude_us, overwrite = TRUE)
usethis::use_data(oc_russie_levada_attitude_eu, overwrite = TRUE)


# SIPRI Military expenditure ---------------------------------------------

sipri_milexpd_excel <- here::here("inst/extdata/oc_russie/sipri/SIPRI-Milex-data-2000-2022.xlsx")
cells <- tidyxl::xlsx_cells(sipri_milexpd_excel)
formats <- tidyxl::xlsx_formats(sipri_milexpd_excel)

cells |>
  dplyr::filter(sheet == "Current US$") |>
  dplyr::filter(row >= 6) |>
  unpivotr::behead(direction = "up", name = "year") |>
  unpivotr::behead_if(formats$local$font$bold[local_format_id],
    direction = "left-up", name = "region"
  ) |>
  unpivotr::behead(direction = "left", name = "country") |>
  dplyr::filter(!is.na(numeric)) |>
  dplyr::select(country, year, military_expenditure = numeric) |>
  dplyr::filter(country != "Kosovo") |>
  dplyr::mutate(iso3c = countrycode::countrycode(
    country,
    origin = "country.name",
    destination = "iso3c"
  )) |>
  dplyr::mutate(year = as.numeric(year)) -> oc_russie_depenses_militaires

usethis::use_data(oc_russie_depenses_militaires, overwrite = TRUE)


# Religion ---------------------------------------------------------------

arena_religion <- here::here("inst/extdata/oc_russie/arena/religion.xlsx")
cells <- tidyxl::xlsx_cells(arena_religion)
formats <- tidyxl::xlsx_formats(arena_religion)

cells |>
  unpivotr::behead(direction = "up", name = "region") |>
  unpivotr::behead(direction = "left", name = "religion") |>
  dplyr::select(region, religion, percent = numeric) |>
  tidyr::drop_na(religion, region) |>
  dplyr::mutate(
    adm1_code = geotools::gtl_admin_code(
      region,
      origin = "region.name.en.regex",
      destination = "adm1",
      country = "Russia",
      origin_regex = TRUE,
      custom_match = c(
        "Udmurt Republic" = "RUS-2387",
        "Yaroslavl region" = "RUS-2360"
      )
    )
  ) |>
  tidyr::drop_na(adm1_code) -> oc_russie_2012_religion

usethis::use_data(oc_russie_2012_religion, overwrite = TRUE)


# Population composition (ethnicity) -------------------------------------

pop_composition <- here::here("inst/extdata/oc_russie/rosstat/population/2020_population_composition.xlsx")
cells <- tidyxl::xlsx_cells(pop_composition)
formats <- tidyxl::xlsx_formats(pop_composition)

cells |>
  dplyr::filter(row > 4 & row < 203) |>
  dplyr::filter(sheet == " Fédération de Russie") |>
  unpivotr::behead(direction = "up-left", name = "type_pop") |>
  unpivotr::behead(direction = "up", name = "sexe") |>
  unpivotr::behead(direction = "left", name = "ethnie") |>
  dplyr::select(type_pop, sexe, ethnie, population = numeric) |>
  tidyr::drop_na(population) |>
  dplyr::mutate(ethnie = stringr::str_trim(ethnie)) |>
  tidyr::extract(
    ethnie,
    into = c("ethnie", "ethnie_detail"),
    regex = r"{(.*?)\s?\((.*)\)}"
  ) -> oc_russie_2020_population_composition

usethis::use_data(oc_russie_2020_population_composition, overwrite = TRUE)


# NATO Membership --------------------------------------------------------

oc_russie_otan <- readr::read_csv(
  here::here("inst/extdata/nato/nato_members.csv"),
  col_types = "cci"
)

usethis::use_data(oc_russie_otan, overwrite = TRUE)


# Ukraine elections ------------------------------------------------------

readxl::read_excel(
  "inst/extdata/oc_russie/ukraine/ukraine_elections.xlsx",
  sheet = "2010"
) -> oc_russie_2010_elections_ukraine

readxl::read_excel(
  "inst/extdata/oc_russie/ukraine/ukraine_elections.xlsx",
  sheet = "2014"
) -> oc_russie_2014_elections_ukraine

readxl::read_excel(
  "inst/extdata/oc_russie/ukraine/ukraine_elections.xlsx",
  sheet = "2019"
) -> oc_russie_2019_elections_ukraine

usethis::use_data(oc_russie_2010_elections_ukraine, overwrite = TRUE)
usethis::use_data(oc_russie_2014_elections_ukraine, overwrite = TRUE)
usethis::use_data(oc_russie_2019_elections_ukraine, overwrite = TRUE)


# Open documentation file ------------------------------------------------

usethis::edit_file(here::here("R/data_doc_oc_russie.R"))
