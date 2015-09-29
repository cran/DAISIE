\name{DAISIE-package}
\alias{DAISIE-package}
\alias{DAISIE}
\docType{package}
\title{
Dynamical Assembly of Islands by Speciation, Immigration and Extinction
}
\description{
DAISIE is an island biogeography model that assumes island biota assembly is governed by immigration, extinction and speciation through cladogenesis and anagenesis. This likelihood-based statistical package can simulate islands and estimate parameters of the DAISIE model based on phylogenetic/phylogeographic data. Cladogenesis and immigration rates can be dependent on diversity.
}
\details{
\tabular{ll}{
Package: \tab DAISIE\cr
Type: \tab Package\cr
Version: \tab 1.0.2\cr
Date: \tab 2015-09-25\cr
License: \tab GPL 2.0\cr
}

DAISIE_ML computes the parameters that maximizes the loglikelihood computes by DAISIE_loglik_all

DAISIE_sim simulates islands with given parameters

DAISIE_tutorial opens a step-by-step tutorial with example from Galapagos islands

DAISIE_loglik_all computes the loglikelihood of a given parameterization of the DAISIE model for a data set of colonization and branching times

DAISIE_plot_sims produces species-through-time plots based on simulated islands

DAISIE_dataprep converts data in table format to the list format accepted by DAISIE_loglik_all and DAISIE_ML

DAISIE_ExpEIN computes the expected number of endemics, non-endemics and their sum for a given time and set of parameters

}
\author{
Rampal S. Etienne, Luis M. Valente, Albert B. Phillimore & Bart Haegeman\cr
Maintainer: Rampal S. Etienne <r.s.etienne@rug.nl>
}
\references{
Valente, L.M., A.B. Phillimore and R.S. Etienne (2015). Equilibrium and non-equilibrium dynamics simultaneously operate in the Galapagos islands. Ecology Letters 18: 844-852.
}
\keyword{ models }
\seealso{
\code{DDD}
}

