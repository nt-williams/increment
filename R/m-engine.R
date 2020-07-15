
estimate_m <- function(data, delta, static_on, static_off, outcome,
                       node_list, max, tau, prop, outcome_type, learners = NULL) {

  if (tau > 0) {
    # setup
    pseudo   <- paste0("psi", tau)
    fit_task <- initiate_sl3_task(data, outcome, node_list[[tau]], outcome_type, NULL)
    on_task  <- initiate_sl3_task(static_on, NULL, node_list[[tau]], NULL, NULL)
    off_task <- initiate_sl3_task(static_off, NULL, node_list[[tau]], NULL, NULL)
    ensemble <- initiate_ensemble(outcome_type, learners)

    # run SL
    fit <- run_ensemble(ensemble, fit_task, envir = environment())

    # predict on data
    m1 <- predict_sl3(fit, on_task, envir = environment())
    m0 <- predict_sl3(fit, off_task, envir = environment())

    # pseudo outcome
    data[, pseudo] <- construct_pseudo(delta, m1, m0, prop$propensity[, tau])

    # recursion
    estimate_m(data, delta, static_on, static_off, pseudo,
               node_list, max, tau - 1, prop, "continuous", learners)
  } else {
    out <- list(preds = data[, paste0("psi", 1:max), drop = FALSE])
    return(out)
  }
}
