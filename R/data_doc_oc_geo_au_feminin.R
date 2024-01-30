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

#' OC Géo au féminin: Suffrage féminin
#'
#' Un tableau avec l'année à laquelle les femmes ont obtenus le droit de vote
#' dans les différents pays du monde.
#'
#' @format Un tibble avec 3 colonnes et 206 lignes
#' \describe{
#'   \item{Entity}{Le pays}
#'   \item{Code}{Code ISO3c}
#'   \item{Year}{Année d'accès au suffrage féminin}
#' }
#' @source <https://ourworldindata.org/grapher/universal-suffrage-women-lexical>
"oc_geo_au_feminin_owid_suffrage_feminin"

#' OC Géo au féminin: Femmes au Conseil National
#'
#' Un tableau avec le pourcentage de femmes au Conseil National
#' en fonction de l'année
#'
#' @format Un tibble avec 2 colonnes et 13 lignes
#' \describe{
#'   \item{year}{L'année}
#'   \item{percentage}{Le pourcentage}
#' }
#' @source <https://www.bfs.admin.ch/bfs/fr/home/statistiques/politique/elections/femmes-elues.html>
"oc_geo_au_feminin_ofs_election_femmes_conseil_national"

#' OC Géo au féminin: Femmes au Conseil des Etats
#'
#' Un tableau avec le pourcentage de femmes au Conseil des Etats
#' en fonction de l'année
#'
#' @format Un tibble avec 2 colonnes et 13 lignes
#' \describe{
#'   \item{year}{L'année}
#'   \item{percentage}{Le pourcentage}
#' }
#' @source <https://www.bfs.admin.ch/bfs/fr/home/statistiques/politique/elections/femmes-elues.html>
"oc_geo_au_feminin_ofs_election_femmes_conseil_etats"

#' OC Géo au féminin: Femmes au Conseil Fédéral
#'
#' Un tableau avec le pourcentage de femmes au Conseil Fédéral
#' en fonction de l'année
#'
#' @format Un tibble avec 2 colonnes et 12 lignes
#' \describe{
#'   \item{year}{L'année}
#'   \item{percentage}{Le pourcentage}
#' }
#' @source <https://www.bfs.admin.ch/bfs/fr/home/statistiques/politique/elections/femmes-elues.html>
"oc_geo_au_feminin_ofs_election_femmes_conseil_federal"

#' OC Géo au féminin: Femmes en politique fédérale
#'
#' Un tableau avec le pourcentage de femmes dans les différentes
#' instances fédérale (Conseil National, Conseil des États et
#' Conseil Fédéral) en fonction de l'année
#'
#' @format Un tibble avec 3 colonnes et 38 lignes
#' \describe{
#'   \item{year}{L'année}
#'   \item{percentage}{Le pourcentage}
#'   \item{council}{L'instance}
#' }
#' @source <https://www.bfs.admin.ch/bfs/fr/home/statistiques/politique/elections/femmes-elues.html>
"oc_geo_au_feminin_ofs_election_femmes"

#' OC Géo au féminin: Pourcentage de jeunes entre 16 et 24 ans qui savent programmer
#'
#' Un tableau avec le pourcentage de jeunes (16 à 24 ans)  qui savent
#' programmer pour les différents pays de l'OECD.
#'
#' @format Un tibble avec 5 colonnes et 818 lignes
#' \describe{
#'   \item{ISO}{Code pays ISO3c}
#'   \item{Country}{Le pays}
#'   \item{Scope}{Hommes, femmes, ou tous}
#'   \item{Time}{L'année}
#'   \item{Value}{La valeur en pourcent}
#' }
#' @source <https://goingdigital.oecd.org/indicator/54>
"oc_geo_au_feminin_oecd_programmation_16_24_ans"

#' OC Géo au féminin: Indicateur SIGI
#'
#' Un tableau avec l'indicateur SIGI (Social Institutions and Gender Index)
#' pour l'année 2023
#'
#' @format Un tibble avec 8 colonnes et 1635 lignes
#' \describe{
#'   \item{REGION}{Code région}
#'   \item{Region}{Intitulé région}
#'   \item{LOCATION}{Code pays ISO3c}
#'   \item{Country}{Pays}
#'   \item{VAR}{Code variable}
#'   \item{Variables}{Intitulé variable}
#'   \item{Time}{Année}
#'   \item{Value}{Valeur}
#' }
#' @source <https://stats.oecd.org/Index.aspx?DataSetCode=SIGI2023>
"oc_geo_au_feminin_2023_oecd_sigi"

#' OC Géo au féminin: Indicateur GII
#'
#' Un tableau avec l'indicateur GII (Gender Inequality Index)
#' pour l'année 2021
#'
#' @format Un tibble avec 3 colonnes et 170 lignes
#' \describe{
#'   \item{country}{Pays}
#'   \item{gii}{Indicateur GII}
#'   \item{iso}{Code pays ISO3c}
#' }
#' @source <https://hdr.undp.org/data-center/thematic-composite-indices/gender-inequality-index#/indicies/GII>
"oc_geo_au_feminin_2021_unhdr_gii"

#' OC Géo au féminin: Sex-ratio à la naissance
#'
#' Un tableau avec le sex ratio à la naissance tiré des données
#' WPP 2022
#'
#' @format Un tibble avec 6 colonnes et 43472 lignes
#' \describe{
#'   \item{UN_Code}{Code UN}
#'   \item{Region}{Type de région UN}
#'   \item{Location}{Nom du pays/région}
#'   \item{Year}{L'année}
#'   \item{SRB}{Sex-ration à la naissance}
#'   \item{iso}{Code pays ISO3c}
#' }
#' @source <https://population.un.org/wpp/>
"oc_geo_au_feminin_sex_ratio"

#' OC Géo au féminin: Avortement par canton
#'
#' Un tableau avec les avortements par canton en Suisse
#' en 2022
#'
#' @format Un tibble avec 5 colonnes et 494 lignes
#' \describe{
#'   \item{age_group}{Tranche d'âge}
#'   \item{unit}{Unité (n ou %)}
#'   \item{region}{Région du pays}
#'   \item{canton}{Le canton}
#'   \item{abortion}{Mesure de l'avortement}
#' }
#' @source <https://www.bfs.admin.ch/bfs/fr/home/statistiques/catalogues-banques-donnees/tableaux.assetdetail.26386394.html>
"oc_geo_au_feminin_2022_ofs_avortements_par_canton"

#' OC Géo au féminin: Avortements par canton
#'
#' Un tableau avec les avortements par tranche d'âge
#' en Suisse en 2022
#'
#' @format Un tibble avec 3 colonnes et 18 lignes
#' \describe{
#'   \item{age_group}{Tranche d'âge}
#'   \item{unit}{Unité (n ou %)}
#'   \item{abortion}{Mesure de l'avortement}
#' }
"oc_geo_au_feminin_2022_ofs_avortements_par_ages"


#' OC Géo au féminin: Avortements par région
#'
#' Un tableau avec les avortements par régions
#' en Suisse entre 2007 et 2022
#'
#' @format Un tibble avec 3 colonnes et 18 lignes
#' \describe{
#'   \item{annee}{Année}
#'   \item{region}{Région}
#'   \item{avortement}{Taux d'avortement}
#' }
"oc_geo_au_feminin_ofs_avortements_par_region"

#' OC Géo au féminin: Votations sur l'avortement
#'
#' Un tableau avec les résultats au niveau fédéral
#' de différentes votations en rapport avec
#' l'avortement
#'
#' @format Un tibble avec 3 colonnes et 6 lignes
#' \describe{
#'   \item{Votation}{Le titre de la votation}
#'   \item{Oui}{Pourcentage de voix pour le oui}
#'   \item{Non}{Pourcentage de voix pour le non}
#' }
"oc_geo_au_feminin_votations_avortement"
