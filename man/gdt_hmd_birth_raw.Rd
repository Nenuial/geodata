% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_api_hmd.R
\name{gdt_hmd_birth_raw}
\alias{gdt_hmd_birth_raw}
\title{HMD raw births data}
\usage{
gdt_hmd_birth_raw(country)
}
\arguments{
\item{country}{Country code}
}
\value{
A dataframe
}
\description{
HMD raw births data
}
\examples{
\dontshow{if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
# This example isn't run because it
# would need HMD credentials
gdt_hmd_birth_raw("CHE") |>
  head(5)
\dontshow{\}) # examplesIf}
}
