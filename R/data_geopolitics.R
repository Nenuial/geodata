#' Table with the NATO membership
#' states by year and extensions
#'
#' @returns A tibble
#' @export
#'
#' @examples
#' gdt_nato_membership()
gdt_nato_membership <- function() {
  geodata::oc_russie_otan |>
    dplyr::mutate(
      extension = dplyr::case_match(
        year,
        1949 ~ geotools::gtl_translate_enfr("Founding states", "\u00c9tats fondateurs"),
        1952 ~ geotools::gtl_translate_enfr("First (1952", "Pemi\u00e8re (1952)"),
        1955 ~ geotools::gtl_translate_enfr("Second (1955)", "Deuxi\u00e8me (1955)"),
        1982 ~ geotools::gtl_translate_enfr("Third (1982", "Troisi\u00e8me (1982)"),
        1990 ~ geotools::gtl_translate_enfr(
          "Germand reunification (1990)",
          "R\u00e9unification de l'Allemagne (1990)"
        ),
        1999 ~ geotools::gtl_translate_enfr("Fourth (1999)", "Quatri\u00e8me (1999)"),
        2004 ~ geotools::gtl_translate_enfr("Fifth (2004)", "Cinqui\u00e8me (2004)"),
        2009 ~ geotools::gtl_translate_enfr("Sixth (2009)", "Sixi\u00e8me (2009)"),
        2017 ~ geotools::gtl_translate_enfr("Seventh (2017)", "Septi\u00e8me (2017)"),
        2020 ~ geotools::gtl_translate_enfr("Eigth (2020)", "Huiti\u00e8me (2020)"),
        2022 ~ geotools::gtl_translate_enfr("Ninth (2022)", "Neuvi\u00e8me (2022)"),
        2023 ~ geotools::gtl_translate_enfr("Tenth (2023)", "Dixi\u00e8me (2023)"),
        2024 ~ geotools::gtl_translate_enfr("Eleventh (2024)", "Onzi\u00e8me (2024)")
      )
    ) |>
    dplyr::mutate(
      extension = forcats::fct_inorder(extension)
    )
}
