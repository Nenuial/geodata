#' Daily transits through maritime chokepoints
#'
#' Daily number of ships passing six maritime chokepoints, by ship type, from
#' IMF PortWatch. The counts are estimates from AIS ship positions.
#' Credit: "Sources: UN Global Platform; IMF PortWatch (portwatch.imf.org)".
#'
#' @format A tibble with 10 columns and 12660 rows (every chokepoint every
#'   day from 1 January 2021 to 11 October 2026)
#' \describe{
#'   \item{date}{Date}
#'   \item{chokepoint}{PortWatch identifier: `"chokepoint1"` Suez Canal,
#'     `"chokepoint2"` Panama Canal, `"chokepoint4"` Bab el-Mandeb Strait,
#'     `"chokepoint5"` Malacca Strait, `"chokepoint6"` Strait of Hormuz,
#'     `"chokepoint7"` Cape of Good Hope}
#'   \item{name}{Chokepoint name}
#'   \item{n_total}{All ships}
#'   \item{n_tanker,n_container,n_dry_bulk,n_general_cargo,n_roro}{Ships by
#'     type: tankers, container ships, dry bulk carriers, general cargo ships,
#'     roll-on/roll-off ships}
#'   \item{n_cargo}{Cargo ships (all types except tankers)}
#' }
#' @source IMF PortWatch <https://portwatch.imf.org/>, IMF terms of use
"df_geopolitics_chokepoints_daily"

#' Sites of the "Read a conflict" maps
#'
#' Sites shown on the maps of the Thailand–Cambodia border at Preah Vihear and
#' of the war around Iran, with their coordinates from Wikidata (property
#' P625).
#'
#' @format A tibble with 6 columns and 12 rows
#' \describe{
#'   \item{map}{`"preah_vihear"` or `"iran_war"`}
#'   \item{name}{Name shown on the map}
#'   \item{type}{`"temple"`, `"capital"`, `"nuclear site"`, `"strait"` or
#'     `"air base"`}
#'   \item{qid}{Wikidata item}
#'   \item{lon,lat}{Coordinates in degrees}
#' }
#' @source Wikidata <https://www.wikidata.org/> (CC0)
"df_geopolitics_conflict_sites"

#' Relief around Preah Vihear
#'
#' Elevation and hillshade of the Dângrêk mountains on the Thailand–Cambodia
#' border, on a grid of about 900 m (30 arc seconds), from 102.3 to 105.7° E
#' and 13.3 to 15.7° N.
#'
#' @format A tibble with 4 columns and 116116 rows
#' \describe{
#'   \item{lon,lat}{Centre of the cell in degrees}
#'   \item{elevation}{Mean elevation in m}
#'   \item{hillshade}{Hillshade from the north-west (0 dark to 1 light)}
#' }
#' @source Copernicus DEM GLO-90 (European Space Agency, Copernicus programme)
#'   <https://registry.opendata.aws/copernicus-dem/>
"df_geopolitics_preah_vihear_relief"
