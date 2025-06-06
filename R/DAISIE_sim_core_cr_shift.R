#' Internal function of the DAISIE simulation
#'
#' @inheritParams default_params_doc
#' @keywords internal
DAISIE_sim_core_cr_shift <- function(
  time,
  mainland_n,
  pars,
  nonoceanic_pars = c(0, 0),
  hyper_pars = NULL,
  area_pars = NULL,
  shift_times
) {

  #### Initialization ####
  timeval <- 0
  total_time <- time
  testit::assert(length(pars) == 10 && !is.null(shift_times))
  shift_times <- total_time - shift_times
  shift_times <- sort(shift_times)
  shift_times <- c(shift_times, Inf)
  testit::assert(any(duplicated(shift_times)) == FALSE)
  dynamic_shift_times <- shift_times

  if (pars[4] == 0 && nonoceanic_pars[1] == 0) {
    stop("Island has no species and the rate of
    colonisation is zero. Island cannot be colonised.")
  }

  nonoceanic_sample <- DAISIE_nonoceanic_spec(
    prob_samp = nonoceanic_pars[1],
    prob_nonend = nonoceanic_pars[2],
    mainland_n = mainland_n)
  maxspecID <- mainland_n
  island_spec <- c()
  stt_table <- matrix(ncol = 4)
  colnames(stt_table) <- c("Time", "nI", "nA", "nC")
  spec_tables <- DAISIE_spec_tables(stt_table,
                                    total_time,
                                    timeval,
                                    nonoceanic_sample,
                                    island_spec,
                                    maxspecID)
  maxspecID <- spec_tables$maxspecID
  stt_table <- spec_tables$stt_table
  mainland_spec <- spec_tables$mainland_spec
  island_spec <- spec_tables$island_spec

  if (shift_times[1] != 0) {
    lac <- pars[1]
    mu <- pars[2]
    K <- pars[3]
    gam <- pars[4]
    laa <- pars[5]
    rate_set <- 1
  } else {
    # Land bridge
    lac <- pars[6]
    mu <- pars[7]
    K <- pars[8]
    gam <- pars[9]
    laa <- pars[10]
    rate_set <- 2
  }
  num_spec <- length(island_spec[, 1])
  num_immigrants <- length(which(island_spec[, 4] == "I"))


  #### Start Monte Carlo iterations ####
  while (timeval < total_time) {
    rates <- update_rates(
      timeval = timeval,
      total_time = total_time,
      gam = gam,
      laa = laa,
      lac = lac,
      mu = mu,
      hyper_pars = hyper_pars,
      area_pars = area_pars,
      K = K,
      num_spec = num_spec,
      num_immigrants = num_immigrants,
      mainland_n = mainland_n,
      island_ontogeny = 0,
      sea_level = 0,
      extcutoff = NULL
    )
    testit::assert(are_rates(rates))

    timeval_shift <- calc_next_timeval_shift(
      max_rates = rates,
      timeval = timeval,
      dynamic_shift_times = dynamic_shift_times,
      total_time = total_time
    )

    timeval <- timeval_shift$timeval
    dynamic_shift_times <- timeval_shift$dynamic_shift_times
    rate_shift <- timeval_shift$rate_shift

    if (rate_shift) {
      # First set of rates for island
      if (rate_set == 2) {
        lac <- pars[1]
        mu <- pars[2]
        K <- pars[3]
        gam <- pars[4]
        laa <- pars[5]
        rate_set <- 1
      } else { # Second set of rates for land bridge
        lac <- pars[6]
        mu <- pars[7]
        K <- pars[8]
        gam <- pars[9]
        laa <- pars[10]
        rate_set <- 2
      }

      rates <- update_rates(
        timeval = timeval,
        total_time = total_time,
        gam = gam,
        laa = laa,
        lac = lac,
        mu = mu,
        hyper_pars = hyper_pars,
        area_pars = area_pars,
        K = K,
        num_spec = num_spec,
        num_immigrants = num_immigrants,
        mainland_n = mainland_n,
        island_ontogeny = 0,
        sea_level = 0,
        extcutoff = NULL
      )
    }

    possible_event <- DAISIE_sample_event_cr(
      rates = rates
    )

    if (timeval <= total_time && rate_shift == FALSE) {

      # Update system
      updated_state <- DAISIE_sim_update_state_cr(
        timeval = timeval,
        total_time = total_time,
        possible_event = possible_event,
        maxspecID = maxspecID,
        mainland_spec = mainland_spec,
        island_spec = island_spec,
        stt_table = stt_table
      )

      island_spec <- updated_state$island_spec
      maxspecID <- updated_state$maxspecID
      stt_table <- updated_state$stt_table
      num_spec <- length(island_spec[, 1])
      num_immigrants <- length(which(island_spec[, 4] == "I"))
    }
  }
  #### Finalize STT ####
  stt_table <- rbind(
    stt_table,
    c(
      0,
      stt_table[nrow(stt_table), 2],
      stt_table[nrow(stt_table), 3],
      stt_table[nrow(stt_table), 4]
    )
  )
  island <- DAISIE_create_island(
    stt_table = stt_table,
    total_time = total_time,
    island_spec = island_spec,
    mainland_n = mainland_n)
  ordered_stt_times <- sort(island$stt_table[, 1], decreasing = TRUE)
  testit::assert(all(ordered_stt_times == island$stt_table[, 1]))
  return(island)
}
