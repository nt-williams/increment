
estimate_r <- function(train, valid, trt, tau, node_list, learners = NULL, progress) {

  # global setup
  tpred <- matrix(nrow = nrow(train), ncol = tau)
  vpred <- matrix(nrow = nrow(valid), ncol = tau)

  for (t in 1:tau) {
    # create sl3 tasks
    fit_task <- initiate_sl3_task(train, trt[t], node_list[[t]], "binomial", NULL)
    prd_task <- initiate_sl3_task(valid, NULL, node_list[[t]], NULL, NULL)
    ensemble <- initiate_ensemble("binomial", learners)

    # run SL
    fit <- run_ensemble(ensemble, fit_task, envir = environment())

    # propensities training
    tpred[, t] <- predict_sl3(fit, fit_task, envir = environment())
    vpred[, t] <- predict_sl3(fit, prd_task, envir = environment())

    # update progress bar
    progress()
  }

  out <- list(train = tpred,
              valid = vpred)

  # returns
  return(out)
}
