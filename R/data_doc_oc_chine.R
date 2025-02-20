#' Population chinoise 2018 par sexe et régions
#'
#' Un tableau de la population des régions
#' de Chine par sexe pour 2018.
#'
#' @format Un tibble avec 6 colonnes et 31 lignes
#' \describe{
#'   \item{adm1_code}{Identifiant ADM1 (pour NaturalEarth)}
#'   \item{region}{Nom de la région}
#'   \item{population}{La population totale}
#'   \item{male}{La population féminine}
#'   \item{female}{La population masculine}
#'   \item{ratio}{Le ratio}
#' }
#' @source <http://www.stats.gov.cn/tjsj/ndsj/2019/html/E0211.jpg>
"oc_chine_2018_sex_ratio_par_region"

#' Population chinoise 2018 par sexe et régions
#'
#' Un tableau de la population des régions
#' de Chine par sexe pour 2018.
#'
#' @format Un tibble avec 3 colonnes et 202 lignes
#' \describe{
#'   \item{age}{Age de la population}
#'   \item{region}{Region `urban` ou `rural`}
#'   \item{genderbalance}{Nombre de femme moins le nombre d'homme}
#' }
#' @source <http://www.stats.gov.cn/tjsj/ndsj/2019/html/E0211.jpg>
"oc_chine_2010_gender_imbalance_by_age"
