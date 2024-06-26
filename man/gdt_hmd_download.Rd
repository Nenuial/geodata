% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_api_hmd.R
\name{gdt_hmd_download}
\alias{gdt_hmd_download}
\title{Download HMD data
Function to download and read HDM data into a dataframe}
\usage{
gdt_hmd_download(country, indicator)
}
\arguments{
\item{country}{Country code}

\item{indicator}{String indicating the indicator to download (usually one of \code{Population}, \code{Births} or \code{Death_1x1})}
}
\value{
A dataframe
}
\description{
Download HMD data
Function to download and read HDM data into a dataframe
}
\keyword{internal}
