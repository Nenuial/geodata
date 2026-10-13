#' Plate detective regions
#'
#' The five regions of the plate detective exercise with their bounding boxes.
#'
#' @format A tibble with 6 columns and 5 rows
#' \describe{
#'   \item{region}{Region code (A to E)}
#'   \item{name}{Region name}
#'   \item{lon_min,lon_max}{Longitude limits in degrees (west negative)}
#'   \item{lat_min,lat_max}{Latitude limits in degrees (south negative)}
#' }
"df_geology_regions"

#' Earthquakes of the plate detective regions
#'
#' Earthquakes of magnitude 5 or more from 1975 to 2025 in the regions of
#' [df_geology_regions], from the USGS earthquake catalogue.
#'
#' @format A tibble with 8 columns and 12897 rows
#' \describe{
#'   \item{region}{Region code (A to E)}
#'   \item{lon,lat}{Epicentre coordinates in degrees}
#'   \item{depth}{Hypocentre depth in km}
#'   \item{mag}{Magnitude}
#'   \item{time}{Origin time (UTC)}
#'   \item{year}{Year}
#'   \item{place}{Description of the location, as given by the USGS}
#' }
#' @source U.S. Geological Survey, Earthquake Hazards Program, ComCat
#'   (public domain) <https://earthquake.usgs.gov/fdsnws/event/1/>
"df_geology_earthquakes"

#' Volcanoes of the plate detective regions
#'
#' Holocene volcanoes in the regions of [df_geology_regions].
#'
#' @format A tibble with 6 columns and 209 rows
#' \describe{
#'   \item{region}{Region code (A to E)}
#'   \item{name}{Volcano name}
#'   \item{lon,lat}{Coordinates in degrees}
#'   \item{type}{Primary volcano type}
#'   \item{last_eruption}{Year of the last known eruption (negative: BCE)}
#' }
#' @source Global Volcanism Program, Volcanoes of the World, Smithsonian
#'   Institution <https://volcano.si.edu/>
"df_geology_volcanoes"
