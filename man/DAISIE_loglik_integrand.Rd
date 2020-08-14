% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DAISIE_loglik_integrate.R
\name{DAISIE_loglik_integrand}
\alias{DAISIE_loglik_integrand}
\title{Integrand to be integrated to calculate the log likelihood for the relaxed
rate model.}
\usage{
DAISIE_loglik_integrand(
  DAISIE_par,
  pars1,
  pars2,
  brts,
  stac,
  missnumspec,
  methode,
  abstolint,
  reltolint,
  verbose,
  pick,
  mean,
  sd
)
}
\arguments{
\item{DAISIE_par}{A numeric parameter to evaluate the integral of the
function.}

\item{pars1}{Vector of model parameters: \cr \cr \code{pars1[1]} corresponds
to lambda^c (cladogenesis rate) \cr \code{pars1[2]} corresponds to mu
(extinction rate) \cr \code{pars1[3]} corresponds to K (clade-level
carrying capacity) \cr \code{pars1[4]} corresponds to gamma
(immigration rate) \cr \code{pars1[5]} corresponds to lambda^a
(anagenesis rate).}

\item{pars2}{Vector of settings: \cr \cr \code{pars2[1]} corresponds to res,
the maximum number of endemics or non-endemics for which the ODE system is
solved; this must be much larger than the actual number for which the
probability needs to be calculated.) \cr \code{pars2[2]} corresponds to M,
size of the mainland pool, i.e the number of species that can potentially
colonize the island.}

\item{brts}{Numeric vector of branching times}

\item{stac}{Numeric of Endemicity status}

\item{missnumspec}{Numeric of missing species}

\item{methode}{Method of the ODE-solver. See package deSolve for details.
Default is "lsodes".}

\item{abstolint}{Numeric absolute tolerance of the integration}

\item{reltolint}{Numeric relative tolerance of the integration}

\item{verbose}{In simulation and dataprep functions a logical,
\code{Default = TRUE} gives intermediate output should be printed.
For ML functions a numeric determining if intermediate output should be
printed, \code{Default = 0} does not print, \code{verbose = 1} prints
intermediate output of the parameters and loglikelihood, \code{verbose = 2}
means also intermediate progress during loglikelihood computation is shown.}

\item{pick}{Numeric determining which parameter is selected for the
relaxed-rate model}

\item{mean}{Numeric mean of the distribution}

\item{sd}{Numeric standard deviation of the distribution}
}
\value{
A numeric
}
\description{
Integrand to be integrated to calculate the log likelihood for the relaxed
rate model.
}
\keyword{internal}