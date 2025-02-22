#' Table for the solution of the revolution speed of
#' a planet around the Sun
#'
#' @param name The name of the planet
#' @param au The distance of the planet to the Sun in AU
#' @param time The time for one revolution in Earth years
#'
#' @returns A gt table
#' @export
#'
#' @examples
#' gdt_df_cosmology_revolution_speed_solution("Earth", 1, 1)
gdt_df_cosmology_revolution_speed_solution <- function(name, au, time) {
  dist_sol <- au * 150e6
  dist_rev <- 2 * pi * dist_sol
  time_rev <- time * 365.2422 * 24
  speed_rev <- dist_rev / time_rev

  tab_dist_sol <- glue::glue("${au}\\text{{ AU}} \\cong {ggeo::ggeo_latex_sci_10(dist_sol)}\\text{{ km}}$")
  tab_dist_rev <- glue::glue("$2\\cdot\\pi\\cdot{ggeo::ggeo_latex_sci_10(dist_sol)}\\cong {ggeo::ggeo_latex_sci_10(dist_rev)}\\text{{ km}}$")
  tab_time_rev <- glue::glue("${time}\\text{{ years}}\\cong {time_rev}\\text{{ hours}}$")
  tab_speed_rev <- glue::glue("$\\frac{{{ggeo::ggeo_latex_sci_10(dist_rev)}}}{{{time_rev}}}\\cong {ggeo::ggeo_latex_sci_10(speed_rev)}\\text{{ km/h}}$")

  tibble::tribble(
    ~Information, ~Solution,
    "Distance to the Sun", tab_dist_sol,
    "Revolution distance ($d = 2\\pi r$)", tab_dist_rev,
    "Revolution period", tab_time_rev,
    "Revolution speed ($v=\\frac{{d}}{{t}}$)", tab_speed_rev
  ) |>
    gt::gt() |>
    gt::tab_spanner(
      label = name,
      columns = gt::everything()
    ) |>
    gt::cols_width(
      1 ~ gt::pct(40),
      2 ~ gt::pct(60)
    ) |>
    gt::cols_align(
      align = "left",
      columns = gt::everything()
    ) |>
    gt::fmt_markdown(columns = gt::everything()) |>
    gt::tab_options(
      # column_labels.hidden = TRUE,
      latex.use_longtable = TRUE,
      table.width = gt::pct(100)
    )
}
