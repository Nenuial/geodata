gdt_country_summary <- function(country) {
  tidywikidatar::tw_search(country) |>
    tw_filter_first(p = "P31", q = "Q6256") |>
    dplyr::pull(id) -> country_id

  country_id |>
    tidywikidatar::tw_get_label(language = "fr")

  country_id |>
    tidywikidatar::tw_get_p("P1082")

  country_id |>
    tidywikidatar::tw_get_qualifiers("P1082") -> population
}
