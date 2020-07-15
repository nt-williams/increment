
estimate_m <- function(train, valid, delta, trt, outcome, node_list, max,
                       tau, prop, hold, outcome_type, learners = NULL) {

  if (tau > 0) {

    # setup
    if (is.null(hold)) {
      hold <- matrix(nrow = nrow(valid), ncol = tau)
    }

    pseudo    <- paste0("psi", tau)
    fit_task  <- initiate_sl3_task(train, outcome, node_list[[tau]], outcome_type, NULL)
    ton_task  <- initiate_sl3_task(turn_on(train, trt[[tau]]), NULL, node_list[[tau]], NULL, NULL)
    toff_task <- initiate_sl3_task(turn_off(train, trt[[tau]]), NULL, node_list[[tau]], NULL, NULL)
    von_task  <- initiate_sl3_task(turn_on(valid, trt[[tau]]), NULL, node_list[[tau]], NULL, NULL)
    voff_task <- initiate_sl3_task(turn_off(valid, trt[[tau]]), NULL, node_list[[tau]], NULL, NULL)
    ensemble  <- initiate_ensemble(outcome_type, learners)

    # run SL
    fit <- run_ensemble(ensemble, fit_task, envir = environment())

    # training pseudo outcome
    train[, pseudo] <-
      construct_pseudo(
        delta,
        predict_sl3(fit, ton_task, envir = environment()),
        predict_sl3(fit, toff_task, envir = environment()),
        prop$train[, tau]
      )

    # validation pseudo
    hold[, tau] <-
      construct_pseudo(
        delta,
        predict_sl3(fit, von_task, envir = environment()),
        predict_sl3(fit, voff_task, envir = environment()),
        prop$valid[, tau]
      )

    # recursion
    estimate_m(train, valid, delta, trt, pseudo, node_list, max,
               tau - 1, prop, hold, "continuous", learners)
  } else {
    return(hold)
  }
}
