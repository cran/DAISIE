#' Samples what event to happen next
#'
#' @inheritParams default_params_doc
#'
#' @return numeric indicating what event will happen, or a supposed event that
#' would happen in some timesteps of the ontogeny algorithm.
#' \itemize{
#'   \item{[1]: immigration event}
#'   \item{[2]: extinction event}
#'   \item{[3]: cladogenesis event}
#'   \item{[4]: anagenesis event}
#' }
#' @keywords internal
#' @author Pedro Neves
DAISIE_sample_event_cr <- function(rates) {
  testit::assert(are_rates(rates))
  possible_event <- sample(
    x = 1:4,
    size = 1,
    replace = FALSE,
    prob = c(rates$immig_rate,
             rates$ext_rate,
             rates$ana_rate,
             rates$clado_rate)
  )

  testit::assert(is.numeric(possible_event))
  testit::assert(possible_event >= 1)
  return(possible_event)
}
