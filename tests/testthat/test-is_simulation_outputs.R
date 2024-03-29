test_that("use", {
  testthat::expect_false(is_simulation_outputs("nonsense"))
  testthat::expect_true(is_simulation_outputs(DAISIE_sim_cr(
    time = 0.4,
    M = 10,
    pars = c(2, 2, Inf, 0.001, 1),
    replicates = 2,
    plot_sims = FALSE,
    verbose = FALSE)))

  testthat::expect_true(is_simulation_outputs(DAISIE_sim_time_dep(
    time = 2,
    M = 500,
    pars = c(0.00001, 1, 0.05, 0.001, 1),
    replicates = 1,
    area_pars = create_area_pars(
      max_area = 10000,
      current_area = 5000,
      proportional_peak_t = 0.1,
      total_island_age = 4,
      sea_level_amplitude = 0,
      sea_level_frequency = 0,
      island_gradient_angle = 0),
    ext_pars = c(0.1, 15),
    hyper_pars = create_hyper_pars(d = 0.2, x = 0.1),
    nonoceanic_pars = c(0, 0),
    island_ontogeny = "beta",
    plot_sims = FALSE,
    verbose = FALSE)
  )
  )
})

test_that("abuse is simulation outputs", {

  output <- DAISIE_sim_cr(
    time = 0.4,
    M = 10,
    pars = c(2, 2, Inf, 0.001, 1),
    replicates = 2,
    plot_sims = FALSE,
    verbose = FALSE
  )
  names(output[[1]][[1]])[2] <- "nonsense"
  testthat::expect_false(is_simulation_outputs(output))
})

test_that("abuse is simulation outputs", {

  output <- DAISIE_sim_cr(
    time = 0.4,
    M = 10,
    pars = c(2, 2, Inf, 0.001, 1),
    replicates = 2,
    plot_sims = FALSE,
    verbose = FALSE
  )
  names(output[[1]][[1]])[3] <- "nonsense"
  testthat::expect_false(is_simulation_outputs(output))
})
