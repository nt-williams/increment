
increment <- function(data, trt, outcome, baseline, time_vary, delta, k = Inf,
                      outcome_type = c("binomial", "continuous"), id = NULL,
                      learners_outcome = NULL, learners_trt = NULL, folds = 10) {

  # setup -------------------------------------------------------------------

  meta <- Meta$new(
    data = data,
    trt = trt,
    outcome = outcome,
    baseline = baseline,
    time_vary = time_vary,
    delta = delta,
    k = k,
    learners_trt = learners_trt,
    learners_outcome = learners_outcome,
    id = id,
    outcome_type = match.arg(outcome_type),
    folds = folds
  )

  # propensity --------------------------------------------------------------

  prop <- estimate_r(meta$data, meta$trt, meta$tau, meta$node_list$trt, learners_trt)

  wgts <- lapply(delta, function(x) {
    construct_weights(meta$data, meta$trt, x, prop, meta$tau)
  })

  # outcome regression ------------------------------------------------------

  ocr <- lapply(delta, function(x) {
    estimate_m(meta$data, x, meta$data_on, meta$data_off, outcome,
               meta$node_list$outcome, meta$tau, meta$tau, prop,
               meta$outcome_type, learners_outcome)
  })

  # estimator ---------------------------------------------------------------

  mapply(function(x, y, z) {
    compute_psi(compute_rho(meta$data, meta$trt, outcome, x, prop, y, z, meta$tau))
  }, x = delta, y = wgts, z = ocr, SIMPLIFY = FALSE)

}
