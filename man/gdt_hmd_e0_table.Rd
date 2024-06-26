% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_api_hmd.R
\name{gdt_hmd_e0_table}
\alias{gdt_hmd_e0_table}
\title{Get life expectancy table from Human Mortality Database}
\usage{
gdt_hmd_e0_table(country)
}
\arguments{
\item{country}{A string with the country name}
}
\value{
A tibble
}
\description{
Get life expectancy table from Human Mortality Database
}
\examples{
\dontshow{if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
# This example isn't run because it
# would need HMD credentials

gdt_hmd_e0_table("Switzerland")
\dontshow{\}) # examplesIf}
}
