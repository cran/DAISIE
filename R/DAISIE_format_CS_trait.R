DAISIE_format_CS_trait <- function(island_replicates,
                                   time,
                                   M,
                                   sample_freq,
                                   verbose = TRUE,
                                   trait_pars = NULL)
{
  total_time <- time
  several_islands <- list()

  for(rep in 1:length(island_replicates))
  {
    full_list <- island_replicates[[rep]]
    stac_vec <- unlist(full_list)[which(names(unlist(full_list)) == "stac")]
    number_not_present <- length(which(stac_vec == 0))
    present <- which(stac_vec!=0)
    number_present <- length(present)
    type_vec <- unlist(full_list)[which(names(unlist(full_list)) == "type1or2")]
    prop_type2_pool <- length(which(type_vec == 2)) / M

    number_type2_cols <- length(which(match(which(stac_vec != 0),which(type_vec == 2)) > 0))
    number_type1_cols <- number_present-number_type2_cols

    island_list <- list()
    for(i in 1:(number_present + 1))
    {
      island_list[[i]] = list()
    }

    ### all species
    stt_list = list()
    for(i in 1:(M + trait_pars$M2))
    {
      stt_list[[i]] = full_list[[i]]$stt_table
    }
    stt_all = matrix(ncol = 8,nrow = sample_freq + 1)

    colnames(stt_all) = c("Time","nI","nA","nC","nI2","nA2","nC2","present")
    stt_all[,"Time"] = rev(seq(from = 0,to = total_time,length.out = sample_freq + 1))

    ####
    immig_spec <- c()
    ana_spec <- c()
    immig_spec2 <- c()
    ana_spec2 <- c()
    for (i in 1:(M + trait_pars$M2)) {
      immig_spec[i] <- sum(full_list[[i]]$stt_table[1, 2])
      ana_spec[i] <- sum(full_list[[i]]$stt_table[1, 3])
      immig_spec2[i] <- sum(full_list[[i]]$stt_table[1, 5])
      ana_spec2[i] <- sum(full_list[[i]]$stt_table[1, 6])
    }
    immig_spec <- sum(immig_spec)
    ana_spec <- sum(ana_spec)
    immig_spec2 <- sum(immig_spec2)
    ana_spec2 <- sum(ana_spec2)
    init_present <- immig_spec + ana_spec + immig_spec2 + ana_spec2
    stt_all[1, 2:8] <- c(immig_spec, ana_spec, 0, immig_spec2, ana_spec2, 0, init_present)

    ####
    for(i in 2:nrow(stt_all))
    {
      the_age = stt_all[i,"Time"]
      store_richness_time_slice = matrix(nrow = M + trait_pars$M2,ncol = 6)
      colnames(store_richness_time_slice) = c("I","A","C","I2","A2","C2")
      for(x in 1:(M + trait_pars$M2))
      {
        # testit::assert(x >= 1)
        # testit::assert(x <= length(stt_list))
        # testit::assert("Time" %in% colnames(stt_list[[x]]))
        store_richness_time_slice[x,] = stt_list[[x]][max(which(stt_list[[x]][,"Time"] >= the_age)),2:7]
      }
      count_time_slice = store_richness_time_slice[,1] +
        store_richness_time_slice[,2] +
        store_richness_time_slice[,3] +
        store_richness_time_slice[,4] +
        store_richness_time_slice[,5] +
        store_richness_time_slice[,6]
      present_time_slice = rep(0, M + trait_pars$M2)
      present_time_slice[which(count_time_slice>0)] = 1
      store_richness_time_slice = cbind(store_richness_time_slice,present_time_slice)
      stt_all[i,c(2:8)] = apply(store_richness_time_slice,2,sum)
    }

    island_list[[1]] = list(
      island_age = total_time,
      not_present = number_not_present,
      stt_all = stt_all
    )


    if(number_present > 0)
    {
      for(i in 1:number_present)
      {
        island_list[[1 + i]] = full_list[[present[i]]]
        island_list[[1 + i]]$stt_table = NULL
      }
    }

    if(number_present == 0)
    {
      island_list = list()
      island_list[[1]] = list(island_age = total_time,not_present = M, stt_all = stt_all)

    }

    several_islands[[rep]] = island_list
    if (verbose == TRUE) {
      message(
        "Island being formatted: ", rep, "/", length(island_replicates)
      )
    }
  }
  return(several_islands)
}
