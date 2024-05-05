#' Consommation par source (kWh par personne)
#'
#' Un tableau avec la quantité d'énergie consommée par
#' personne pour tous les pays du monde (y compris des
#' données mondiales).
#'
#' @format Un tibble avec 5 colonnes et 38952 lignes
#' \describe{
#'   \item{entity}{Pays}
#'   \item{code}{Code ISO3c}
#'   \item{source}{Source d'énergie}
#'   \item{amount}{Quantité d'énergie (kWh par personne)}
#' }
#' @source <https://ourworldindata.org/grapher/per-capita-energy-stacked>
"oc_ecocitoyennete_energy_consumption_per_source"
