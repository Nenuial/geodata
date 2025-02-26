% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_api_hmd.R
\name{gdt_hmd_mortality}
\alias{gdt_hmd_mortality}
\title{Get mortality table from Human Mortality Database}
\usage{
gdt_hmd_mortality(country)
}
\arguments{
\item{country}{A string with the country name}
}
\value{
A demogdata object
}
\description{
Fetches the mortality table from the HMD database. This function
needs valid credentials for HMD stored using the
{\href{https://keyring.r-lib.org}{keyring}} package under a service
labelled \emph{mortality.org}.
}
\examples{
\dontshow{if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
# This example isn't run because it
# would need HMD credentials

gdt_hmd_mortality("France")
\dontshow{\}) # examplesIf}
}
