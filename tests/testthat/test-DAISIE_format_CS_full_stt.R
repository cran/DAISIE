test_that("complete stt, 1 type, no geodynamics, oceanic island, one trait state
          (same arguments as geodynamics, 5 pars)", {
  pars <- c(0.4, 0.2, 10, 2, 0.5)
  total_time <- 1
  mainland_n <- 2
  area_pars <- create_area_pars(
    max_area = 1,
    current_area = 1,
    proportional_peak_t = 0,
    total_island_age = 0,
    sea_level_amplitude = 0,
    sea_level_frequency = 0,
    island_gradient_angle = 0)
  hyper_pars <- create_hyper_pars(d = 0, x = 0)
  nonoceanic_pars <- c(0, 0)
  verbose <- FALSE
  set.seed(1)
  replicates <- 3
  island_replicates <- list()
  for (rep in 1:replicates) {
    island_replicates[[rep]] <- list()
    full_list <- list()
    out <- list()
    for (m_spec in 1:mainland_n) {
      out$branching_times <- c(10)
      while (length(out$branching_times) == 1) {
        out <- DAISIE_sim_core_cr(
          time = total_time,
          mainland_n = 1,
          pars = pars,
          area_pars = area_pars,
          hyper_pars = hyper_pars,
          nonoceanic_pars = nonoceanic_pars
        )
      }
      full_list[[m_spec]] <- out
    }
    island_replicates[[rep]] <- full_list
  }


  expect_silent(
    formatted_CS_sim <- DAISIE_format_CS_full_stt(
      island_replicates = island_replicates,
      time = total_time,
      M = mainland_n,
      verbose = verbose
    )
  )

  expect_equal(
    formatted_CS_sim[[1]][[1]]$island_age,
    1
  )
  expect_equal(
    formatted_CS_sim[[1]][[1]]$not_present,
    0
  )
  expect_equal(
    formatted_CS_sim[[1]][[1]]$stt_all[2, ],
    c(Time = 0.8129771533422172, nI = 1.0, nA = 0.0, nC = 0.0, present = 1.0)
  )
  expect_equal(
    formatted_CS_sim[[1]][[1]]$stt_all[4, ],
    c(Time = 0.5735296212440449, nI = 1.0, nA = 0.0, nC = 0.0, present = 1.0)
  )

  expect_equal(
    formatted_CS_sim[[1]][[2]]$branching_times,
    c(1.000000000000000, 0.444415577345164)
  )

  expect_equal(
    formatted_CS_sim[[1]][[2]]$stac,
    4
  )

  expect_equal(
    formatted_CS_sim[[1]][[2]]$missing_species,
    0
  )

  expect_equal(
    formatted_CS_sim[[1]][[3]]$branching_times,
    c(1.000000000000000, 0.326839228620516)
  )

  expect_equal(
    formatted_CS_sim[[1]][[3]]$stac,
    4
  )

  expect_equal(
    formatted_CS_sim[[1]][[3]]$missing_species,
    0
  )
})


test_that("complete stt, 1 type, geodynamics, oceanic island, one trait state
          (same arguments as no geodynamics, 5 pars)", {
  total_time <- 5
  mainland_n <- 2
  verbose <- FALSE
  set.seed(1)
  island_replicates <- list()
  replicates <- 3
  island_ontogeny <- 1
  sea_level <- 0
  pars <- c(0.0001, 2.2, 0.005, 1, 1)
  area_pars <- create_area_pars(
    max_area = 5000,
    current_area = 2500,
    proportional_peak_t = 0.5,
    total_island_age = 15,
    sea_level_amplitude = 0,
    sea_level_frequency = 0,
    island_gradient_angle = 0
  )
  hyper_pars <- create_hyper_pars(d = 0.2, x = 0.1)
  nonoceanic_pars <- c(0, 0)
  peak <- calc_peak(total_time = total_time,
                             area_pars = area_pars)
  Amax <- get_global_max_area(total_time = total_time,
                                       area_pars = area_pars,
                                       peak = peak,
                                       island_ontogeny = island_ontogeny,
                                       sea_level = sea_level)
  Amin <- get_global_min_area(total_time = total_time,
                                       area_pars = area_pars,
                                       peak = peak,
                                       island_ontogeny = island_ontogeny,
                                       sea_level = sea_level)
  for (rep in 1:replicates) {
    island_replicates[[rep]] <- list()
    full_list <- list()
    out <- list()
    for (m_spec in 1:mainland_n) {
      out$branching_times <- c(10)
      while (length(out$branching_times) == 1) {
        out <- DAISIE_sim_core_time_dep(
          island_ontogeny = 1,
          time = total_time,
          mainland_n = 1,
          pars = pars,
          sea_level = sea_level,
          area_pars = area_pars,
          peak = peak,
          Amax = Amax,
          Amin = Amin,
          hyper_pars = hyper_pars,
          nonoceanic_pars = nonoceanic_pars,
          extcutoff = 100
        )
      }
      full_list[[m_spec]] <- out
    }
    island_replicates[[rep]] <- full_list
  }

  expect_silent(
    formatted_CS_sim <- DAISIE_format_CS_full_stt(
      island_replicates = island_replicates,
      time = total_time,
      M = mainland_n,
      verbose = verbose
    )
  )

  expect_equal(
    formatted_CS_sim[[1]][[1]]$island_age,
    5
  )
  expect_equal(
    formatted_CS_sim[[1]][[1]]$not_present,
    0
  )
  expect_equal(
    formatted_CS_sim[[1]][[1]]$stt_all[2, ],
    c(Time = 4.4979918331304169, nI = 1.0, nA = 0.0, nC = 0.0, present = 1.0)
  )
  expect_equal(
    formatted_CS_sim[[1]][[1]]$stt_all[5, ],
    c(Time = 3.5464713894645161, nI = 0.0, nA = 0.0, nC = 0.0, present = 0.0)
  )
  expect_equal(
    formatted_CS_sim[[1]][[2]]$branching_times,
    c(5.00000000000000, 0.16307316373162001)
  )
  expect_equal(
    formatted_CS_sim[[1]][[2]]$stac,
    4
  )
  expect_equal(
    formatted_CS_sim[[1]][[2]]$missing_species,
    0
  )

  # Correct number of rows on initial and final matrices
  expect_equal(
    nrow(formatted_CS_sim[[1]][[1]]$stt_all),
    (nrow(island_replicates[[1]][[1]]$stt_table) +
       nrow(island_replicates[[1]][[2]]$stt_table)) - 2
  )
  expect_equal(
    nrow(formatted_CS_sim[[2]][[1]]$stt_all),
    (nrow(island_replicates[[2]][[1]]$stt_table) +
       nrow(island_replicates[[2]][[2]]$stt_table)) - 2
  )
})

test_that("complete stt, 2 type, no geodynamics, oceanic island, one trait state
          (same arguments as geodynamics, 10 pars)", {
  pars <- c(0.4, 0.1, 10, 1, 0.5, 0.4, 0.1, 10, 1, 0.5)
  total_time <- 5
  M <- 10
  mainland_n <- M
  verbose <- FALSE
  replicates <- 2
  area_pars <- create_area_pars(
    max_area = 1,
    current_area = 1,
    proportional_peak_t = 0,
    total_island_age = 0,
    sea_level_amplitude = 0,
    sea_level_frequency = 0,
    island_gradient_angle = 0)
  hyper_pars <- create_hyper_pars(d = 0, x = 0)
  set.seed(1)
  island_replicates <- list()
  prop_type2_pool <- 0.4

  island_replicates <- DAISIE_sim_min_type2(
    time = total_time,
    M = M,
    pars = pars,
    replicates = replicates,
    prop_type2_pool = prop_type2_pool,
    area_pars = area_pars,
    hyper_pars = hyper_pars,
    verbose = FALSE
  )
  expect_silent(
    formatted_CS_sim <- DAISIE_format_CS_full_stt(
      island_replicates = island_replicates,
      time = total_time,
      M = mainland_n,
      verbose = verbose
    )
  )

  expect_equal(
    formatted_CS_sim[[1]][[1]]$island_age,
    5
  )
  expect_equal(
    formatted_CS_sim[[1]][[1]]$not_present_type1,
    0
  )
  expect_equal(
    formatted_CS_sim[[1]][[1]]$not_present_type2,
    0
  )
  expect_equal(
    formatted_CS_sim[[1]][[1]]$stt_all[2, ],
    c(Time = 4.979749586898834, nI = 1.0, nA = 0.0, nC = 0.0, present = 1.0)
  )
  expect_equal(
    formatted_CS_sim[[1]][[1]]$stt_all[5, ],
    c(Time = 4.590700004177261, nI = 1.0, nA = 0.0, nC = 2.0, present = 2.0)
  )
  expect_equal(
    formatted_CS_sim[[1]][[1]]$stt_all[19, ],
    c(Time = 3.867811945494177, nI = 6.0, nA = 3.0, nC = 4.0, present = 8.0)
  )
  expect_equal(
    formatted_CS_sim[[1]][[1]]$stt_type1[5, ],
    c(Time = 4.460097487432346, nI = 2.0, nA = 0.0, nC = 2.0, present = 3.0)
  )
  expect_equal(
    formatted_CS_sim[[1]][[1]]$stt_type1[15, ],
    c(Time = 3.771978362895029, nI = 4.0, nA = 1.0, nC = 6.0, present = 5.0)
  )
  expect_equal(
    formatted_CS_sim[[1]][[1]]$stt_type2[5, ],
    c(Time = 4.317296566441655, nI = 2.0, nA = 0.0, nC = 0.0, present = 2.0)
  )
  expect_equal(
    formatted_CS_sim[[1]][[1]]$stt_type2[15, ],
    c(Time = 3.164011375762181, nI = 3.0, nA = 2.0, nC = 0.0, present = 4.0)
  )

  expect_equal(
    formatted_CS_sim[[1]][[2]]$branching_times,
    c(5, 4.24481816687165, 4.01220327283541, 1.44735043895909, 1.35145127332475)
  )

  expect_equal(
    formatted_CS_sim[[1]][[2]]$stac,
    3
  )

  expect_equal(
    formatted_CS_sim[[1]][[2]]$missing_species,
    0
  )

  # Correct number of rows on initial and final matrices. Make sure length
  # of full stt is the sum of individual colonist stt table,
  # minus the first and last lines of each stt table. The first and last lines
  # are always the same in all stt tables.
  stt_nrows <- sapply(island_replicates[[1]], FUN = function(x) nrow(x$stt_table))
  sum_stt_nrows <- sum(stt_nrows)
  expect_equal(
    nrow(formatted_CS_sim[[1]][[1]]$stt_all),
    sum_stt_nrows - 18
  )
  stt_nrows <- sapply(island_replicates[[2]], FUN = function(x) nrow(x$stt_table))
  sum_stt_nrows <- sum(stt_nrows)
  expect_equal(
    nrow(formatted_CS_sim[[2]][[1]]$stt_all),
    sum_stt_nrows - 18
  )

  # Type 1
  type_1s <- island_replicates[[1]][1:6]
  stt_nrows <- sapply(type_1s, FUN = function(x) nrow(x$stt_table))
  sum_stt_nrows <- sum(stt_nrows)
  expect_equal(
    nrow(formatted_CS_sim[[1]][[1]]$stt_type1),
    sum_stt_nrows - 10
  )
  type_1s <- island_replicates[[2]][1:6]
  stt_nrows <- sapply(type_1s, FUN = function(x) nrow(x$stt_table))
  sum_stt_nrows <- sum(stt_nrows)
  expect_equal(
    nrow(formatted_CS_sim[[2]][[1]]$stt_type1),
    sum_stt_nrows - 10
  )

  # Type 2
  type_2s <- island_replicates[[1]][7:10]
  stt_nrows <- sapply(type_2s, FUN = function(x) nrow(x$stt_table))
  sum_stt_nrows <- sum(stt_nrows)
  expect_equal(
    nrow(formatted_CS_sim[[1]][[1]]$stt_type2),
    sum_stt_nrows - 6
  )
  type_2s <- island_replicates[[2]][7:10]
  stt_nrows <- sapply(type_2s, FUN = function(x) nrow(x$stt_table))
  sum_stt_nrows <- sum(stt_nrows)
  expect_equal(
    nrow(formatted_CS_sim[[2]][[1]]$stt_type2),
    sum_stt_nrows - 6
  )
})

test_that("complete stt, 1 type, no geodynamics, nonoceanic, one trait state
          (same arguments as geodynamics, 5 pars)", {
  total_time <- 3
  mainland_n <- 2
  clado_rate <- 1 # cladogenesis rate
  ext_rate <- 0.3 # extinction rate
  clade_carr_cap <- 10.0  # clade-level carrying capacity
  imm_rate <- 0.00933207 # immigration rate
  ana_rate <- 1.010073119 # anagenesis rate
  pars <- c(clado_rate, ext_rate, clade_carr_cap, imm_rate, ana_rate)
  replicates <- 3
  area_pars <- create_area_pars(
    max_area = 1,
    current_area = 1,
    proportional_peak_t = 0,
    total_island_age = 0,
    sea_level_amplitude = 0,
    sea_level_frequency = 0,
    island_gradient_angle = 0)
  hyper_pars <- create_hyper_pars(d = 0, x = 0)
  nonoceanic_pars <- c(0.1, 0.9)
  island_replicates <- list()
  verbose <- FALSE

  for (rep in 1:replicates) {
    island_replicates[[rep]] <- list()
    full_list <- list()
    out <- list()
    for (m_spec in 1:mainland_n) {
      out$branching_times <- c(10)
      while (length(out$branching_times) == 1) {
        out <- DAISIE_sim_core_cr(
          time = total_time,
          mainland_n = 1,
          pars = pars,
          area_pars = area_pars,
          hyper_pars = hyper_pars,
          nonoceanic_pars = nonoceanic_pars
        )
      }
      full_list[[m_spec]] <- out
    }
    island_replicates[[rep]] <- full_list
  }
  expect_silent(
    formatted_CS_sim <- DAISIE_format_CS_full_stt(
      island_replicates = island_replicates,
      time = total_time,
      M = mainland_n,
      verbose = verbose
    )
  )
})

test_that("complete stt, 1 type, no geodynamics, oceanic island, one trait state
          (same arguments as geodynamics, 5 pars) verbose", {
  pars <- c(0.4, 0.2, 10, 2, 0.8)
  total_time <- 1
  mainland_n <- 2
  verbose <- TRUE
  area_pars <- create_area_pars(
    max_area = 1,
    current_area = 1,
    proportional_peak_t = 0,
    total_island_age = 0,
    sea_level_amplitude = 0,
    sea_level_frequency = 0,
    island_gradient_angle = 0)
  hyper_pars <- create_hyper_pars(d = 0, x = 0)
  nonoceanic_pars <- c(0, 0)
  set.seed(1)
  replicates <- 3
  island_ontogeny <- 0

  island_replicates <- list()
  for (rep in 1:replicates) {
    island_replicates[[rep]] <- list()
    full_list <- list()
    out <- list()
    for (m_spec in 1:mainland_n) {
      out$branching_times <- c(10)
      while (length(out$branching_times) == 1) {
        out <- DAISIE_sim_core_cr(
          time = total_time,
          mainland_n = 1,
          pars = pars,
          area_pars = area_pars,
          hyper_pars = hyper_pars,
          nonoceanic_pars = nonoceanic_pars
        )
      }
      full_list[[m_spec]] <- out
    }
    island_replicates[[rep]] <- full_list
  }
  expect_message(
    formatted_CS_sim <- DAISIE_format_CS_full_stt(
      island_replicates = island_replicates,
      time = total_time,
      M = mainland_n,
      verbose = verbose
    ),
    regexp = "Island being formatted: 3/3"
  )
})

test_that("complete stt, 1 type, no geodynamics, oceanic,two trait states
          (same arguments as geodynamics, 5 pars)", {
  pars <- c(0.4, 0.2, 10, 2, 0.5)
  total_time <- 1
  mainland_n <- 2
  verbose <- FALSE
  set.seed(1)
  replicates <- 3
  island_ontogeny = 0
  sea_level = 0
  extcutoff = 1000
  trait_pars <- create_trait_pars(
    trans_rate = 0,
    immig_rate2 = 2,
    ext_rate2 = 0.2,
    ana_rate2 = 0.5,
    clado_rate2 = 0.4,
    trans_rate2 = 0,
    M2 = 2)
  island_replicates <- list()
  verbose <- FALSE

  for (rep in 1:replicates) {
    island_replicates[[rep]] <- list()
    full_list <- list()
    trait_pars_addcol <- create_trait_pars(trans_rate = 0,
                                           immig_rate2 = 0,
                                           ext_rate2 = 0,
                                           ana_rate2 = 0,
                                           clado_rate2 = 0,
                                           trans_rate2 = 0,
                                           M2 = 0)
    for (m_spec in 1:mainland_n) {
      full_list[[m_spec]] <- DAISIE_sim_core_trait_dep(
        time = total_time,
        mainland_n = 1,
        pars = pars,
        island_ontogeny = island_ontogeny,
        sea_level = sea_level,
        extcutoff = extcutoff,
        hyper_pars = create_hyper_pars(d = 0, x = 0),
        area_pars = create_area_pars(
          max_area = 1,
          current_area = 1,
          proportional_peak_t = 0,
          total_island_age = 0,
          sea_level_amplitude = 0,
          sea_level_frequency = 0,
          island_gradient_angle = 0),
        trait_pars = trait_pars_addcol
      )
    }
    for(m_spec in (mainland_n + 1):(mainland_n + trait_pars$M2))
    {
      trait_pars_onecolonize <- create_trait_pars(trans_rate = trait_pars$trans_rate,
                                                  immig_rate2 = trait_pars$immig_rate2,
                                                  ext_rate2 = trait_pars$ext_rate2,
                                                  ana_rate2 = trait_pars$ana_rate2,
                                                  clado_rate2 = trait_pars$clado_rate2,
                                                  trans_rate2 = trait_pars$trans_rate2,
                                                  M2 = 1)
      full_list[[m_spec]] <- DAISIE_sim_core_trait_dep(
        time = total_time,
        mainland_n = 0,
        pars = pars,
        island_ontogeny = island_ontogeny,
        sea_level = sea_level,
        extcutoff = extcutoff,
        hyper_pars = create_hyper_pars(d = 0, x = 0),
        area_pars = create_area_pars(
          max_area = 1,
          current_area = 1,
          proportional_peak_t = 0,
          total_island_age = 0,
          sea_level_amplitude = 0,
          sea_level_frequency = 0,
          island_gradient_angle = 0),
        trait_pars = trait_pars_onecolonize
      )

    }
    island_replicates[[rep]] <- full_list
  }
  expect_silent(
    formatted_CS_sim <- DAISIE_format_CS_full_stt(
      island_replicates = island_replicates,
      time = total_time,
      M = mainland_n,
      verbose = verbose,
      trait_pars = trait_pars
    )
  )
})


test_that("when no colonization happens returns 0", {
            pars <- c(0.4, 0.2, 10, 0.000001, 0.5)
            total_time <- 1
            mainland_n <- 1
            area_pars <- create_area_pars(
              max_area = 1,
              current_area = 1,
              proportional_peak_t = 0,
              total_island_age = 0,
              sea_level_amplitude = 0,
              sea_level_frequency = 0,
              island_gradient_angle = 0)
            hyper_pars <- create_hyper_pars(d = 0, x = 0)
            nonoceanic_pars <- c(0, 0)
            verbose <- FALSE
            set.seed(2)
            replicates <- 1
            island_replicates <- list()
              island_replicates[[1]] <- list()
              full_list <- list()
              out <- list()
              for (m_spec in 1:mainland_n) {
                  out <- DAISIE_sim_core_cr(
                    time = total_time,
                    mainland_n = 1,
                    pars = pars,
                    area_pars = area_pars,
                    hyper_pars = hyper_pars,
                    nonoceanic_pars = nonoceanic_pars
                  )
                full_list[[m_spec]] <- out
                }

              island_replicates[[1]] <- full_list



            expect_silent(
              formatted_CS_sim <- DAISIE_format_CS_full_stt(
                island_replicates = island_replicates,
                time = total_time,
                M = mainland_n,
                verbose = verbose
              )
            )

            expect_equal(
              formatted_CS_sim[[1]][[1]]$island_age,
              1
            )
            expect_equal(
              formatted_CS_sim[[1]][[1]]$not_present,
              1
            )
            expect_equal(
              formatted_CS_sim[[1]][[1]]$stt_all[2, ],
              c(Time = 0, nI = 0.0, nA = 0.0, nC = 0.0, present = 0.0)
            )
          })




