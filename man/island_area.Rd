% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DAISIE_rates.R
\name{island_area}
\alias{island_area}
\title{Function to describe changes in area through time.}
\usage{
island_area(timeval, total_time, area_pars, peak, island_ontogeny, sea_level)
}
\arguments{
\item{timeval}{Numeric defining current time of simulation.}

\item{total_time}{Numeric defining the length of the simulation in time
units.}

\item{area_pars}{A named list containing area and sea level parameters as
created by \code{\link{create_area_pars}()}:
\itemize{
  \item{[1]: maximum area}
  \item{[2]: current area}
  \item{[3]: value from 0 to 1 indicating where in the island's history the
  peak area is achieved}
  \item{[4]: total island age}
  \item{[5]: amplitude of area fluctuation from sea level}
  \item{[6]: frequency of sine wave of area change from sea level}
  \item{[7]: angle of the slope of the island}
}}

\item{peak}{A numeric value specifying the peakiness (or shaprness) of the
ontogeny curve. Higher values imply peakier ontogeny. This value is
internally calculated by \code{\link{calc_peak}()} given the area at the
present and the \code{area_pars}.}

\item{island_ontogeny}{In \code{\link{DAISIE_sim_time_dep}()},
\code{\link{DAISIE_ML_CS}} and plotting a string describing the type of
island ontogeny. Can be \code{"const"}, \code{"beta"} for a beta function
describing area through time. \cr In all other functions a
numeric describing the type of island ontogeny. Can be \code{0} for
constant, \code{1} for a beta function describing area through time. In ML
functions \code{island_ontogeny = NA} assumes constant ontogeny. Time
dependent estimation is not yet available as development is still ongoing.
Will return an error if called in that case.}

\item{sea_level}{In \code{\link{DAISIE_sim_time_dep}()} and plotting a
string describing the type of sea level. Can be \code{"const"} or
\code{"sine"} for a sine function describing area through time.
\cr In all other functions a numeric describing the type of sea level. Can
be \code{0} for constant, \code{1} for a sine function describing area
through time.}
}
\description{
Function to describe changes in area through time.
}
\references{
Valente, Luis M., Rampal S. Etienne, and Albert B. Phillimore.
"The effects of island ontogeny on species diversity and phylogeny."
Proceedings of the Royal Society of London B: Biological
Sciences 281.1784 (2014): 20133227.
}
\seealso{
Other rate calculations: 
\code{\link{DAISIE_plot_area}()},
\code{\link{get_ana_rate}()},
\code{\link{get_ext_rate}()},
\code{\link{get_immig_rate}()},
\code{\link{island_area_vector}()},
\code{\link{update_max_rates}()},
\code{\link{update_rates}()}
}
\author{
Pedro Neves, Joshua Lambert
}
\concept{rate calculations}
\keyword{internal}
