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
