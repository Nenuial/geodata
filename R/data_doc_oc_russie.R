#' OC Russie: Espérance de vie
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
#' @source \url{https://rosstat.gov.ru/storage/mediabank/IeUTMwMW/prodolzhitelnost.xlsx}
"oc_russie_2019_esperance_vie"

#' OC Russie: Indice de fécondité
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
#' @source \url{https://rosstat.gov.ru/storage/mediabank/7-1(2).xlsx}
"oc_russie_2019_fecondite"

#' OC Russie: Mortalité et natalité
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
#' @source \url{https://rosstat.gov.ru/storage/mediabank/EDN(1).xlsx}
"oc_russie_2019_natalite_mortalite"

#' OC Russie: Suicides
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
#' @source \url{https://showdata.gks.ru/olap2/descr/report/297886/}
"oc_russie_suicides"

#' OC Russie: Mariages
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
#' @source \url{https://showdata.gks.ru/olap2/descr/report/297890/}
"oc_russie_mariages"

#' OC Russie: Divorces
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
#' @source \url{https://showdata.gks.ru/olap2/descr/report/297890/}
"oc_russie_divorces"

#' OC Russie: Mariages et divorces national
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
#' @source \url{https://showdata.gks.ru/olap2/descr/report/297882/}
#' \url{https://showdata.gks.ru/olap2/descr/report/297880/}
"oc_russie_mariages_divorces_national"

#' OC Russie: Suicides national
#'
#' Un tableau des suicides en Russie
#' par régions de 1997 à 2019.
#'
#' @format Un tibble avec 2 colonnes et 30 lignes
#' \describe{
#'   \item{year}{Année}
#'   \item{suicides}{Nombre de suicides}
#' }
#' @source \url{https://showdata.gks.ru/olap2/descr/report/297886/}
"oc_russie_suicides_national"


#' OC Russie: avortements national
#'
#' Un tableau des avortements en Russie
#' de 1992 à 2017 pour 100 naissances.
#'
#' @format Un tibble avec 2 colonnes et 25 lignes
#' \describe{
#'   \item{year}{Année}
#'   \item{abortions}{Nombre d'avortements pour 100 naissances}
#' }
#' @source \url{https://showdata.gks.ru/olap2/descr/report/297822/}
"oc_russie_avortements_national"

#' OC Russie: avortements national
#'
#' Un tableau des naissances en Russie
#' de 1999 à 2019.
#'
#' @format Un tibble avec 2 colonnes et 21 lignes
#' \describe{
#'   \item{year}{Année}
#'   \item{abortions}{Nombre d'avortements pour 100 naissances}
#' }
#' @source \url{https://showdata.gks.ru/olap2/descr/report/297822/}
"oc_russie_naissances_national"


#' OC Russie: Évolution de la population
#'
#' Un tableau de l'évolution de la population en Russie
#' par régions à 2019.avec un comparaison 1990 - 2020
#'
#' @format Un tibble avec 2 colonnes et 30 lignes
#' \describe{
#'   \item{region}{Nom de la région en anglais}
#'   \item{oktmo}{OKTMO Code}
#'   \item{adm1_code}{Identifian ADM1 (pour NaturalEarth)}
#'   \item{`2020`}{Population en 2020}
#'   \item{`1990`}{Population en 1990}
#'   \item{solde}{Pourcentage d'évolution sur ces 30 dernières anneés}
#' }
#' @source \url{https://showdata.gks.ru/olap2/descr/report/278928/}
"oc_russie_2020_evolution_population"

#' OC Russie: Évolution de la population
#'
#' Un tableau de l'évolution de la population en Russie
#' par régions à 2019.avec un comparaison 1990 - 2020
#'
#' @format Un tibble avec 2 colonnes et 30 lignes
#' \describe{
#'   \item{adm1_code}{Identifian ADM1 (pour NaturalEarth)}
#'   \item{country}{Country name}
#'   \item{year}{Year of data observation}
#'   \item{type}{One of `arrival` or `departure`}
#'   \item{migration}{Number of people migrating}
#' }
#' @source \url{https://rosstat.gov.ru/storage/mediabank/migr2.xls} with additional Google Translate
"oc_russie_2019_migration"
