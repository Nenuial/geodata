#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

# Globals
utils::globalVariables(c(
  "id", "category", "gestation", "indications", "country_id",
  "datum", "abortion_rate", "year", "x", "pop", "age", "gender",
  "cohort", "vogenr", "vogeId", "mun_id", "geometry", "bezkId",
  "district_id", "kantId", "kantName", "canton_id", "name", "2-cbr",
  "3-cdr", "iso2c", "iso3c", "indicator", "address", "datacoverage",
  "iso", "maxdate", "mindate", "month", "util_dwnl_api_json", "value",
  "extension", "tw_filter_first"
))

# Suppress R CMD check note
# Namespace in Imports field not imported from: PKG
#   All declared Imports should be used.
ignore_unused_imports <- function() {
  # katex is necessary for rendering math
  # expressions in md columns in gt tables
  katex::katex_html
}

#' @importFrom rlang :=
#' @export
rlang::`:=`
