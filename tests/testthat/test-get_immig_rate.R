test_that("use area constant diversity-independent", {
  carr_cap <- Inf
  ps_imm_rate <- 0.1
  n_island_species <- 5
  n_mainland_species <- 1
  hyper_pars <- create_hyper_pars(0, 0)
  area <- 1
  created <- get_immig_rate(
    gam = ps_imm_rate,
    A = area,
    num_spec = n_island_species,
    K = carr_cap,
    mainland_n = n_mainland_species)
  expected <- ps_imm_rate * n_mainland_species *
    (1 - n_island_species / carr_cap)

  testthat::expect_equal(expected, created)
})

test_that("use area constant diversity-dependent", {
  carr_cap <- 10
  ps_imm_rate <- 0.1
  n_island_species <- 5
  n_mainland_species <- 1
  hyper_pars <- create_hyper_pars(0, 0)
  area <- 1
  created <- get_immig_rate(
    gam = ps_imm_rate,
    A = area,
    num_spec = n_island_species,
    K = carr_cap,
    mainland_n = n_mainland_species)
  expected <- ps_imm_rate * n_mainland_species *
    (1 - n_island_species / carr_cap)

  testthat::expect_equal(expected, created)
})

test_that("use area variable (ontogeny) diversity-dependent", {
  carr_cap <- 10
  ps_imm_rate <- 0.1
  n_island_species <- 5
  n_mainland_species <- 1
  hyper_pars <- create_hyper_pars(0, 0)
  area <- 10
  created <- get_immig_rate(
    gam = ps_imm_rate,
    A = area,
    num_spec = n_island_species,
    K = carr_cap,
    mainland_n = n_mainland_species)
  expected <- 0.095
  testthat::expect_equal(expected, created)
})
