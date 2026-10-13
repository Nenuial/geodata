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

#' Swiss basemap for the epicentre exercise
#'
#' Countries, Swiss cantons and lakes around Switzerland from Natural Earth
#' (1:10m, with the detailed European lakes), in the Swiss projection LV95
#' (EPSG:2056) so that distances measured on the map are true.
#'
#' @format An sf object with 3 columns and 55 rows
#' \describe{
#'   \item{layer}{`"country"`, `"canton"` or `"lake"`}
#'   \item{name}{Name (missing for some lakes)}
#'   \item{geometry}{Polygons in LV95 (EPSG:2056)}
#' }
#' @source Natural Earth <https://www.naturalearthdata.com/>
"df_geology_swiss_basemap"

#' Seismic stations of the epicentre exercise
#'
#' The three stations of the "find the earthquake" exercise with their
#' distance to the epicentre of the Visp earthquake of 1855 and the arrival
#' times of the P waves (6 km/s) and S waves used for the synthetic
#' seismograms.
#'
#' @format A tibble with 7 columns and 3 rows
#' \describe{
#'   \item{station}{Station name}
#'   \item{lat,lon}{Coordinates in degrees}
#'   \item{distance}{Distance to the epicentre in km}
#'   \item{s_minus_p}{Delay between the S and the P wave in seconds}
#'   \item{p_arrival,s_arrival}{Arrival times after the earthquake in seconds}
#' }
"df_geology_seismic_stations"

#' Epicentre of the epicentre exercise
#'
#' Epicentre of the Visp earthquake of 1855, answer of the "find the
#' earthquake" exercise.
#'
#' @format A tibble with 4 columns and 1 row
#' \describe{
#'   \item{name}{Place}
#'   \item{year}{Year}
#'   \item{lat,lon}{Coordinates in degrees}
#' }
"df_geology_epicentre"

#' Synthetic seismograms
#'
#' Synthetic seismograms of the same earthquake at the three stations of
#' [df_geology_seismic_stations], 100 samples per second from the origin time:
#' noise, a small P wave, then an S wave about three times larger. Generated
#' with a fixed seed, for teaching only.
#'
#' @format A tibble with 3 columns and 12003 rows
#' \describe{
#'   \item{station}{Station name}
#'   \item{time}{Time after the earthquake in seconds}
#'   \item{amplitude}{Ground motion (arbitrary units)}
#' }
"df_geology_seismograms"

#' GDP per capita of Haiti 2010 and Japan 2016
#'
#' GDP per capita in current US dollars for the years of the Haiti (2010)
#' and Kumamoto (2016) earthquakes, from the World Bank.
#'
#' @format A tibble with 6 columns and 2 rows
#' \describe{
#'   \item{country,iso3c}{Country name and ISO3 code}
#'   \item{year}{Year}
#'   \item{gdp_per_capita}{GDP per capita (current US$)}
#'   \item{indicator}{World Bank indicator code}
#'   \item{retrieved}{Date of the download}
#' }
#' @source World Bank, World Development Indicators, NY.GDP.PCAP.CD
#'   <https://data.worldbank.org/indicator/NY.GDP.PCAP.CD>
"df_geology_gdp_per_capita"

#' Municipalities around Vesuvius
#'
#' The municipalities within 40 km of the crater of Vesuvius with their
#' population and whether they belong to the red zone of the national
#' emergency plan (the area to evacuate before an eruption, threatened by
#' pyroclastic flows).
#'
#' @format An sf object with 6 columns and 258 rows
#' \describe{
#'   \item{code}{ISTAT municipality code}
#'   \item{name}{Municipality}
#'   \item{province}{Province}
#'   \item{population}{Population on 1 January 2026 (ISTAT estimate)}
#'   \item{red_zone}{`"entirely"`, `"partly"` (Napoli, Nola and Pomigliano
#'     d'Arco) or `"no"`}
#'   \item{geometry}{Polygons in UTM 33N (EPSG:32633)}
#' }
#' @source ISTAT, generalised administrative boundaries and resident
#'   population on 1 January 2026 <https://www.istat.it/>; red zone:
#'   Direttiva del Presidente del Consiglio dei Ministri of 14 February 2014
#'   (Gazzetta Ufficiale of 12 May 2014)
"df_geology_vesuvius_municipalities"

#' Crater of Vesuvius and ancient sites
#'
#' Approximate coordinates of the crater of Vesuvius and of the ancient
#' sites of Pompeii and Herculaneum.
#'
#' @format A tibble with 4 columns and 3 rows
#' \describe{
#'   \item{name}{Name}
#'   \item{type}{`"crater"` or `"ancient site"`}
#'   \item{lat,lon}{Coordinates in degrees}
#' }
"df_geology_vesuvius_sites"
