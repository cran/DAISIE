# Don't document this function. For internal use only.
DAISIE_loglik_all_choosepar <- function(trparsopt,
                                        trparsfix,
                                        idparsopt,
                                        idparsfix,
                                        idparsnoshift,
                                        idparseq,
                                        pars2,
                                        datalist,
                                        methode,
                                        CS_version = 1,
                                        abstolint = 1E-16,
                                        reltolint = 1E-10) {
  if (sum(idparsnoshift %in% (6:10)) != 5) {
    trpars1 <- rep(0, 11)
  } else {
    trpars1 <- rep(0, 5)
    trparsfix <- trparsfix[-which(idparsfix == 11)]
    idparsfix <- idparsfix[-which(idparsfix == 11)]
  }
  trpars1[idparsopt] <- trparsopt
  if (length(idparsfix) != 0) {
    trpars1[idparsfix] <- trparsfix
  }
  if (sum(idparsnoshift %in% (6:10)) != 5) {
    trpars1[idparsnoshift] <- trpars1[idparsnoshift - 5]
  }
  if (max(trpars1) > 1 | min(trpars1) < 0) {
    loglik <- -Inf
  } else {
    pars1 <- trpars1 / (1 - trpars1)
    if (pars2[6] > 0) {
      pars1 <- DAISIE_eq(datalist, pars1, pars2[-5])
      if (sum(idparsnoshift %in% (6:10)) != 5) {
        pars1[idparsnoshift] <- pars1[idparsnoshift - 5]
      }
    }
    if (min(pars1) < 0) {
      loglik <- -Inf
    } else {
      loglik <- DAISIE::DAISIE_loglik_all(
        pars1 = pars1,
        pars2 = pars2,
        datalist = datalist,
        methode = methode,
        CS_version = CS_version,
        abstolint = abstolint,
        reltolint = reltolint
      )
    }
    if (is.nan(loglik) || is.na(loglik)) {
      cat("There are parameter values used
             which cause numerical problems.\n")
      loglik <- -Inf
    }
  }
  return(loglik)
}

#' Computes MLE for single type species under a clade specific scenario
#'
#' @inheritParams default_params_doc
#'
#' @keywords internal
#'
#' @return The output is a dataframe containing estimated parameters and
#' maximum loglikelihood.  \item{lambda_c}{ gives the maximum likelihood
#' estimate of lambda^c, the rate of cladogenesis} \item{mu}{ gives the maximum
#' likelihood estimate of mu, the extinction rate} \item{K}{ gives the maximum
#' likelihood estimate of K, the carrying-capacity} \item{gamma}{ gives the
#' maximum likelihood estimate of gamma, the immigration rate }
#' \item{lambda_a}{ gives the maximum likelihood estimate of lambda^a, the rate
#' of anagenesis} \item{loglik}{ gives the maximum loglikelihood} \item{df}{
#' gives the number
#' of estimated parameters, i.e. degrees of feedom} \item{conv}{ gives a
#' message on convergence of optimization; conv = 0 means convergence}
DAISIE_ML1 <- function(
  datalist,
  initparsopt,
  idparsopt,
  parsfix,
  idparsfix,
  idparsnoshift = 6:10,
  res = 100,
  ddmodel = 0,
  cond = 0,
  eqmodel = 0,
  x_E = 0.95,
  x_I = 0.98,
  tol = c(1E-4, 1E-5, 1E-7),
  maxiter = 1000 * round((1.25) ^ length(idparsopt)),
  methode = "lsodes",
  optimmethod = "subplex",
  CS_version = 1,
  verbose = 0,
  tolint = c(1E-16, 1E-10),
  island_ontogeny = NA,
  jitter = 0) {
  # datalist = list of all data: branching times, status of clade, and numnber of missing species
  # datalist[[,]][1] = list of branching times (positive, from present to past)
  # - max(brts) = age of the island
  # - next largest brts = stem age / time of divergence from the mainland
  # The interpretation of this depends on stac (see below)
  # For stac = 0, this needs to be specified only once.
  # For stac = 1, this is the time since divergence from the immigrant's sister on the mainland.
  # The immigrant must have immigrated at some point since then.
  # For stac = 2 and stac = 3, this is the time since divergence from the mainland.
  # The immigrant that established the clade on the island must have immigrated precisely at this point.
  # For stac = 3, it must have reimmigrated, but only after the first immigrant had undergone speciation.
  # - min(brts) = most recent branching time (only for stac = 2, or stac = 3)
  # datalist[[,]][2] = list of status of the clades formed by the immigrant
  #  . stac == 0 : immigrant is not present and has not formed an extant clade
  # Instead of a list of zeros, here a number must be given with the number of clades having stac = 0
  #  . stac == 1 : immigrant is present but has not formed an extant clade
  #  . stac == 2 : immigrant is not present but has formed an extant clade
  #  . stac == 3 : immigrant is present and has formed an extant clade
  #  . stac == 4 : immigrant is present but has not formed an extant clade, and it is known when it immigrated.
  #  . stac == 5 : immigrant is not present and has not formed an extent clade, but only an endemic species
  # datalist[[,]][3] = list with number of missing species in clades for stac = 2 and stac = 3;
  # for stac = 0 and stac = 1, this number equals 0.
  # initparsopt, parsfix = optimized and fixed model parameters
  # - pars1[1] = lac = (initial) cladogenesis rate
  # - pars1[2] = mu = extinction rate
  # - pars1[3] = K = maximum number of species possible in the clade
  # - pars1[4] = gam = (initial) immigration rate
  # - pars1[5] = laa = (initial) anagenesis rate
  # - pars1[6]...pars1[10] = same as pars1[1]...pars1[5], but for a second type of immigrant
  # - pars1[11] = proportion of type 2 immigrants in species pool
  # idparsopt, idparsfix = ids of optimized and fixed model parameters
  # - res = pars2[1] = lx = length of ODE variable x
  # - ddmodel = pars2[2] = diversity-dependent model,mode of diversity-dependence
  #  . ddmodel == 0 : no diversity-dependence
  #  . ddmodel == 1 : linear dependence in speciation rate (anagenesis and cladogenesis)
  #  . ddmodel == 11 : linear dependence in speciation rate and immigration rate
  #  . ddmodel == 3 : linear dependence in extinction rate
  # - cond = conditioning; currently only cond = 0 is possible
  #  . cond == 0 : no conditioning
  #  . cond == 1 : conditioning on presence on the island
  # - eqmodel = equilibrium model
  #  . eqmodel = 0 : no equilibrium is assumed
  #  . eqmodel = 1 : equilibrium is assumed on deterministic equation for total number of species
  #  . eqmodel = 2 : equilibrium is assumed on total number of species using deterministic equation for endemics and immigrants
  #  . eqmodel = 3 : equilibrium is assumed on endemics using deterministic equation for endemics and immigrants
  #  . eqmodel = 4 : equilibrium is assumed on immigrants using deterministic equation for endemics and immigrants
  #  . eqmodel = 5 : equilibrium is assumed on endemics and immigrants using deterministic equation for endemics and immigrants


  out2err <- data.frame(
    lambda_c = NA,
    mu = NA,
    K = NA,
    gamma = NA,
    lambda_a = NA,
    loglik = NA,
    df = NA,
    conv = NA
  )
  out2err <- invisible(out2err)
  idparseq <- c()
  if (eqmodel == 1 | eqmodel == 3 | eqmodel == 13) {
    idparseq <- 2
  }
  if (eqmodel == 2 | eqmodel == 4) {
    idparseq <-  4
  }
  if (eqmodel == 5 | eqmodel == 15) {
    idparseq <- c(2, 4)
  }
  namepars <- c(
    "lambda_c",
    "mu",
    "K",
    "gamma",
    "lambda_a",
    "lambda_c2",
    "mu2",
    "K2",
    "gamma2",
    "lambda_a2",
    "prop_type2"
  )

  if (length(namepars[idparsopt]) == 0) {
    optstr <- "nothing"
  } else {
    optstr <- namepars[idparsopt]
  }

  cat("You are optimizing", optstr, "\n")
  if (length(namepars[idparsfix]) == 0) {
    fixstr <- "nothing"
  } else {
    fixstr <- namepars[idparsfix]
  }
  cat("You are fixing", fixstr, "\n")
  if (sum(idparsnoshift %in% (6:10)) != 5) {
    noshiftstring <- namepars[idparsnoshift]
    cat("You are not shifting", noshiftstring, "\n")
  }
  idpars <- sort(c(idparsopt, idparsfix, idparsnoshift, idparseq))
  if (!any(idpars == 11)) {
    idpars <- c(idpars, 11)
    idparsfix <- c(idparsfix, 11)
    parsfix <- c(parsfix, 0)
  }
  missnumspec <- unlist(lapply(datalist, function(list) {list$missing_species})) # nolint
  if (sum(missnumspec) > (res - 1)) {
    cat(
      "The number of missing species is too large relative to the
        resolution of the ODE.\n")
    return(out2err)
  }
  if (length(idpars) != 11) {
    cat("You have too many parameters to be optimized or fixed.\n")
    return(out2err)
  }
  if ((prod(idpars == (1:11)) != 1) || # nolint
      (length(initparsopt) != length(idparsopt)) ||
      (length(parsfix) != length(idparsfix))) {
    cat("The parameters to be optimized and/or fixed are incoherent.\n")
    return(out2err)
  }
  if (length(idparseq) == 0) {
  } else {
    if (ddmodel == 3) {
      cat("Equilibrium optimization is not implemented for ddmodel = 3\n")
    } else {
      cat(
        "You are assuming equilibrium. Extinction and/or immigration will
          be considered a function of the other parameters, the species
          pool size, the number of endemics,
          and/or the number of non-endemics\n"
      )
    }
  }
  cat("Calculating the likelihood for the initial parameters.", "\n")
  utils::flush.console()
  trparsopt <- initparsopt / (1 + initparsopt)
  trparsopt[which(initparsopt == Inf)] <- 1
  trparsfix <- parsfix / (1 + parsfix)
  trparsfix[which(parsfix == Inf)] <- 1
  pars2 <- c(
    res,
    ddmodel,
    cond,
    verbose,
    island_ontogeny,
    eqmodel,
    tol,
    maxiter,
    x_E,
    x_I
  )

  optimpars <- c(tol, maxiter)
  initloglik <- DAISIE_loglik_all_choosepar(
    trparsopt = trparsopt,
    trparsfix = trparsfix,
    idparsopt = idparsopt,
    idparsfix = idparsfix,
    idparsnoshift = idparsnoshift,
    idparseq = idparseq,
    pars2 = pars2,
    datalist = datalist,
    methode = methode,
    CS_version = CS_version,
    abstolint = tolint[1],
    reltolint = tolint[2]
  )
  cat(
    "The loglikelihood for the initial parameter values is",
    initloglik,
    "\n"
  )
  if (initloglik == -Inf) {
    cat(
      "The initial parameter values have a likelihood that is equal to 0 or
       below machine precision. Try again with different initial values.\n"
    )
    return(out2err)
  }
  cat("Optimizing the likelihood - this may take a while.", "\n")
  utils::flush.console()
  out <- DDD::optimizer(
    optimmethod = optimmethod,
    optimpars = optimpars,
    fun = DAISIE_loglik_all_choosepar,
    trparsopt = trparsopt,
    idparsopt = idparsopt,
    trparsfix = trparsfix,
    idparsfix = idparsfix,
    idparsnoshift = idparsnoshift,
    idparseq = idparseq,
    pars2 = pars2,
    datalist = datalist,
    methode = methode,
    CS_version = CS_version,
    abstolint = tolint[1],
    reltolint = tolint[2],
    jitter = jitter
  )
  if (out$conv != 0) {
    cat(
      "Optimization has not converged.
        Try again with different initial values.\n")
    out2 <- out2err
    out2$conv <- out$conv
    return(out2)
  }
  MLtrpars <- as.numeric(unlist(out$par))
  MLpars <- MLtrpars / (1 - MLtrpars)
  ML <- as.numeric(unlist(out$fvalues))

  if (sum(idparsnoshift %in% (6:10)) != 5) {
    MLpars1 <- rep(0, 10)
  } else {
    MLpars1 <- rep(0, 5)
  }
  MLpars1[idparsopt] <- MLpars
  if (length(idparsfix) != 0) {
    MLpars1[idparsfix] <- parsfix
  }

  if (eqmodel > 0) {
    MLpars1 <- DAISIE_eq(datalist, MLpars1, pars2[-5])
  }

  if (MLpars1[3] > 10 ^ 7) {
    MLpars1[3] <- Inf
  }

  if (sum(idparsnoshift %in% (6:10)) != 5) {
    if (length(idparsnoshift) != 0) {
      MLpars1[idparsnoshift] <- MLpars1[idparsnoshift - 5]
    }
    if (MLpars1[8] > 10 ^ 7) {
      MLpars1[8] <- Inf
    }
    out2 <- data.frame(
      lambda_c = MLpars1[1],
      mu = MLpars1[2],
      K = MLpars1[3],
      gamma = MLpars1[4],
      lambda_a = MLpars1[5],
      lambda_c2 = MLpars1[6],
      mu2 = MLpars1[7],
      K2 = MLpars1[8],
      gamma2 = MLpars1[9],
      lambda_a2 = MLpars1[10],
      prop_type2 = MLpars1[11],
      loglik = ML,
      df = length(initparsopt),
      conv = unlist(out$conv)
    )
    s1 <- sprintf(
      "Maximum likelihood parameter estimates: lambda_c: %f, mu: %f, K: %f,
      gamma: %f, lambda_a: %f, lambda_c2: %f, mu2: %f, K2: %f, gamma2: %f,
      lambda_a2: %f, prop_type2: %f",
      MLpars1[1],
      MLpars1[2],
      MLpars1[3],
      MLpars1[4],
      MLpars1[5],
      MLpars1[6],
      MLpars1[7],
      MLpars1[8],
      MLpars1[9],
      MLpars1[10],
      MLpars1[11]
    )
  } else {
    out2 <- data.frame(
      lambda_c = MLpars1[1],
      mu = MLpars1[2],
      K = MLpars1[3],
      gamma = MLpars1[4],
      lambda_a = MLpars1[5],
      loglik = ML,
      df = length(initparsopt),
      conv = unlist(out$conv)
    )
    s1 <- sprintf(
      "Maximum likelihood parameter estimates: lambda_c: %f, mu: %f, K: %f,
      gamma: %f, lambda_a: %f",
      MLpars1[1],
      MLpars1[2],
      MLpars1[3],
      MLpars1[4],
      MLpars1[5]
    )
  }
  s2 <- sprintf("Maximum loglikelihood: %f", ML)
  cat("\n", s1, "\n", s2, "\n")
  if (eqmodel > 0) {
    M <- calcMN(datalist, MLpars1)
    ExpEIN <- DAISIE_ExpEIN(datalist[[1]]$island_age, MLpars1, M) # nolint start
    cat("The expected number of endemics, non-endemics, and the total at
        these parameters is: ",
        ExpEIN[[1]],
        ExpEIN[[2]],
        ExpEIN[[3]]
    ) # nolint end
  }
  return(invisible(out2))
}
