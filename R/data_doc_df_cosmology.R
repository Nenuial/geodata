#' Solar System Objects
#'
#' A table with solar system objects.
#'
#' @format A tibble with 10 columns and 10 rows
#' \describe{
#'   \item{english}{The english name of the object}
#'   \item{french}{The french name of the object}
#'   \item{type_en}{Type of object in english}
#'   \item{type_fr}{Type of object in french}
#'   \item{distance}{The distance to the Sun in AU}
#'   \item{mass}{The masse in kilogram}
#'   \item{radius}{The radius in meter}
#'   \item{density}{The density in kilgram per cubic meters}
#'   \item{rotation}{The rotation period in hours or days}
#'   \item{revolution}{The revolution period compared to Earth}
#' }
"df_cosmology_solar_system_objects"

#' Hubble 1929: distance and velocity of 24 nebulae
#'
#' Table 1 of Hubble (1929), the data of the first velocity–distance
#' relation: the distance and radial velocity of 24 extra-galactic nebulae.
#' The least-squares line through the origin gives K = 424 km/s per million
#' parsecs; Hubble used about 500.
#'
#' @format A tibble with 3 columns and 24 rows
#' \describe{
#'   \item{object}{Nebula: `"SMC"` and `"LMC"` (Hubble's "S. Mag." and
#'     "L. Mag."), then NGC numbers}
#'   \item{r_mpc}{Distance in million parsecs}
#'   \item{v_kms}{Radial velocity in km/s (negative: approaching)}
#' }
#' @source Hubble E. (1929), "A relation between distance and radial
#'   velocity among extra-galactic nebulae", Proceedings of the National
#'   Academy of Sciences 15(3): 168–173, \doi{10.1073/pnas.15.3.168}
"df_cosmology_hubble1929"
