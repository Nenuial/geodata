% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_api_swissgeo.R
\name{gdt_opendata_swiss_geodata}
\alias{gdt_opendata_swiss_geodata}
\title{Get swiss geodata}
\usage{
gdt_opendata_swiss_geodata(
  geolevel = c("national", "canton", "district", "municipality", "zh_counting_districts",
    "lakes"),
  latest = TRUE,
  verbose = FALSE
)
}
\arguments{
\item{geolevel}{One of "national", "canton", "district", "municipality", "zh_counting_districts" or "lakes"}

\item{latest}{Latest geo data (otherwise beginning of the year data)}

\item{verbose}{Boolean}
}
\value{
An sf object
}
\description{
Get swiss geodata
}
\examples{
gdt_opendata_swiss_geodata("national")

}
