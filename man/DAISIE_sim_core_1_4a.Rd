% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DAISIE_sim_core_1_4a.R
\name{DAISIE_sim_core_1_4a}
\alias{DAISIE_sim_core_1_4a}
\title{Internal function of the DAISIE simulation
Taken from CRAN, commit https://github.com/richelbilderbeek/DAISIE/commit/c700b0fcf9e2c2b5d7248f02af7596fac5a2f573#diff-ddae7ad3ae2def3cb66ecf8a8a45cc41}
\usage{
DAISIE_sim_core_1_4a(time, mainland_n, pars)
}
\arguments{
\item{time}{simulated amount of time}

\item{mainland_n}{number of mainland species, that
is, the number of species that can potentially colonize the island.
If \code{\link{DAISIE_sim_constant_rate}()} uses a clade-specific diversity dependence,
this value is set to 1.
If \code{\link{DAISIE_sim_constant_rate}()} uses an island-specific diversity dependence,
this value is set to the number of mainland species.}

\item{pars}{a numeric vector:
\itemize{
  \item{[1]: cladogenesis rate}
  \item{[2]: extinction rate}
  \item{[3]: carrying capacity}
  \item{[4]: immigration rate}
  \item{[5]: anagenesis rate}
}}
}
\description{
Internal function of the DAISIE simulation
Taken from CRAN, commit https://github.com/richelbilderbeek/DAISIE/commit/c700b0fcf9e2c2b5d7248f02af7596fac5a2f573#diff-ddae7ad3ae2def3cb66ecf8a8a45cc41
}
\note{
This function produces an extra element per replicate when the
island is empty at time = 0. Functionally this has no effect on the
simulations, but care should be taken if using the length of objects to count
the number of species present on the island.
}
\keyword{internal}
