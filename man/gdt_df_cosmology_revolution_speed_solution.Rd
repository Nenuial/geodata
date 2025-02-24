% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_df_cosmology.R
\name{gdt_df_cosmology_revolution_speed_solution}
\alias{gdt_df_cosmology_revolution_speed_solution}
\title{Table for the solution of the revolution speed of
a planet around the Sun}
\usage{
gdt_df_cosmology_revolution_speed_solution(name, au, time)
}
\arguments{
\item{name}{The name of the planet}

\item{au}{The distance of the planet to the Sun in AU}

\item{time}{The time for one revolution in Earth years}
}
\value{
A gt table
}
\description{
Table for the solution of the revolution speed of
a planet around the Sun
}
\examples{
gdt_df_cosmology_revolution_speed_solution("Earth", 1, 1)
}
