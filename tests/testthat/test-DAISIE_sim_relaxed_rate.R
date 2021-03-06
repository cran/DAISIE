context("DAISIE_sim_relaxed_rate")

test_that("A relaxed-cladogenesis should run silent wit correct output", {
  set.seed(1)
  replicates <- 1
  expect_silent(
    sim <- DAISIE_sim_relaxed_rate(
      time = 5,
      M = 100,
      pars = c(5, 1, 10, 0.01, 1, 5),
      replicates = replicates,
      relaxed_par = "cladogenesis",
      plot_sims = FALSE,
      verbose = FALSE
    )
  )
  expect_true(is.list(sim))
  expect_true(length(sim) == replicates)
  expect_equal(sim[[1]][[1]]$island_age, 5)
  expect_equal(sim[[1]][[1]]$not_present, 97)
  expect_true(is.matrix(sim[[1]][[1]]$stt_all))
  expect_equal(nrow(sim[[1]][[1]]$stt_all), 26)
  expect_equal(ncol(sim[[1]][[1]]$stt_all), 5)
  expect_length(sim[[1]], 4)
  expect_equal(sim[[1]][[2]]$branching_times,
               c(5.0000000000000000, 2.0534694381058198, 1.7090490323814100,
                 1.6624987034718000, 1.5842640341945800, 1.5103422398951900,
                 0.9381441199311800, 0.8826723461608900, 0.7563448914548900,
                 0.0135276001879401))
  expect_equal(sim[[1]][[2]]$stac, 2)
  expect_equal(sim[[1]][[2]]$missing_species, 0)
})

test_that("A relaxed-extinction should run silent wit correct output", {
  set.seed(1)
  replicates <- 1
  expect_silent(
    sim <- DAISIE_sim_relaxed_rate(
      time = 5,
      M = 100,
      pars = c(1, 0.5, 10, 0.01, 1, 1),
      replicates = replicates,
      relaxed_par = "extinction",
      plot_sims = FALSE,
      verbose = FALSE
    )
  )
  expect_true(is.list(sim))
  expect_true(length(sim) == replicates)
  expect_equal(sim[[1]][[1]]$island_age, 5)
  expect_equal(sim[[1]][[1]]$not_present, 98)
  expect_true(is.matrix(sim[[1]][[1]]$stt_all))
  expect_equal(nrow(sim[[1]][[1]]$stt_all), 26)
  expect_equal(ncol(sim[[1]][[1]]$stt_all), 5)
  expect_length(sim[[1]], 3)
  expect_equal(sim[[1]][[2]]$branching_times,
               c(5.0000000000000000, 1.273147361, 0.834710557,
                 0.503593010, 0.005717738))
  expect_equal(sim[[1]][[2]]$stac, 2)
  expect_equal(sim[[1]][[2]]$missing_species, 0)
})

test_that("A relaxed-K should run silent wit correct output", {
  set.seed(1)
  replicates <- 1
  expect_silent(
    sim <- DAISIE_sim_relaxed_rate(
      time = 5,
      M = 100,
      pars = c(1, 1, 5, 0.01, 1, 5),
      replicates = replicates,
      relaxed_par = "carrying_capacity",
      plot_sims = FALSE,
      verbose = FALSE
    )
  )
  expect_true(is.list(sim))
  expect_true(length(sim) == replicates)
  expect_equal(sim[[1]][[1]]$island_age, 5)
  expect_equal(sim[[1]][[1]]$not_present, 99)
  expect_true(is.matrix(sim[[1]][[1]]$stt_all))
  expect_equal(nrow(sim[[1]][[1]]$stt_all), 26)
  expect_equal(ncol(sim[[1]][[1]]$stt_all), 5)
  expect_length(sim[[1]], 2)
  expect_equal(sim[[1]][[2]]$branching_times,
               c(5.00000000000000, 2.05346943810582))
  expect_equal(sim[[1]][[2]]$stac, 2)
  expect_equal(sim[[1]][[2]]$missing_species, 0)
})

test_that("A relaxed-immigration should run silent wit correct output", {
  set.seed(1)
  replicates <- 1
  expect_silent(
    sim <- DAISIE_sim_relaxed_rate(
      time = 5,
      M = 100,
      pars = c(1, 1, 10, 1, 1, 5),
      replicates = replicates,
      relaxed_par = "immigration",
      plot_sims = FALSE,
      verbose = FALSE
    )
  )
  expect_true(is.list(sim))
  expect_true(length(sim) == replicates)
  expect_equal(sim[[1]][[1]]$island_age, 5)
  expect_equal(sim[[1]][[1]]$not_present, 90)
  expect_true(is.matrix(sim[[1]][[1]]$stt_all))
  expect_equal(nrow(sim[[1]][[1]]$stt_all), 26)
  expect_equal(ncol(sim[[1]][[1]]$stt_all), 5)
  expect_length(sim[[1]], 11)
  expect_equal(sim[[1]][[2]]$branching_times,
               c(5.00000000000000, 0.64585619583728))
  expect_equal(sim[[1]][[2]]$stac, 2)
  expect_equal(sim[[1]][[2]]$missing_species, 0)
})

test_that("A relaxed-anagenesis should run silent wit correct output", {
  set.seed(1)
  replicates <- 1
  expect_silent(
    sim <- DAISIE_sim_relaxed_rate(
      time = 5,
      M = 100,
      pars = c(1, 1, 10, 0.01, 5, 5),
      replicates = replicates,
      relaxed_par = "anagenesis",
      plot_sims = FALSE,
      verbose = FALSE
    )
  )
  expect_true(is.list(sim))
  expect_true(length(sim) == replicates)
  expect_equal(sim[[1]][[1]]$island_age, 5)
  expect_equal(sim[[1]][[1]]$not_present, 98)
  expect_true(is.matrix(sim[[1]][[1]]$stt_all))
  expect_equal(nrow(sim[[1]][[1]]$stt_all), 26)
  expect_equal(ncol(sim[[1]][[1]]$stt_all), 5)
  expect_length(sim[[1]], 3)
  expect_equal(sim[[1]][[2]]$branching_times,
               c(5.00000000000000, 2.05346943810582))
  expect_equal(sim[[1]][[2]]$stac, 2)
  expect_equal(sim[[1]][[2]]$missing_species, 0)
})

test_that("Output is silent and correct for a nonoceanic simulation", {
  set.seed(1)
  replicates <- 1
  expect_silent(
    sim <- DAISIE_sim_relaxed_rate(
      time = 5,
      M = 100,
      pars = c(5, 1, 10, 0.01, 1, 5),
      replicates = replicates,
      relaxed_par = "cladogenesis",
      nonoceanic_pars = c(0.1, 0.9),
      plot_sims = FALSE,
      verbose = FALSE
    )
  )
  expect_true(is.list(sim))
  expect_true(length(sim) == replicates)
  #number of immigrants (nonendemics) is greater than zero
  expect_gt(sim[[1]][[1]]$stt_all[1, 2], 0)
  #number of anagenetic species (endemic) is greater than zero
  expect_gt(sim[[1]][[1]]$stt_all[1, 3], 0)
})

test_that("Oceanic and non-oceanic should give same results when
          initial sampling is zero", {
            n_mainland_species <- 1000
            island_age <- 0.4
            clado_rate <- 2.550687345 # cladogenesis rate
            ext_rate <- 2.683454548 # extinction rate
            clade_carr_cap <- 10.0  # clade-level carrying capacity
            imm_rate <- 0.00933207 # immigration rate
            ana_rate <- 1.010073119 # anagenesis rate
            set.seed(17)
            oceanic_sim <- DAISIE_sim_constant_rate(
              time = island_age,
              M = n_mainland_species,
              pars = c(clado_rate, ext_rate, clade_carr_cap, imm_rate, ana_rate),
              replicates = 1,
              plot_sims = FALSE,
              verbose = FALSE
            )
            set.seed(17)
            nonoceanic_sim <- DAISIE_sim_constant_rate(
              time = island_age,
              M = n_mainland_species,
              pars = c(clado_rate, ext_rate, clade_carr_cap, imm_rate, ana_rate),
              replicates = 1,
              nonoceanic_pars = c(0.0, 0.9),
              plot_sims = FALSE,
              verbose = FALSE
            )
            expect_true(all(names(oceanic_sim) == names(nonoceanic_sim)))
          })

test_that("constant rate oceanic CS prints correct output when
          verbose == TRUE", {
            totaltime <- 1
            mainland_n <- 1
            pars <- c(0.4, 0.2, 10, 2, 0.8)
            replicates <- 1
            verbose <- TRUE
            set.seed(1)
            expect_output(
              sim <- DAISIE::DAISIE_sim_constant_rate(time = totaltime,
                                                      M = mainland_n,
                                                      pars = pars,
                                                      replicates = replicates,
                                                      plot_sims = FALSE,
                                                      verbose = verbose),
              regexp = "Island replicate 1"
            )
          })
