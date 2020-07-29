
#' Incremental Propensity Score Z-Estimator
#'
#' @param data A data frame in wide format containing all necessary variables
#'  for the estimation problem.
#' @param trt A vector containing the column names of treatment variables ordered by time.
#' @param outcome The column name of the outcome variable.
#' @param baseline An optional vector of columns names of baseline covariates to be
#'  included for adjustment at every timepoint.
#' @param time_vary A list the same length as the number of time points of observation with
#'  the column names for new time-varying covariates introduced at each time point. The list
#'  should be ordered following the time ordering of the model.
#' @param delta A sequence of increment values for the propensity.
#' @param k An integer specifying how previous time points should be
#'  used for estimation at the given time point. Default is \code{Inf},
#'  all time points.
#' @param outcome_type Outcome variable type (i.e., continuous, binomial).
#' @param id An optional column name containing cluster level identifiers.
#' @param learners_outcome An optional \code{sl3} learner stack for estimation of the outcome
#'  regression. If not specified, will default to using a generalized linear model.
#' @param learners_trt An optional \code{sl3} learner stack for estimation of the exposure
#'  mechanism. If not specified, will default to using a generalized linear model.
#' @param folds The number of folds to be used for cross-fitting. Minimum allowable number
#' is two folds.
#'
#' @return A list of class \code{increment} containing the following components:
#'
#' \item{estimates}{A data.frame with the same number of rows as \code{delta} containing intervention estimates.}
#' \item{eif}{A list the same length as delta containing observation values of the influence function.}
#' \item{mult_cv}{Multiplier bootstrap critical value.}
#' @export
#'
#' @references Kennedy EH. Nonparametric causal effects based on incremental
#' propensity score interventions.
#' \href{https://arxiv.org/abs/1704.00211}{arxiv:1704.00211}
#'
#' @examples
#' # TO DO
increment <- function(data, trt, outcome, baseline, time_vary = NULL, delta, k = Inf,
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

  pb <- progressr::progressor(meta$tau*folds*length(delta) + meta$tau*folds)

  # propensity --------------------------------------------------------------

  prop <- cf_r(meta$data, trt, meta$tau, meta$node_list$trt, learners_trt, folds, pb)
  wgts <- construct_weights(data, trt, delta, recombine_prop(prop, meta$folds), meta$tau)

  # outcome regression ------------------------------------------------------

  ocr <- revert_list(cf_m(meta$data, delta, trt, outcome, meta$node_list$outcome, meta$tau,
                          meta$tau, prop, meta$outcome_type, learners_outcome, folds, pb))

  # estimator ---------------------------------------------------------------

  out <- compute_psi(
    list(
      n = nrow(data),
      delta = delta,
      eif = compute_rho(
        data, trt, outcome, delta, recombine_prop(prop, meta$folds),
        wgts, recombine_pseudo(ocr, meta$folds), meta$tau
      )
    )
  )

  out
}
