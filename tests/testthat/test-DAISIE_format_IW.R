test_that("silent with empty island with correct output", {
  pars <- c(0.4, 0.2, 10, 0.0001, 0.5)
  time <- 1
  mainland_n <- 10
  verbose <- FALSE
  sample_freq <- 1
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
  island_replicates <- list()
  island_replicates[[1]] <- DAISIE_sim_core_cr(
    time = time,
    pars = pars,
    mainland_n = mainland_n,
    area_pars = area_pars,
    hyper_pars = hyper_pars,
    nonoceanic_pars = nonoceanic_pars
  )
  testthat::expect_silent(
    formatted_IW_sim <- DAISIE_format_IW(
      island_replicates = island_replicates,
      time = time,
      M = mainland_n,
      sample_freq = sample_freq,
      verbose = verbose
    )
  )
  expected_IW_format <- list()
  expected_IW_format[[1]] <- list()
  stt_all <- matrix(ncol = 4, nrow = 2)
  colnames(stt_all) <- c("Time", "nI", "nA", "nC")
  stt_all[1, ] <- c(1, 0, 0, 0)
  stt_all[2, ] <- c(0, 0, 0, 0)
  brts_table <- matrix(ncol = 5, nrow = 1)
  colnames(brts_table) <- c("brt", "clade", "event", "endemic", "col")
  brts_table[1, ] <- c(1, 0, 0, NA, NA)
  expected_IW_format[[1]][[1]] <- list(island_age = 1,
                                       not_present = 10,
                                       stt_all = stt_all,
                                       brts_table = brts_table)
  testthat::expect_equal(formatted_IW_sim, expected_IW_format, tolerance = 1e-7)
})

test_that("silent with non-empty island with correct output", {
  pars <- c(0.4, 0.2, 10, 1, 0.5)
  time <- 1
  mainland_n <- 10
  verbose <- FALSE
  sample_freq <- 1
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
  island_replicates <- list()
  island_replicates[[1]] <- DAISIE_sim_core_cr(
    time = time,
    pars = pars,
    mainland_n = mainland_n,
    area_pars = area_pars,
    hyper_pars = hyper_pars,
    nonoceanic_pars = nonoceanic_pars
  )
  testthat::expect_silent(
    formatted_IW_sim <- DAISIE_format_IW(
      island_replicates = island_replicates,
      time = time,
      M = mainland_n,
      sample_freq = sample_freq,
      verbose = verbose
    )
  )
  expected_IW_format <- list()
  expected_IW_format[[1]] <- list()
  stt_all <- matrix(ncol = 4, nrow = 2)
  colnames(stt_all) <- c("Time", "nI", "nA", "nC")
  stt_all[1, ] <- c(1, 0, 0, 0)
  stt_all[2, ] <- c(0, 2, 0, 3)
  brts_table <- matrix(ncol = 5, nrow = 6)
  colnames(brts_table) <- c("brt", "clade", "event", "endemic", "col")
  brts_table[1, ] <- c(1, 0, 0, NA, NA)
  brts_table[2, ] <- c(0.9244818166871660, 1, 1, 1, 1)
  brts_table[3, ] <- c(0.9105856673960619, 1, 2, 1, 1)
  brts_table[4, ] <- c(0.5557734125062590, 2, 1, 0, 1)
  brts_table[5, ] <- c(0.5288428248966160, 3, 1, 0, 1)
  brts_table[6, ] <- c(0.3146835586399670, 1, 3, 1, 1)
  expected_IW_format[[1]][[1]] <- list(island_age = 1,
                                       not_present = 7,
                                       stt_all = stt_all,
                                       brts_table = brts_table)
  expected_IW_format[[1]][[2]] <- list(branching_times = c(1.00000000000000,
                                                           0.924481816687166,
                                                           0.910585667396062,
                                                           0.314683558639967),
                                       stac = 2,
                                       missing_species = 0)
  expected_IW_format[[1]][[3]] <- list(branching_times = c(1.000000000000000,
                                                           0.555773412506259),
                                       stac = 4,
                                       missing_species = 0)
  expected_IW_format[[1]][[4]] <- list(branching_times = c(1.000000000000000,
                                                           0.5288428248966160),
                                       stac = 4,
                                       missing_species = 0)
  testthat::expect_equal(formatted_IW_sim, expected_IW_format, tolerance = 1e-7)
})

test_that("DAISIE_format_IW prints when verbose = TRUE", {
  pars <- c(0.4, 0.2, 10, 1, 0.5)
  time <- 1
  mainland_n <- 1000
  verbose <- TRUE
  sample_freq <- 1
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
  island_replicates <- list()
  island_replicates[[1]] <- DAISIE_sim_core_cr(
    time = time,
    pars = pars,
    mainland_n = mainland_n,
    area_pars = area_pars,
    hyper_pars = hyper_pars,
    nonoceanic_pars = nonoceanic_pars
  )
  testthat::expect_message(
    formatted_IW_sim <- DAISIE_format_IW(
      island_replicates = island_replicates,
      time = time,
      M = mainland_n,
      sample_freq = sample_freq,
      verbose = verbose
    ),
    "Island being formatted: 1/1"
  )
})

test_that("silent with empty nonoceanic island with correct output", {
  pars <- c(0.4, 2, 10, 0.0001, 0.5)
  time <- 1
  mainland_n <- 10
  nonoceanic_pars <- c(0.2, 0.5)
  verbose <- FALSE
  sample_freq <- 1
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
  island_replicates[[1]] <- DAISIE_sim_core_cr(
    time = time,
    mainland_n = mainland_n,
    pars = pars,
    area_pars = area_pars,
    hyper_pars = hyper_pars,
    nonoceanic_pars = nonoceanic_pars
  )
  testthat::expect_silent(
    formatted_IW_sim <- DAISIE_format_IW(
      island_replicates = island_replicates,
      time = time,
      M = mainland_n,
      sample_freq = sample_freq,
      verbose = verbose
    )
  )
  expected_IW_format <- list()
  expected_IW_format[[1]] <- list()
  stt_all <- matrix(ncol = 4, nrow = 2)
  colnames(stt_all) <- c("Time", "nI", "nA", "nC")
  stt_all[1, ] <- c(1, 1, 2, 0)
  stt_all[2, ] <- c(0, 0, 0, 0)
  brts_table <- matrix(ncol = 5, nrow = 1)
  colnames(brts_table) <- c("brt", "clade", "event", "endemic", "col")
  brts_table[1, ] <- c(1, 0, 0, NA, NA)
  expected_IW_format[[1]][[1]] <- list(island_age = 1,
                                       not_present = 10,
                                       stt_all = stt_all,
                                       brts_table = brts_table)
  testthat::expect_equal(formatted_IW_sim, expected_IW_format)
})

test_that("silent with non-empty nonoceanic island with
          correct output", {
            pars <- c(0.4, 0.2, 1, 1, 0.5)
            time <- 1
            mainland_n <- 10
            nonoceanic_pars <- c(0.2, 0.5)
            verbose <- FALSE
            sample_freq <- 1
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
            island_replicates[[1]] <- DAISIE_sim_core_cr(
              time = time,
              mainland_n = mainland_n,
              pars = pars,
              nonoceanic_pars = nonoceanic_pars,
              area_pars = area_pars,
              hyper_pars = hyper_pars
            )
            testthat::expect_silent(
              formatted_IW_sim <- DAISIE_format_IW(
                island_replicates = island_replicates,
                time = time,
                M = mainland_n,
                sample_freq = sample_freq,
                verbose = verbose
              )
            )
            expected_IW_format <- list()
            expected_IW_format[[1]] <- list()
            stt_all <- matrix(ncol = 4, nrow = 2)
            colnames(stt_all) <- c("Time", "nI", "nA", "nC")
            stt_all[1, ] <- c(1, 1, 2, 0)
            stt_all[2, ] <- c(0, 0, 2, 0)
            brts_table <- matrix(ncol = 5, nrow = 3)
            colnames(brts_table) <- c("brt", "clade", "event", "endemic", "col")
            brts_table[1, ] <- c(1, 0, 0, NA, NA)
            brts_table[2, ] <- c(1, 2, 1, 1, 1)
            brts_table[3, ] <- c(1, 1, 1, 1, 1)
            expected_IW_format[[1]][[1]] <- list(island_age = 1,
                                                 not_present = 8,
                                                 stt_all = stt_all,
                                                 brts_table = brts_table)
            expected_IW_format[[1]][[2]] <- list(branching_times = c(1, 1),
                                                 stac = 2,
                                                 missing_species = 0)
            expected_IW_format[[1]][[3]] <- list(branching_times = c(1, 1),
                                                 stac = 2,
                                                 missing_species = 0)
  testthat::expect_equal(formatted_IW_sim, expected_IW_format, tolerance = 1e-7)
})

test_that("silent with non-empty nonoceanic island with
          correct output", {
            pars <- c(0.4, 0.2, 1, 1, 0.5)
            time <- 1
            mainland_n <- 10
            nonoceanic_pars <- c(0.2, 0.5)
            verbose <- FALSE
            sample_freq <- 1
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
            island_replicates[[1]] <- DAISIE_sim_core_cr(
              time = time,
              mainland_n = mainland_n,
              pars = pars,
              nonoceanic_pars = nonoceanic_pars,
              area_pars = area_pars,
              hyper_pars = hyper_pars
            )
            testthat::expect_silent(
              formatted_IW_sim <- DAISIE_format_IW(
                island_replicates = island_replicates,
                time = time,
                M = mainland_n,
                sample_freq = sample_freq,
                verbose = verbose
              )
            )
            expected_IW_format <- list()
            expected_IW_format[[1]] <- list()
            stt_all <- matrix(ncol = 4, nrow = 2)
            colnames(stt_all) <- c("Time", "nI", "nA", "nC")
            stt_all[1, ] <- c(1, 1, 2, 0)
            stt_all[2, ] <- c(0, 0, 2, 0)
            brts_table <- matrix(ncol = 5, nrow = 3)
            colnames(brts_table) <- c("brt", "clade", "event", "endemic", "col")
            brts_table[1, ] <- c(1, 0, 0, NA, NA)
            brts_table[2, ] <- c(1, 2, 1, 1, 1)
            brts_table[3, ] <- c(1, 1, 1, 1, 1)
            expected_IW_format[[1]][[1]] <- list(island_age = 1,
                                                 not_present = 8,
                                                 stt_all = stt_all,
                                                 brts_table = brts_table)
            expected_IW_format[[1]][[2]] <- list(branching_times = c(1, 1),
                                                 stac = 2,
                                       missing_species = 0)
  expected_IW_format[[1]][[3]] <- list(branching_times = c(1, 1),
                                       stac = 2,
                                       missing_species = 0)
  testthat::expect_equal(formatted_IW_sim, expected_IW_format, tolerance = 1e-7)
})

test_that("add_brt_table output is correct when length(island) == 1", {
  stt_all <- matrix(ncol = 4, nrow = 2)
  colnames(stt_all) <- c("Time", "nI", "nA", "nC")
  stt_all[1, ] <- c(1, 0, 0, 0)
  stt_all[2, ] <- c(0, 0, 0, 0)
  island <- list()
  island[[1]] <- list(island_age = 1,
                      not_present = 100,
                      stt_all = stt_all,
                      init_nonend_spec = 0,
                      init_end_spec = 0)
  formatted_brt <- add_brt_table(island)
  brt_table <- matrix(ncol = 5, nrow = 1)
  colnames(brt_table) <- c("brt", "clade", "event", "endemic", "col")
  brt_table[1, ] <- c(1, 0, 0, NA, NA)
  expected_brt <- list()
  expected_brt[[1]] <- list(island_age = 1,
                            not_present = 100,
                            stt_all = stt_all,
                            init_nonend_spec = 0,
                            init_end_spec = 0,
                            brts_table = brt_table)
  testthat::expect_equal(formatted_brt, expected_brt)
})

test_that("add_brt_table output is correct when length(island) != 1", {
  stt_all <- matrix(ncol = 4, nrow = 2)
  colnames(stt_all) <- c("Time", "nI", "nA", "nC")
  stt_all[1, ] <- c(1, 0, 0, 0)
  stt_all[2, ] <- c(0, 2, 0, 3)
  island <- list()
  island[[1]] <- list(island_age = 1,
                      not_present = 3,
                      stt_all = stt_all,
                      init_nonend_spec = 0,
                      init_end_spec = 0)
  island[[2]] <- list(branching_times = c(1.0000000,
                                          0.5557734),
                      stac = 4,
                      missing_species = 0)
  island[[3]] <- list(branching_times = c(1.0000000,
                                          0.9244818,
                                          0.9105857,
                                          0.3146836),
                      stac = 2,
                      missing_species = 0)
  island[[4]] <- list(brancing_times = c(1.0000000,
                                         0.5288428),
                      stac = 4,
                      missing_species = 0)
  formatted_brt <- add_brt_table(island)
  brt_table <- matrix(ncol = 5, nrow = 5)
  colnames(brt_table) <- c("brt", "clade", "event", "endemic", "col")
  brt_table[1, ] <- c(1, 0, 0, NA, NA)
  brt_table[2, ] <- c(0.9244818, 1, 1, 1, 1)
  brt_table[3, ] <- c(0.9105857, 1, 2, 1, 1)
  brt_table[4, ] <- c(0.5557734, 2, 1, 0, 1)
  brt_table[5, ] <- c(0.3146836, 1, 3, 1, 1)
  expected_brt <- list()
  expected_brt[[1]] <- list(island_age = 1,
                            not_present = 3,
                            stt_all = stt_all,
                            init_nonend_spec = 0,
                            init_end_spec = 0,
                            brts_table = brt_table)
  expected_brt[[2]] <- list(branching_times = c(1.0000000,
                                                0.9244818,
                                                0.9105857,
                                                0.3146836),
                            stac = 2,
                            missing_species = 0)
  expected_brt[[3]] <- list(branching_times = c(1.0000000,
                                                0.5557734),
                            stac = 4,
                            missing_species = 0)
  testthat::expect_equal(formatted_brt, expected_brt)
})
#test_that("add_brt_table output is correct when length(stac1_5s) != 0")
#test_that("add_brt_table output is correct when length(stac1_5s) == 0")
#test_that("add_brt_table output is correct when length(island_no_stac1or5) != 0")

test_that("abuse", {
  testthat::expect_error(DAISIE_format_IW("nonsense"))
})

test_that("abuse", {
  testthat::expect_error(add_brt_table("nonsense"))
})



######  add format_IW_trait tests from here ####
test_that("silent with empty island with correct output", {
  pars <- c(0.4, 0.2, 10, 0.0001, 0.5)
  trait_pars <- create_trait_pars(
    trans_rate = 0,
    immig_rate2 = 0.0002,
    ext_rate2 = 0.2,
    ana_rate2 = 0.5,
    clado_rate2 = 0.4,
    trans_rate2 = 0,
    M2 = 10)
  time <- 1
  mainland_n <- 10
  verbose <- FALSE
  sample_freq <- 1
  start_midway <- FALSE
  set.seed(1)
  island_replicates <- list()
  island_replicates[[1]] <- DAISIE_sim_core_trait_dep(
    time = time,
    pars = pars,
    hyper_pars = create_hyper_pars(d = 0, x = 0),
    area_pars = create_area_pars(
      max_area = 1,
      current_area = 1,
      proportional_peak_t = 0,
      total_island_age = 0,
      sea_level_amplitude = 0,
      sea_level_frequency = 0,
      island_gradient_angle = 0),
    trait_pars = trait_pars,
    mainland_n = mainland_n
  )
  testthat::expect_silent(
    formatted_IW_sim <- DAISIE_format_IW(
      island_replicates = island_replicates,
      time = time,
      M = mainland_n,
      sample_freq = sample_freq,
      verbose = verbose,
      trait_pars = trait_pars
    )
  )
  expected_IW_format <- list()
  expected_IW_format[[1]] <- list()
  stt_all <- matrix(ncol = 7, nrow = 2)
  colnames(stt_all) <- c("Time", "nI", "nA", "nC", "nI2", "nA2", "nC2")
  stt_all[1, ] <- c(1, 0, 0, 0, 0, 0, 0)
  stt_all[2, ] <- c(0, 0, 0, 0, 0, 0, 0)
  brts_table <- matrix(ncol = 5, nrow = 1)
  colnames(brts_table) <- c("brt", "clade", "event", "endemic", "col")
  brts_table[1, ] <- c(1, 0, 0, NA, NA)
  expected_IW_format[[1]][[1]] <- list(island_age = 1,
                                       not_present = 20,
                                       stt_all = stt_all,
                                       brts_table = brts_table)
  testthat::expect_equal(formatted_IW_sim, expected_IW_format, tolerance = 1e-7)
})

test_that("silent when species with two trait states with
          correct output", {
            pars <- c(0.4, 0.2, 10, 0.06, 0.5)
            time <- 5
            mainland_n <- 10
            verbose <- FALSE
            replicates <- 3
            island_ontogeny = 0
            sea_level = 0
            extcutoff = 1000
            sample_freq <- 1
            trait_pars <- create_trait_pars(
              trans_rate = 0,
              immig_rate2 = 0.1,
              ext_rate2 = 0.2,
              ana_rate2 = 0.5,
              clado_rate2 = 0.4,
              trans_rate2 = 0,
              M2 = 5)
            island_replicates <- list()
            verbose <- FALSE
            set.seed(1)
            island_replicates[[1]] <- DAISIE_sim_core_trait_dep(
              time = time,
              mainland_n = mainland_n,
              pars = pars,
              trait_pars = trait_pars,
              island_ontogeny = island_ontogeny,
              sea_level = sea_level,
              hyper_pars = create_hyper_pars(d = 0, x = 0),
              area_pars = create_area_pars(
                max_area = 1,
                current_area = 1,
                proportional_peak_t = 0,
                total_island_age = 0,
                sea_level_amplitude = 0,
                sea_level_frequency = 0,
                island_gradient_angle = 0),
              extcutoff = extcutoff
            )
            testthat::expect_silent(
              formatted_IW_sim <- DAISIE_format_IW(
                island_replicates = island_replicates,
                time = time,
                M = mainland_n,
                sample_freq = sample_freq,
                verbose = verbose,
                trait_pars = trait_pars
              )
            )
            expected_IW_format <- list()
            expected_IW_format[[1]] <- list()
            stt_all <- matrix(ncol = 7, nrow = 2)
            colnames(stt_all) <- c("Time", "nI", "nA", "nC", "nI2", "nA2", "nC2")
            stt_all[1, ] <- c(5, 0, 0, 0, 0, 0, 0)
            stt_all[2, ] <- c(0, 0, 1, 2, 0, 0, 0)
            brts_table <- matrix(ncol = 5, nrow = 4)
            colnames(brts_table) <- c("brt", "clade", "event", "endemic", "col")
            brts_table[1, ] <- c(5.00000000000000, 0, 0, NA, NA)
            brts_table[2, ] <- c(3.10261367452990, 1, 1, 1, 1)
            brts_table[3, ] <- c(1.50562999775257, 2, 1, 1, 1)
            brts_table[4, ] <- c(1.26245655913561, 2, 2, 1, 1)
            expected_IW_format[[1]][[1]] <- list(island_age = 5,
                                                 not_present = 13,
                                                 stt_all = stt_all,
                                                 brts_table = brts_table)

            expected_IW_format[[1]][[2]] <- list(
              branching_times = c(5.0000000000000,
                                  3.1026136745299),
              stac = 2,
              missing_species = 0
            )
            expected_IW_format[[1]][[3]] <- list(
              branching_times = c(5.00000000000000,
                                  1.50562999775257,
                                  1.26245655913561),
              stac = 2,
              missing_species = 0
            )
            testthat::expect_equal(formatted_IW_sim, expected_IW_format, tolerance = 1e-7)
          })
