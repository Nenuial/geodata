#' OC Géo au féminin: Espérance de vie WPP2012
#'
#' Un tableau de l'espérance de vie selon les données WPP2012
#' par pays.
#'
#' @format Un tibble avec 5 colonnes et 236 lignes
#' \describe{
#'   \item{un_code}{Code pays UN}
#'   \item{period}{Période de l'estimation}
#'   \item{lexf}{Espérance de vie des femmes}
#'   \item{lexm}{Espérance de vie des hommes}
#'   \item{lexdelta}{Différence d'espérance de vie}
#' }
#' @source <https://population.un.org/wpp/>
"oc_geo_au_feminin_wpp2012_lex"

#' OC Géo au féminin: Espérance de vie WPP2019
#'
#' Un tableau de l'espérance de vie selon les données WPP2019
#' par pays.
#'
#' @format Un tibble avec 5 colonnes et 498 lignes
#' \describe{
#'   \item{un_code}{Code pays UN}
#'   \item{period}{Période de l'estimation}
#'   \item{lexf}{Espérance de vie des femmes}
#'   \item{lexm}{Espérance de vie des hommes}
#'   \item{lexdelta}{Différence d'espérance de vie}
#' }
#' @source <https://population.un.org/wpp/>
"oc_geo_au_feminin_wpp2019_lex"

#' OC Géo au féminin: Rapport des sexes
#'
#' Un tableau du rapport des sexes pour différentes années
#' selon les chiffres du WPP2019.
#'
#' @format Un tibble avec 7 colonnes et 78435 lignes
#' \describe{
#'   \item{un_code}{Code pays UN}
#'   \item{name}{Période de l'estimation}
#'   \item{age}{Tranche d'age}
#'   \item{year}{Année}
#'   \item{female}{Population féminine}
#'   \item{male}{Population masculine}
#'   \item{ratio}{Rapport hommes/femmes}
#' }
#' @source <https://population.un.org/wpp/>
"oc_geo_au_feminin_wpp2019_sex_ratio"

#' OC Géo au féminin: Avortement en Suisse
#'
#' Un tableau du taux d'avortement en Suisse
#' pour les adolescentes et les femmes en général
#' de 2005 à 2020.
#'
#' @format Un tibble avec 3 colonnes et 34 lignes
#' \describe{
#'   \item{year}{Année}
#'   \item{name}{Population}
#'   \item{rate}{Taux d'avortement (pour 1000 femmes)}
#' }
#' @source <https://www.bfs.admin.ch/bfs/fr/home/statistiques/sante/etat-sante/reproductive/interruptions-grossesses.html>
"oc_geo_au_feminin_2021_ofs_avortements"

#' OC Géo au féminin: Excision données indirectes
#'
#' Un tableau avec le nombre d'excisions dans des
#' pays ne fournissant pas de données directes (pays
#' pas directement concernés par la pratique).
#'
#' @format Un tibble avec 4 colonnes et 31 lignes
#' \describe{
#'   \item{Country}{Pays}
#'   \item{Girls_undergone_FGM}{Nombre de femmes qui ont subit une excision}
#'   \item{Legal_status}{Statut légal de l'excision}
#'   \item{iso}{Code ISO3c}
#' }
#' @source <https://equalitynow.org/fgm-a-global-picture/>
"oc_geo_au_feminin_2020_fgm_indirect_data"

#' OC Géo au féminin: Violences sexuelles expériences
#'
#' Un tableau avec les résultats du sondage gfs.bern de
#' 2019 en rapport avec les violences sexuelles. Réponses
#' concernant différentes expériences et le taux de femmes
#' qui ont déjà vécues cette situation.
#'
#' @format Un tibble avec 5 colonnes et 10 lignes
#' \describe{
#'   \item{Expérience}{Disciptif de l'expérience vécue}
#'   \item{oui}{Nombre de femmes qui ont répondues oui}
#'   \item{ambiguë}{Nombre de femmes qui ont répondues que la situation était ambiguë}
#'   \item{non}{Nombre de femmes qui ont répondues non}
#'   \item{non}{Nombre de femmes qui n'ont pas répondues ou qui ne savait pas}
#' }
#' @source <https://cockpit.gfsbern.ch/fr/cockpit/violence-sexuelles-en-suisse/>
"oc_geo_au_feminin_2019_gfs_violences_sexuelles_experiences"

#' OC Géo au féminin: Violences sexuelles actes
#'
#' Un tableau avec les résultats du sondage gfs.bern de
#' 2019 en rapport avec les violences sexuelles. Réponses
#' concernant différents actes et le taux de femmes
#' qui ont déjà vécues cette situation.
#'
#' @format Un tibble avec 2 colonnes et 6 lignes
#' \describe{
#'   \item{Acte}{Disciptif de l'acte}
#'   \item{Pourcentage}{Pourcentage de femmes qui ont répondues subit cet acte}
#' }
#' @source <https://cockpit.gfsbern.ch/fr/cockpit/violence-sexuelles-en-suisse/>
"oc_geo_au_feminin_2019_gfs_violences_sexuelles_actes"

#' OC Géo au féminin: Violences sexuelles police
#'
#' Un tableau avec les résultats du sondage gfs.bern de
#' 2019 en rapport avec les violences sexuelles. Réponses
#' concernant les raisons de ne pas contacter la police.
#'
#' @format Un tibble avec 4 colonnes et 6 lignes
#' \describe{
#'   \item{Raison}{La raison}
#'   \item{oui}{Pourcentage de femmes qui ont répondues que c'était une des raisons}
#'   \item{ne sait pas}{Pourcentage de femmes qui ont répondues que c'était une des raisons}
#'   \item{non}{Pourcentage de femmes qui ont répondues que ce n'était pas une des raisons}
#' }
#' @source <https://cockpit.gfsbern.ch/fr/cockpit/violence-sexuelles-en-suisse/>
"oc_geo_au_feminin_2019_gfs_violences_sexuelles_police"
