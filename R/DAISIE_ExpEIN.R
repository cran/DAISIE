#' The expected number of endemics and non-endemics under the DAISIE model
#'
#' This function calculates the expected number of endemics, non-endemics and
#' the sum of these for a given set of parameter values, a given mainland
#' species pool size and a given time
#'
#' @inheritParams default_params_doc
#'
#' @return \item{out}{The output is a list with three elements: \cr \cr
#' \code{ExpE} The number of endemic species \cr \code{ExpI} The number of
#' non-endemic species \cr \code{ExpN} The sum of the number of endemics and
#' non-endemics }
#' @author Rampal S. Etienne
#' @references Valente, L.M., A.B. Phillimore and R.S. Etienne (2015).
#' Equilibrium and non-equilibrium dynamics simultaneously operate in the
#' Galapagos islands. Ecology Letters 18: 844-852.
#' @keywords models
#' @examples
#'
#' ### Compute the expected values at t = 4, for a mainland pool size of 1000 potential
#' # colonists and a vector of 5 parameters (cladogenesis, extinction, clade-level carrying
#' # capacity, immigration, anagenesis)
#'
#' DAISIE_ExpEIN(
#'    t = 4,
#'    pars = c(0.5,0.1,Inf,0.01,0.4),
#'    M = 1000
#'    )
#'
#' @export DAISIE_ExpEIN
DAISIE_ExpEIN <- function(t, pars, M, initEI = c(0, 0)) {
   pars1 <- pars
   lac <- pars1[1]
   mu <- pars1[2]
   ga <- pars1[4]
   laa <- pars1[5]
   if (!is.na(pars1[11])) {
       M2 <- M - DDD::roundn(pars1[11] * M)
   } else {
       M2 <- M
   }
   A <- mu - lac
   B <- lac + mu + ga + laa
   C <- laa + 2 * lac + ga
   DD <- laa + 2 * lac
   E0 <- initEI[1]
   I0 <- initEI[2]
   if (t[1] == Inf) {
      Imm <- ga * M2 / B
      End <- DD / A * Imm
   } else {
      #Imm = M2 * ga / B * (1 - exp(-B * t))
      #End = M2 * ga * (laa + 2 * lac) * (1/(A * B) -
      #exp(-A*t) / (A * C) + exp(-B*t)/(B * C))
      Imm <- M2 * ga / B - (M2 * ga / B - I0) * exp(-B * t)
      End <- DD / C * (M2 * ga / A - M2 * ga / B +
                        (C / DD * E0 - M2 * ga / A + I0) *
                        exp(-A * t) + (M2 * ga / B - I0) * exp(-B * t))
   }
   All <- End + Imm
   expEIN <- list(End, Imm, All)
   names(expEIN) <- c("ExpE", "ExpI", "ExpN")
   return(expEIN)
}
