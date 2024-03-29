test_that("use area constant diversity-independent", {
  ps_clado_rate <- 0.2
  carr_cap <- Inf
  n_species <- 4
  hyper_pars <- create_hyper_pars(d = 0, x = 0)
  area <- 1
  created <- get_clado_rate(
    lac = ps_clado_rate,
    hyper_pars = hyper_pars,
    num_spec = n_species,
    K = carr_cap,
    A = area
  )
  expected <- ps_clado_rate * n_species * (1 - n_species / carr_cap)
  testthat::expect_equal(created, expected)
})

test_that("use area constant diversity-dependent", {
  ps_clado_rate <- 0.2
  carr_cap <- 9
  n_species <- 4
  hyper_pars <- create_hyper_pars(d = 0, x = 0)
  area <- 1
  created <- get_clado_rate(
    lac = ps_clado_rate,
    hyper_pars = hyper_pars,
    num_spec = n_species,
    K = carr_cap,
    A = area
  )
  expected <- ps_clado_rate * n_species * (1 - n_species / carr_cap)
  testthat::expect_equal(created, expected)
})

test_that("use area variable diversity-independent", {
  ps_clado_rate <- 0.2
  carr_cap <- Inf
  n_species <- 4
  hyper_pars <- create_hyper_pars(d = 0.2, x = 0.1)
  area <- 10
  created <- get_clado_rate(
    lac = ps_clado_rate,
    hyper_pars = hyper_pars,
    num_spec = n_species,
    K = carr_cap,
    A = area
  )
  expected <- 1.267914553968891
  testthat::expect_equal(created, expected)
})

test_that("use area variable diversity-dependent", {
  ps_clado_rate <- 0.2
  carr_cap <- 9
  n_species <- 4
  hyper_pars <- create_hyper_pars(d = 0.2, x = 0.1)
  area <- 10
  created <- get_clado_rate(
    lac = ps_clado_rate,
    hyper_pars = hyper_pars,
    num_spec = n_species,
    K = carr_cap,
    A = area
  )
  expected <- 1.211562796014718
  testthat::expect_equal(created, expected)
})
