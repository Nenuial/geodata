#' Suffrage féminin en suisse
#'
#' Un tableau des années d'introduction du suffrage féminin en Suisse
#' par cantons.
#'
#' @format Un tibble avec 2 colonnes et 26 lignes
#' \describe{
#'   \item{Canton}{Nom du canton}
#'   \item{Annee}{Année de l'obtention du suffrage féminin}
#' }
#' @source <https://fr.wikipedia.org/wiki/Suffrage_féminin_en_Suisse>
"oc_suisse_suffrage_feminin"

#' Suffrage féminin au Valais
#'
#' Un tableau des résultats par districts du vote concernant le suffrage
#' féminin au Valais le 12 avril 1970.
#'
#' @format Un tibble avec 3 colonnes et 13 lignes
#' \describe{
#'   \item{id}{Identifiant OFS du district}
#'   \item{vote_oui}{Nombre de vote oui}
#'   \item{vote_non}{Nombre de vote non}
#' }
#' @source <https://www.letempsarchives.ch/page/GDL_1970_04_13/9>
"oc_suisse_1970_04_12_suffrage_feminin_vs"

#' Immigration italienne
#'
#' Un tableau avec les chiffres de la population et de l'immigration italienne
#' en Suisse de 1981 à 2019.
#'
#' @format Un tibble avec 3 colonnes et 39 lignes
#' \describe{
#'   \item{year}{Année d'observation}
#'   \item{population}{Population résidante italienne en Suisse au 1er janvier}
#'   \item{immigration}{Immigration italienne en Suisse}
#' }
#' @source <https://www.pxweb.bfs.admin.ch/pxweb/fr/px-x-0103010000_151/-/px-x-0103010000_151.px/>
"oc_suisse_2021_immigration_italienne"

#' Religion par commune
#'
#' Un tableau avec le pourcentage des religions par commune
#' en Suisse en 2000. Oui c'est vieux, mais visiblement l'OFS
#' n'a pas de données après le dernier recensement...
#'
#' @format Un tibble avec 4 colonnes et 55024 lignes
#' \describe{
#'   \item{ID}{Identifiant de la commune}
#'   \item{Commune}{Nom de la commune}
#'   \item{Religion}{Religion}
#'   \item{Pourcentage}{Pourcentage}
#' }
#' @source <https://www.pxweb.bfs.admin.ch/pxweb/fr/px-x-0103010000_151/-/px-x-0103010000_151.px/>
"oc_suisse_2000_religion"

#' Nationalite en Suisse
#'
#' Un tableau avec le nombre de personnes par nationalité
#' en Suisse en 2023.
#'
#' @format Un tibble avec 2 colonnes et 210 lignes
#' \describe{
#'   \item{Nationalite}{La nationalité}
#'   \item{Population}{Population (chiffre absolu)}
#' }
#' @source <https://www.pxweb.bfs.admin.ch/pxweb/fr/px-x-0103010000_151/-/px-x-0103010000_151.px/>
"oc_suisse_2023_nationalite"
