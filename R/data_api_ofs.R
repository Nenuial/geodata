#' Get the swiss vote list
#'
#' This function fetches the list of votes in Switzerland
#' from [OpenData.swiss](https://opendata.swiss/)
#'
#' @return A tibble
#' @export
#'
#' @examples
#' gdt_ofs_vote_list()
gdt_ofs_vote_list <- function() {
  api_call <- "https://opendata.swiss/api/3/action/package_show?id=echtzeitdaten-am-abstimmungstag-zu-eidgenoessischen-abstimmungsvorlagen"
  geotools::gtl_chk_api_call(api_call)

  data <- geotools::gtl_dwnl_api_json(api_call)

  data |>
    purrr::pluck("result", "resources") |>
    purrr::map_df(
      .f = function(x) {
        lang <- geotools::gtl_opt_short_language(valid = c("fr", "de", "it"))
        id <- purrr::pluck(x, "id")
        title <- purrr::pluck(x, "title", lang)
        date <- purrr::pluck(x, "coverage") |> lubridate::ymd()
        desc <- purrr::pluck(x, "description", lang)
        url <- purrr::pluck(x, "url")

        tibble::tribble(
          ~title, ~date, ~description, ~url,
          title, date, desc, url
        )
      }
    )
}
