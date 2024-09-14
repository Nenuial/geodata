#' Espérance de vie en Russie
#'
#' Un tableau de l'espérance de vie en Russie
#' par régions pour 2019.
#'
#' @format Un tibble avec 5 colonnes et 560 lignes
#' \describe{
#'   \item{region}{Nom de la région en russe}
#'   \item{lex}{Espérance de vie}
#'   \item{adm1_code}{Identifiant ADM1 (pour NaturalEarth)}
#' }
#' @source <https://rosstat.gov.ru/storage/mediabank/IeUTMwMW/prodolzhitelnost.xlsx>
"oc_russie_2019_esperance_vie"

#' Espérance de vie en Russie
#'
#' Un tableau de l'espérance de vie en Russie
#' par régions pour 2022.
#'
#' @format Un tibble avec 5 colonnes et 595 lignes
#' \describe{
#'   \item{region}{Nom de la région en russe}
#'   \item{lex}{Espérance de vie}
#'   \item{adm1_code}{Identifiant ADM1 (pour NaturalEarth)}
#' }
#' @source <https://showdata.gks.ru/report/276796>
"oc_russie_2022_esperance_vie"

#' Indice de fécondité en Russie
#'
#' Un tableau de l'indice de fécondité en Russie
#' par régions.
#'
#' @format Un tibble avec 4 colonnes et 170 lignes
#' \describe{
#'   \item{region}{Nom de la région en russe}
#'   \item{adm1_code}{Identifiant ADM1 (pour NaturalEarth)}
#'   \item{year}{Année}
#'   \item{tfr}{Indice de fécondité}
#' }
#' @source <https://rosstat.gov.ru/storage/mediabank/7-1(2).xlsx>
"oc_russie_2019_fecondite"

#' Indice de fécondité en Russie
#'
#' Un tableau de l'indice de fécondité en Russie
#' par régions.
#'
#' @format Un tibble avec 5 colonnes et 595 lignes
#' \describe{
#'   \item{codes}{OKTMO Codes}
#'   \item{region}{Nom de la région en russe}
#'   \item{adm1_code}{Identifiant ADM1 (pour NaturalEarth)}
#'   \item{year}{Année}
#'   \item{tfr}{Indice de fécondité}
#' }
#' @source <https://showdata.gks.ru/report/278974>
"oc_russie_2023_fecondite"

#' Taux d'accroissement naturel en Russie
#'
#' Un tableau du taux d'accroissement naturel en Russie
#' par régions.
#'
#' @format Un tibble avec 5 colonnes et 591 lignes
#' \describe{
#'   \item{codes}{OKTMO Codes}
#'   \item{region}{Nom de la région en russe}
#'   \item{adm1_code}{Identifiant ADM1 (pour NaturalEarth)}
#'   \item{year}{Année}
#'   \item{rni}{Taux d'accroissement naturel}
#' }
#' @source <https://showdata.gks.ru/report/297732>
"oc_russie_2023_accroissement"

#' Mortalité et natalité
#'
#' Un tableau de l'indice de la natalité et mortalité en Russie
#' par régions pour 2019.
#'
#' @format Un tibble avec 5 colonnes et 174 lignes
#' \describe{
#'   \item{region}{Nom de la région en russe}
#'   \item{type}{Type de mesure: absolute ou per1000}
#'   \item{indicator}{Indicateur: cbr, cdr ou rni}
#'   \item{data}{Donnée}
#'   \item{adm1_code}{Identifiant ADM1 (pour NaturalEarth)}
#' }
#' @source <https://rosstat.gov.ru/storage/mediabank/EDN(1).xlsx>
"oc_russie_2019_natalite_mortalite"

#' Suicides en Russie
#'
#' Un tableau des suicides en Russie
#' par régions de 1997 à 2019.
#'
#' @format Un tibble avec 5 colonnes et 1858 lignes
#' \describe{
#'   \item{codes}{OKTMO Codes}
#'   \item{adm1_code}{Identifiant ADM1 (pour NaturalEarth)}
#'   \item{region}{Nom de la région en anglais}
#'   \item{year}{Année}
#'   \item{suicides}{Nombre de suicides}
#' }
#' @source <https://showdata.gks.ru/olap2/descr/report/297886/>
"oc_russie_suicides"

#' Mariages en Russie
#'
#' Un tableau des mariages en Russie
#' par régions de 2000 à 2019.
#'
#' @format Un tibble avec 5 colonnes et 1636 lignes
#' \describe{
#'   \item{region}{Nom de la région en anglais}
#'   \item{oktmo}{OKTMO Codes}
#'   \item{year}{Année}
#'   \item{mariages}{Taux de mariage pour 1000 habitants}
#'   \item{adm1_code}{Identifiant ADM1 (pour NaturalEarth)}
#' }
#' @source <https://showdata.gks.ru/olap2/descr/report/297890/>
"oc_russie_mariages"

#' Divorces en Russie
#'
#' Un tableau des divorces en Russie
#' par régions de 2000 à 2019.
#'
#' @format Un tibble avec 5 colonnes et 84 lignes
#' \describe{
#'   \item{region}{Nom de la région en anglais}
#'   \item{oktmo}{OKTMO Codes}
#'   \item{year}{Année}
#'   \item{divorces}{Taux de divorce pour 1000 habitants}
#'   \item{adm1_code}{Identifiant ADM1 (pour NaturalEarth)}
#' }
#' @source <https://showdata.gks.ru/olap2/descr/report/297890/>
"oc_russie_divorces"

#' Mariages et divorces en Russie
#'
#' Un tableau des mariages et divorces en Russie
#' de 1990 à 2019.
#'
#' @format Un tibble avec 3 colonnes et 60 lignes
#' \describe{
#'   \item{year}{Année}
#'   \item{indicator}{L'îndicateur (mariages ou divorces)}
#'   \item{data}{La donnée numérique}
#' }
#' @source <https://showdata.gks.ru/olap2/descr/report/297882/>
#' <https://showdata.gks.ru/olap2/descr/report/297880/>
"oc_russie_mariages_divorces_national"

#' Suicides en Russie
#'
#' Un tableau des suicides en Russie
#' par régions de 1997 à 2019.
#'
#' @format Un tibble avec 2 colonnes et 30 lignes
#' \describe{
#'   \item{year}{Année}
#'   \item{suicides}{Nombre de suicides}
#' }
#' @source <https://showdata.gks.ru/olap2/descr/report/297886/>
"oc_russie_suicides_national"


#' Avortements en Russie
#'
#' Un tableau des avortements en Russie
#' de 1992 à 2017 pour 100 naissances.
#'
#' @format Un tibble avec 2 colonnes et 25 lignes
#' \describe{
#'   \item{year}{Année}
#'   \item{abortions}{Nombre d'avortements pour 100 naissances}
#' }
#' @source <https://showdata.gks.ru/olap2/descr/report/297822/>
"oc_russie_avortements_national"

#' Naissances en Russie
#'
#' Un tableau des naissances en Russie
#' de 1999 à 2019.
#'
#' @format Un tibble avec 2 colonnes et 21 lignes
#' \describe{
#'   \item{year}{Année}
#'   \item{births}{Nombre de naissances}
#' }
#' @source <https://showdata.gks.ru/olap2/descr/report/297822/>
"oc_russie_naissances_national"

#' Population municipale en Russie
#'
#' Un tableau de la population municipale en Russie
#' en 2016 et 2020.
#'
#' @format Un tibble avec 4 colonnes et 2539 lignes
#' \describe{
#'   \item{name}{Nom de la province}
#'   \item{oktmo}{Code de la municipalité}
#'   \item{2016}{Population en 2016}
#'   \item{2020}{Population en 2020}
#' }
#' @source <https://showdata.gks.ru/>
"oc_russie_2020_population_municipale"

#' Évolution de la population en Russie
#'
#' Un tableau de l'évolution de la population en Russie
#' par régions avec une comparaison entre 1990 et 2020.
#'
#' @format Un tibble avec 6 colonnes et 85 lignes
#' \describe{
#'   \item{region}{Nom de la région en anglais}
#'   \item{oktmo}{OKTMO Code}
#'   \item{adm1_code}{ADM1 ID (for NaturalEarth)}
#'   \item{`2020`}{Population en 2020}
#'   \item{`1990`}{Population en 1990}
#'   \item{solde}{Pourcentage d'évolution sur ces 30 dernières anneés}
#' }
#' @source <https://showdata.gks.ru/olap2/descr/report/278928/>
"oc_russie_2020_evolution_population"

#' Migrations en Russie
#'
#' Un tableau des migrations en Russie avec les
#' immigration et émigration de 1997 à 2019.
#'
#' @format Un tibble avec 5 colonnes et 2507 lignes
#' \describe{
#'   \item{adm1_code}{ADM1 ID (for NaturalEarth)}
#'   \item{country}{Country name}
#'   \item{year}{Year of data observation}
#'   \item{type}{One of *arrival* or *departure*}
#'   \item{migration}{Number of people migrating}
#' }
#' @source <https://rosstat.gov.ru/storage/mediabank/migr2.xls> with additional Google Translate
"oc_russie_2019_migration"

#' Attitude de la Russie vis-à-vis des USA
#'
#' Un tableau de l'évolution de l'attitude de la population
#' russe vis-à-vis des USA. Sondage Levada.
#'
#' @format Un tibble avec 3 colonnes et 516 lignes
#' \describe{
#'   \item{attitude}{Positive, Negative ou Difficile à dire}
#'   \item{date}{Date du sondage}
#'   \item{percentage}{Pourcentage de l'observation}
#' }
#' @source <https://www.levada.ru/en/ratings/attitudes-towards-countries/>
"oc_russie_levada_attitude_us"

#' Attitude de la Russie vis-à-vis de l'Europe
#'
#' Un tableau de l'évolution de l'attitude de la population
#' russe vis-à-vis de l'Union Européenne. Sondage Levada.
#'
#' @format Un tibble avec 3 colonnes et 363 lignes
#' \describe{
#'   \item{attitude}{Positive, Negative ou Difficile à dire}
#'   \item{date}{Date du sondage}
#'   \item{percentage}{Pourcentage de l'observation}
#' }
#' @source <https://www.levada.ru/en/ratings/attitudes-towards-countries/>
"oc_russie_levada_attitude_eu"

#' Dépenses militaires
#'
#' Un tableau de l'évolution des dépenses militaires pour tous
#' les pays du monde de 2000 à 2021.
#'
#' @format Un tibble avec 4 colonnes et 3411 lignes
#' \describe{
#'   \item{country}{Pays}
#'   \item{year}{Année}
#'   \item{military_expenditure}{Dépense militaire en mio $ US}
#'   \item{iso3c}{Identifiant ISO3c}
#' }
#' @source <https://milex.sipri.org/sipri>
"oc_russie_depenses_militaires"

#' ADM6 GIS
#'
#' Un tableau geographique des 2338 communes russes.
#'
#' @format Un tibble avec 27 colonnes et 2338 lignes
#' \describe{
#'   \item{osm_id}{OSM id}
#'   \item{osm_way_id}{OSM way id}
#'   \item{name}{Name}
#'   \item{type}{OSM tourism tag}
#'   \item{aeroway}{OSM aeroway tag}
#'   \item{amenity}{OSM amenity tag}
#'   \item{admin_level}{OSM admin_level}
#'   \item{boundary}{OSM boundary tag}
#'   \item{barrier}{OSM barrier tag}
#'   \item{building}{OSM building tag}
#'   \item{craft}{OSM craft tag}
#'   \item{geological}{OSM geological tag}
#'   \item{land_area}{OSM land_area tag}
#'   \item{landuse}{OSM landuse tag}
#'   \item{leisure}{OSM leisure tag}
#'   \item{man_made}{OSM man_made tag}
#'   \item{military}{OSM military tag}
#'   \item{natural}{OSM natural tag}
#'   \item{office}{OSM office tag}
#'   \item{place}{OSM place tag}
#'   \item{shop}{OSM shop tag}
#'   \item{sport}{OSM sport tag}
#'   \item{tourism}{OSM tourism tag}
#'   \item{other_tags}{OSM other tags}
#'   \item{oktmo}{OKTMO ID}
#' }
#' @source Open Street Map and WikiData
"oc_russie_adm6_gis"
