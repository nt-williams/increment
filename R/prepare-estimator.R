
Meta <- R6::R6Class(
  "Meta",
  public = list(
    data = NULL,
    node_list = NULL,
    n = NULL,
    tau = NULL,
    id = NULL,
    outcome_type = NULL,
    folds = NULL,
    weights_m = NULL,
    weights_r = NULL,
    initialize = function(data, trt, outcome, baseline, time_vary, k,
                          delta, learners_trt, learners_outcome, id,
                          outcome_type = NULL, folds = 10) {

      tau <- determine_tau(trt)

      # initial checks
      check_for_variables(data, trt, outcome, baseline, time_vary)
      # check_missing_data(data, trt, outcome, time_vary, baseline)
      check_folds(folds)
      check_time_vary(time_vary)
      check_estimation_engine(learners_trt, learners_outcome)

      # general setup
      self$n            <- nrow(data)
      self$tau          <- tau
      self$node_list    <- create_node_list(trt, tau, time_vary, baseline, k)
      self$outcome_type <- outcome_type
      # self$id         <- data[[id]]

      # cross validation setup
      self$folds <- V <- setup_cv(data, NULL, folds)
      self$data  <- get_folded_data(data, V)
    #
    #   self$weights_m <- hold_lrnr_weights(V)
    #   self$weights_r <- hold_lrnr_weights(V)
    }
  )
)
