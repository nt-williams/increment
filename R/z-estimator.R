
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

  pb <- progressr::progressor(meta$tau*folds*2)

  # propensity --------------------------------------------------------------

  prop <- cf_r(meta$data, trt, meta$tau, meta$node_list$trt, learners_trt, folds, pb)
  wgts <- construct_weights(data, trt, delta, recombine_prop(prop, meta$folds), meta$tau)

  # outcome regression ------------------------------------------------------

  ocr <- cf_m(meta$data, delta, trt, outcome, meta$node_list$outcome, meta$tau,
              meta$tau, prop, meta$outcome_type, learners_outcome, folds, pb)

  # estimator ---------------------------------------------------------------

  compute_psi(
    compute_rho(
      data, trt, outcome, delta, recombine_prop(prop, meta$folds),
      wgts, recombine_pseudo(ocr, meta$folds), meta$tau
    )
  )

}
