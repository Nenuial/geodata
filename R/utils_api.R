#' Check if IDB API key is defined
#'
#' @param api_key
#'
#' @return Returns an error if the IDB API key is not properly set
#'
#' @keywords internal
util_chk_idb_api_key <- function(api_key = NULL) {
  if (Sys.getenv('IDB_API') != '') {
    api_key <- Sys.getenv('IDB_API')
  } else if (is.null(api_key)) {
    stop('A Census API key is required for this function to work. Supply one through idbr::idb_api_key.')
  }
}

#' Check API connexion
#'
#' @param call An API url
#'
#' @return Returns an error if the API call fails
#'
#' @keywords internal
util_chk_api_call <- function(call) {
  if (httr::http_error(call))
    stop("The API does not respond properly. Do you have an internet connection and an open proxy?")
}

util_dwnl_api_json <- function(call) {
  call %>%
    httr::GET() %>%
    httr::content()
}
