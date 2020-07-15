
estimate_r <- function(data, trt, tau, node_list, learners = NULL) {

  # global setup
  n    <- nrow(data)
  pred <- matrix(nrow = n, ncol = tau)

  for (t in 1:tau) {
    # create sl3 tasks
    fit_task <- initiate_sl3_task(data, trt, node_list[[t]], "binomial", NULL)
    ensemble <- initiate_ensemble("binomial", learners)

    # run SL
    fit <- run_ensemble(ensemble, fit_task, envir = environment())

    # propensities
    pred[, t] <- predict_sl3(fit, fit_task, envir = environment())
  }

  out <- list(propensity = pred)

  # returns
  return(out)
}
