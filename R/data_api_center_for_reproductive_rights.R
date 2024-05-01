#' Get abortion data from CRR
#' Get the data for every country from the Center
#' for Reproductive Rights.
#'
#' @return A tibble
#' @export
#' @examples
#' gdt_crr_get_data() -> reproductive_rights
#'
#' reproductive_rights |>
#'   head(5)
#'
gdt_crr_get_data <- function() {
  url <- "https://reproductiverights.org/wp-json/crr-maps/v1/wal?ver=1.0.17"

  url |>
    httr2::request() |>
    httr2::req_perform() |>
    httr2::resp_body_json() -> data

  data |>
    purrr::pluck("categories") |>
    purrr::transpose() |>
    tibble::as_tibble() -> categories_df

  data |>
    purrr::pluck("gestations") |>
    purrr::transpose() |>
    tibble::as_tibble() -> gestations_df

  data |>
    purrr::pluck("indications") |>
    purrr::transpose() |>
    tibble::as_tibble() -> indications_df

  data |>
    purrr::pluck("countries") |>
    purrr::transpose() |>
    tibble::as_tibble() -> countries

  countries |>
    dplyr::rowwise() |>
    dplyr::mutate(
      category = list(dplyr::filter(categories_df, id == category)),
      gestation = list(dplyr::filter(gestations_df, id %in% gestation)),
      indications = list(dplyr::filter(indications_df, id %in% indications))
    ) |>
    tidyr::unnest_wider(category, names_sep = "_") |>
    tidyr::unnest_wider(gestation, names_sep = "_")
}
